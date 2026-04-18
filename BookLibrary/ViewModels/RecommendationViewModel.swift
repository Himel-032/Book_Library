//
//  RecommendationViewModel.swift
//  BookLibrary
//
//  Created by Himel on 13/4/26.
//

import Foundation

final class RecommendationViewModel: ObservableObject {
    @Published var recommendations: [Book] = []
    @Published var newRecommendationCount: Int = 0
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let apiService = APIService.shared
    private let tracker = RecommendationTracker.shared

    func loadRecommendations(for userId: String, markSeenAfterLoad: Bool = false) {
        guard !userId.isEmpty else {
            recommendations = []
            newRecommendationCount = 0
            return
        }

        isLoading = true
        errorMessage = nil

        let preferred = tracker.topCategories(for: userId, limit: 3)
        let categories = preferred.isEmpty ? ["fiction", "history", "science"] : preferred

        fetchSequentially(categories: categories, index: 0, collected: []) { [weak self] books in
            guard let self else { return }
            self.isLoading = false
            self.recommendations = Array(books.prefix(24))
            self.updateNewRecommendationCount(for: userId)

            if markSeenAfterLoad {
                self.markCurrentAsSeen(for: userId)
            }
        }
    }

    func markCurrentAsSeen(for userId: String) {
        let ids = recommendations.map { $0.id }
        tracker.markRecommendationsSeen(ids, userId: userId)
        newRecommendationCount = 0
    }

    private func updateNewRecommendationCount(for userId: String) {
        let seen = tracker.seenRecommendationIds(for: userId)
        let unseen = recommendations.filter { !seen.contains($0.id) }
        newRecommendationCount = unseen.count
    }

    private func fetchSequentially(
        categories: [String],
        index: Int,
        collected: [Book],
        completion: @escaping ([Book]) -> Void
    ) {
        guard index < categories.count else {
            completion(uniqueBooks(from: collected))
            return
        }

        apiService.fetchBooks(category: categories[index], maxResults: 14) { [weak self] result in
            switch result {
            case .success(let books):
                self?.fetchSequentially(
                    categories: categories,
                    index: index + 1,
                    collected: collected + books,
                    completion: completion
                )
            case .failure:
                self?.fetchSequentially(
                    categories: categories,
                    index: index + 1,
                    collected: collected,
                    completion: completion
                )
            }
        }
    }

    private func uniqueBooks(from books: [Book]) -> [Book] {
        var seen = Set<String>()
        var unique: [Book] = []

        for book in books {
            if seen.insert(book.id).inserted {
                unique.append(book)
            }
        }

        return unique
    }
}
