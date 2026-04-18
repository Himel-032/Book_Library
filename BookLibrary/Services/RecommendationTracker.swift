//
//  RecommendationTracker.swift
//  BookLibrary
//
//  Created by Himel on 13/4/26.
//

import Foundation

final class RecommendationTracker {
    static let shared = RecommendationTracker()

    private let defaults = UserDefaults.standard
    private let knownCategories: [String] = [
        "fiction", "non-fiction", "science", "technology", "history", "biography",
        "fantasy", "mystery", "romance", "business", "art", "philosophy"
    ]

    private init() {}

    // MARK: - Public Tracking

    func trackSearchQuery(_ query: String, userId: String) {
        let tokens = extractCategories(from: query)
        for token in tokens {
            incrementCategory(token, by: 2, userId: userId)
        }
    }

    func trackBrowsedCategory(_ category: String, userId: String) {
        incrementCategory(category, by: 3, userId: userId)
    }

    func trackViewedBook(_ book: Book, userId: String) {
        categories(for: book).forEach { incrementCategory($0, by: 1, userId: userId) }
    }

    func trackReadingBook(_ book: Book, userId: String) {
        categories(for: book).forEach { incrementCategory($0, by: 4, userId: userId) }
    }

    func topCategories(for userId: String, limit: Int = 3) -> [String] {
        let sorted = categoryWeights(for: userId)
            .sorted { lhs, rhs in
                if lhs.value != rhs.value {
                    return lhs.value > rhs.value
                }
                return lhs.key < rhs.key
            }

        return Array(sorted.prefix(limit).map { $0.key })
    }

    // MARK: - Seen Recommendations

    func seenRecommendationIds(for userId: String) -> Set<String> {
        Set(defaults.stringArray(forKey: seenIdsKey(for: userId)) ?? [])
    }

    func markRecommendationsSeen(_ ids: [String], userId: String) {
        guard !ids.isEmpty else { return }
        var merged = seenRecommendationIds(for: userId)
        ids.forEach { merged.insert($0) }
        defaults.set(Array(merged), forKey: seenIdsKey(for: userId))
    }

    // MARK: - Private

    private func categories(for book: Book) -> [String] {
        let raw = book.volumeInfo.categories ?? []
        if raw.isEmpty {
            return ["fiction"]
        }

        let normalized = raw.map(normalizeCategory).filter { !$0.isEmpty }
        return normalized.isEmpty ? ["fiction"] : normalized
    }

    private func extractCategories(from query: String) -> [String] {
        let lower = query.lowercased()

        var matches = Set<String>()
        for category in knownCategories {
            if lower.contains(category) {
                matches.insert(category)
            }
        }

        if lower.contains("bangladesh") || lower.contains("bangladeshi") {
            matches.insert("history")
            matches.insert("fiction")
        }

        return Array(matches)
    }

    private func incrementCategory(_ category: String, by amount: Int, userId: String) {
        let normalized = normalizeCategory(category)
        guard !normalized.isEmpty else { return }

        var map = categoryWeights(for: userId)
        map[normalized, default: 0] += amount
        defaults.set(map, forKey: categoryWeightsKey(for: userId))
    }

    private func normalizeCategory(_ category: String) -> String {
        category
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .replacingOccurrences(of: "_", with: "-")
    }

    private func categoryWeights(for userId: String) -> [String: Int] {
        defaults.dictionary(forKey: categoryWeightsKey(for: userId)) as? [String: Int] ?? [:]
    }

    private func categoryWeightsKey(for userId: String) -> String {
        "rec.category.weights.\(userId)"
    }

    private func seenIdsKey(for userId: String) -> String {
        "rec.seen.ids.\(userId)"
    }
}
