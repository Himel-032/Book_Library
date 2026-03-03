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
        "Business", "Art", "Philosophy", "Religion", "Travel"
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
        
        apiService.fetchBooks(category: apiCategory, maxResults: 30) { [weak self] result in
            self?.isLoading = false
            
            switch result {
            case .success(let books):
                self?.books = books
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                // Load from cache if API fails
                self?.loadCachedBooks()
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
        
        apiService.searchBooks(query: query, maxResults: 20) { [weak self] result in
            self?.isLoading = false
            
            switch result {
            case .success(let books):
                self?.searchResults = books
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    // MARK: - Load Cached Books (from Core Data)
    func loadCachedBooks() {
        // This is for offline mode - will be implemented with Core Data
        // For now, just show a message
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
