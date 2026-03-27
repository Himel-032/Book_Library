//
//  FavoritesViewModel.swift
//  BookLibrary
//
//  Created by Dipta on 23/2/26.
//

import Foundation
import CoreData
import Combine
import UIKit

class FavoritesViewModel: ObservableObject {
    
    @Published var favorites: [BookEntity] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let coreDataManager = CoreDataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadFavorites()
        
        // Observe for changes (when app returns from background)
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                self?.loadFavorites()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Load Favorites
    func loadFavorites() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.favorites = self?.coreDataManager.fetchFavorites() ?? []
            self?.isLoading = false
        }
    }
    
    // MARK: - Remove Favorite
    func removeFavorite(bookId: String) {
        coreDataManager.removeFavorite(bookId: bookId)
        loadFavorites() // Refresh list
    }
    
    // MARK: - Clear All Favorites
    func clearAllFavorites() {
        for favorite in favorites {
            coreDataManager.removeFavorite(bookId: favorite.id ?? "")
        }
        loadFavorites()
    }
    
    // MARK: - Check if Favorites Empty
    var isEmpty: Bool {
        return favorites.isEmpty
    }
    
    // MARK: - Get Book Count
    var count: Int {
        return favorites.count
    }
}
