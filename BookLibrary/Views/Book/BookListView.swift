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
    @State private var selectedBook: Book?
    @State private var showDetail = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            searchBar
            
            // Category Picker
            categoryPicker
            
            // Book List
            ZStack {
                if bookViewModel.isLoading && bookViewModel.books.isEmpty {
                    loadingView
                } else {
                    bookList
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
            print("BookListView appeared")
            if bookViewModel.books.isEmpty {
                print("Fetching books for category: \(selectedCategory)")
                bookViewModel.fetchBooks(category: selectedCategory == "All" ? "fiction" : selectedCategory)
            }
        }
        .alert("Error", isPresented: .constant(bookViewModel.errorMessage != nil)) {
            Button("OK") {
                bookViewModel.errorMessage = nil
            }
            Button("Retry") {
                let apiCategory = selectedCategory == "All" ? "fiction" : selectedCategory
                bookViewModel.fetchBooks(category: apiCategory)
            }
        } message: {
            Text(bookViewModel.errorMessage ?? "")
        }
        // FIXED: Removed 'return' and simplified sheet
        .sheet(isPresented: $showDetail) {
            if let book = selectedBook {
                BookDetailView(book: book, bookViewModel: bookViewModel)
            }
        }
    }
    
    //  Loading View
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
            
            Text("Loading books...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    //  Search Bar
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search books...", text: $bookViewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onSubmit {
                    if !bookViewModel.searchText.isEmpty {
                        isSearching = true
                        bookViewModel.searchBooks(query: bookViewModel.searchText)
                    }
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
    
    //  Category Picker
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
            isSearching = false
            bookViewModel.clearSearch()
            let apiCategory = category == "All" ? "fiction" : category
            print("Category selected: \(category), fetching: \(apiCategory)")
            bookViewModel.fetchBooks(category: apiCategory)
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
    
    //  Book List
    @ViewBuilder
    private var bookList: some View {
        let displayBooks = bookViewModel.booksForCurrentMode(isSearching: isSearching)
        
        if displayBooks.isEmpty && !bookViewModel.isLoading {
            emptyStateView
        } else {
            List(displayBooks) { book in
                BookRowView(book: book, bookViewModel: bookViewModel)
                    .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                    .onTapGesture {
                        print("Book tapped: \(book.volumeInfo.title)")
                        selectedBook = book
                        print("selectedBook set to: \(selectedBook?.volumeInfo.title ?? "nil")")
                        showDetail = true
                        print("showDetail set to: \(showDetail)")
                    }
            }
            .listStyle(PlainListStyle())
            .refreshable {
                let apiCategory = selectedCategory == "All" ? "fiction" : selectedCategory
                print("Refreshing with category: \(apiCategory)")
                bookViewModel.fetchBooks(category: apiCategory)
            }
        }
    }
    
    // Empty State View
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: isSearching ? "magnifyingglass" : "book.closed")
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
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            } else {
                Button("Refresh") {
                    let apiCategory = selectedCategory == "All" ? "fiction" : selectedCategory
                    bookViewModel.fetchBooks(category: apiCategory)
                }
                .font(.subheadline)
                .foregroundColor(.blue)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
