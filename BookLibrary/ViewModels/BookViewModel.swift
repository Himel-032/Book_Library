//
//  BookViewModel.swift
//  BookLibrary
//
//  Created by macos on 25/2/26.
//

import Foundation
import Combine
import CoreData

class BookViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var books: [Book] = []
    @Published var searchResults: [Book] = []
    @Published var favoriteBooks: [BookEntity] = []
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    
    @Published var selectedCategory = "All"
    
    // MARK: - Private Properties
    private let apiService = APIService.shared
    private var cancellables = Set<AnyCancellable>()
    private let coreDataManager = CoreDataManager.shared
    
    // MARK: - Categories
    let categories = [
        "All", "Fiction", "Non-Fiction", "Science", "Technology",
        "History", "Biography", "Fantasy", "Mystery", "Romance",
        "Business", "Art", "Philosophy"
    ]
    
    // MARK: - Initialization
    init() {
        // Setup search debouncing
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .sink { [weak self] query in
                self?.searchBooks(query: query)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Fetch Books by Category
    func fetchBooks(category: String) {
        isLoading = true
        errorMessage = nil
        
        var apiCategory = category.lowercased()
        if apiCategory == "all" {
            apiCategory = "fiction" // Default category
        }
        
        print("Fetching books for category: \(apiCategory)")
        
        apiService.fetchBooks(category: apiCategory, maxResults: 30) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let books):
                    print("Successfully fetched \(books.count) books")
                    self?.books = books
                case .failure(let error):
                    print("Error fetching books: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // MARK: - Search Books
    func searchBooks(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        print("Searching books for query: \(query)")
        
        apiService.searchBooks(query: query, maxResults: 20) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let books):
                    print("Successfully found \(books.count) books")
                    self?.searchResults = books
                case .failure(let error):
                    print("Error searching books: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // MARK: - Load Cached Books
    func loadCachedBooks() {
        errorMessage = "Showing cached data (offline mode)"
    }
    
    // MARK: - Clear Search
    func clearSearch() {
        searchText = ""
        searchResults = []
    }
    
    // MARK: - Get Books for Current View
    func booksForCurrentMode(isSearching: Bool) -> [Book] {
        if isSearching && !searchText.isEmpty {
            return searchResults
        } else {
            return books
        }
    }
}
