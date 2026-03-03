//
//  BookListView.swift
//  BookLibrary
//
//  Created by macos on 25/2/26.
//

import SwiftUI

struct BookListView: View {
    
    @StateObject private var bookViewModel = BookViewModel()
    @State private var selectedCategory = "All"
    @State private var isSearching = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                // Search Bar
                searchBar
                
                // Category Picker
                categoryPicker
                
                // Book List
                ZStack {
                    bookList
                    
                    // Loading Indicator
                    if bookViewModel.isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black.opacity(0.1))
                    }
                }
            }
            .navigationTitle("Library")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FavoritesView()) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                    }
                }
            }
            .onAppear {
                if bookViewModel.books.isEmpty {
                    bookViewModel.fetchBooks(category: selectedCategory)
                }
            }
            .alert("Error", isPresented: .constant(bookViewModel.errorMessage != nil)) {
                Button("OK") {
                    bookViewModel.errorMessage = nil
                }
                Button("Retry") {
                    bookViewModel.fetchBooks(category: selectedCategory)
                }
            } message: {
                Text(bookViewModel.errorMessage ?? "")
            }
        }
    }
    
    // MARK: - Search Bar
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search books...", text: $bookViewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onTapGesture {
                    isSearching = true
                }
            
            if !bookViewModel.searchText.isEmpty {
                Button(action: {
                    bookViewModel.clearSearch()
                    isSearching = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
    
    // MARK: - Category Picker
    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(bookViewModel.categories, id: \.self) { category in
                    categoryButton(category)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
    }
    
    private func categoryButton(_ category: String) -> some View {
        Button(action: {
            selectedCategory = category
            bookViewModel.fetchBooks(category: category)
        }) {
            Text(category)
                .font(.caption)
                .fontWeight(selectedCategory == category ? .bold : .regular)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(selectedCategory == category ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(selectedCategory == category ? .white : .primary)
                .cornerRadius(15)
        }
    }
    
    // MARK: - Book List
    @ViewBuilder
    private var bookList: some View {
        let displayBooks = bookViewModel.booksForCurrentMode(isSearching: isSearching)
        
        if displayBooks.isEmpty && !bookViewModel.isLoading {
            VStack(spacing: 20) {
                Image(systemName: "book.closed")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                Text(isSearching ? "No books found" : "No books available")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                if isSearching {
                    Button("Clear Search") {
                        bookViewModel.clearSearch()
                        isSearching = false
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List(displayBooks) { book in
                BookRowView(book: book, bookViewModel: bookViewModel)
                    .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
            }
            .listStyle(PlainListStyle())
            .refreshable {
                bookViewModel.fetchBooks(category: selectedCategory)
            }
        }
    }
}
