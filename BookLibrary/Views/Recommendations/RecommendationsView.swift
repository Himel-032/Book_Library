//
//  RecommendationsView.swift
//  BookLibrary
//
//  Created by Himel on 13/4/26.
//

import SwiftUI

struct RecommendationsView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var recommendationViewModel = RecommendationViewModel()
    @StateObject private var bookViewModel = BookViewModel()
    @State private var selectedBook: Book?

    private var isDarkMode: Bool {
        themeManager.currentTheme == .dark
    }

    private var pageBackground: Color {
        isDarkMode ? Color(red: 0.08, green: 0.09, blue: 0.11) : Color(red: 0.97, green: 0.95, blue: 0.90)
    }

    private var primaryText: Color {
        isDarkMode ? Color.white : Color(red: 0.16, green: 0.14, blue: 0.13)
    }

    private var secondaryText: Color {
        isDarkMode ? Color.white.opacity(0.66) : Color(red: 0.46, green: 0.42, blue: 0.39)
    }

    var body: some View {
        ZStack {
            pageBackground.ignoresSafeArea()

            if recommendationViewModel.isLoading && recommendationViewModel.recommendations.isEmpty {
                VStack(spacing: 10) {
                    ProgressView()
                    Text("Loading recommendations...")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(secondaryText)
                }
            } else if recommendationViewModel.recommendations.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 36))
                        .foregroundColor(secondaryText)
                    Text("No recommendations yet")
                        .font(.system(size: 18, weight: .semibold, design: .serif))
                        .foregroundColor(primaryText)
                    Text("Browse, search and read books to get personalized recommendations.")
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)
                }
            } else {
                List(recommendationViewModel.recommendations) { book in
                    BookRowView(book: book, bookViewModel: bookViewModel)
                        .listRowBackground(Color.clear)
                        .onTapGesture {
                            selectedBook = book
                        }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
        }
        .navigationTitle("Recommendations")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            let uid = authViewModel.currentUserId
            recommendationViewModel.loadRecommendations(for: uid, markSeenAfterLoad: true)
        }
        .sheet(item: $selectedBook) { book in
            BookDetailView(book: book, bookViewModel: bookViewModel)
        }
    }
}
