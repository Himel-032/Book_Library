//
//  CoreDataManager.swift
//  BookLibrary
//
//  Created by macos on 25/2/26.
//

import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    // MARK: - Current User
    private var currentUserId: String = ""
    
    func setCurrentUser(userId: String) {
        self.currentUserId = userId
        print("CoreData user set to: \(userId)")
    }
    
    func clearCurrentUser() {
        self.currentUserId = ""
        print("CoreData user cleared")
    }
    
    var isUserLoggedIn: Bool {
        return !currentUserId.isEmpty
    }
    
    //  Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BookLibrary")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    //  Context
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var context: NSManagedObjectContext {
        return viewContext
    }
    
    private init() {}
    
    //  Save Context
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("Context saved successfully")
                NotificationCenter.default.post(name: NSNotification.Name("CoreDataDataChanged"), object: nil)
            } catch {
                let nserror = error as NSError
                print("Error saving context: \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //  User-Specific Predicates
    private func userPredicate() -> NSPredicate {
        return NSPredicate(format: "userId == %@", currentUserId)
    }
    
    private func userAndIdPredicate(bookId: String) -> NSPredicate {
        return NSPredicate(format: "id == %@ AND userId == %@", bookId, currentUserId)
    }
    
    private func userAndFavoritePredicate() -> NSPredicate {
        return NSPredicate(format: "userId == %@ AND isFavorite == YES", currentUserId)
    }
    
    private func userAndFinishedPredicate() -> NSPredicate {
        return NSPredicate(format: "userId == %@ AND isFinished == YES", currentUserId)
    }
    
    private func userAndReadingPredicate() -> NSPredicate {
        return NSPredicate(format: "userId == %@ AND isFavorite == YES AND isFinished == NO", currentUserId)
    }
    
    // Validation
    private func validateUser() -> Bool {
        guard !currentUserId.isEmpty else {
            print("No user logged in")
            return false
        }
        return true
    }
    
    //  Book Favorites (User-Specific)
    
    func saveFavorite(book: Book) {
        guard validateUser() else { return }
        
        // Check if book already exists for this user
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.predicate = userAndIdPredicate(bookId: book.id)
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            
            if let existingEntity = results.first {
                // Book exists, just update favorite status (preserve finished)
                existingEntity.isFavorite = true
                saveContext()
                print("✅ Updated favorite for user \(currentUserId): \(book.volumeInfo.title)")
            } else {
                // Create new entity with user ID
                let entity = BookEntity(context: viewContext)
                entity.id = book.id
                entity.userId = currentUserId
                entity.title = book.volumeInfo.title
                entity.authors = book.volumeInfo.authorNames
                entity.bookDescription = book.volumeInfo.description
                entity.thumbnailUrl = book.volumeInfo.thumbnailUrl?.absoluteString
                entity.publisher = book.volumeInfo.publisher
                entity.publishedDate = book.volumeInfo.publishedDate
                entity.pageCount = Int16(book.volumeInfo.pageCount ?? 0)
                entity.categories = book.volumeInfo.categoryList
                entity.isFavorite = true
                entity.isFinished = false
                entity.dateAdded = Date()
                
                saveContext()
                print("Saved new favorite for user \(currentUserId): \(book.volumeInfo.title)")
            }
        } catch {
            print("Error saving favorite: \(error)")
        }
    }
    
    func removeFavorite(bookId: String) {
        guard validateUser() else { return }
        
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.predicate = userAndIdPredicate(bookId: bookId)
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            for object in results {
                if object.isFinished {
                    // Keep the book (for finished tracking) but remove favorite
                    object.isFavorite = false
                } else {
                    // Not finished, delete completely
                    viewContext.delete(object)
                }
            }
            saveContext()
            print("Removed favorite for user \(currentUserId)")
        } catch {
            print("Error removing favorite: \(error)")
        }
    }
    
    func isFavorite(bookId: String) -> Bool {
        guard validateUser() else { return false }
        
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND userId == %@ AND isFavorite == YES", bookId, currentUserId)
        
        do {
            let count = try viewContext.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking favorite: \(error)")
            return false
        }
    }
    
    func fetchFavorites() -> [BookEntity] {
        guard validateUser() else { return [] }
        
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.predicate = userAndFavoritePredicate()
        let sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            print("Fetched \(results.count) favorites for user \(currentUserId)")
            return results
        } catch {
            print("Error fetching favorites: \(error)")
            return []
        }
    }
    
    func toggleFavorite(book: Book) -> Bool {
        if isFavorite(bookId: book.id) {
            removeFavorite(bookId: book.id)
            return false
        } else {
            saveFavorite(book: book)
            return true
        }
    }
    
    // MARK: - Finished Book Tracking (User-Specific)
    
    func toggleFinished(bookId: String, book: Book? = nil) -> Bool {
        guard validateUser() else { return false }
        
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.predicate = userAndIdPredicate(bookId: bookId)
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            
            if let entity = results.first {
                // Book exists, just toggle finished
                entity.isFinished.toggle()
                saveContext()
                print("Toggled finished for user \(currentUserId): \(entity.title ?? ""), now: \(entity.isFinished)")
                return entity.isFinished
            } else if let book = book {
                // Book doesn't exist - create it with user ID
                let entity = BookEntity(context: viewContext)
                entity.id = book.id
                entity.userId = currentUserId
                entity.title = book.volumeInfo.title
                entity.authors = book.volumeInfo.authorNames
                entity.bookDescription = book.volumeInfo.description
                entity.thumbnailUrl = book.volumeInfo.thumbnailUrl?.absoluteString
                entity.publisher = book.volumeInfo.publisher
                entity.publishedDate = book.volumeInfo.publishedDate
                entity.pageCount = Int16(book.volumeInfo.pageCount ?? 0)
                entity.categories = book.volumeInfo.categoryList
                entity.isFavorite = false
                entity.isFinished = true
                entity.dateAdded = Date()
                
                saveContext()
                print("Created new finished book for user \(currentUserId): \(entity.title ?? "")")
                return true
            }
        } catch {
            print("Error toggling finished: \(error)")
        }
        return false
    }
    
    func isFinished(bookId: String) -> Bool {
        guard validateUser() else { return false }
        
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND userId == %@ AND isFinished == YES", bookId, currentUserId)
        
        do {
            let count = try viewContext.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking finished: \(error)")
            return false
        }
    }
    
    // MARK: - Stats (User-Specific)
    
    func getFinishedBooksCount() -> Int {
        guard validateUser() else { return 0 }
        
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.predicate = userAndFinishedPredicate()
        
        do {
            return try viewContext.count(for: fetchRequest)
        } catch {
            print("Error counting finished books: \(error)")
            return 0
        }
    }
    
    func getCurrentlyReadingCount() -> Int {
        guard validateUser() else { return 0 }
        
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.predicate = userAndReadingPredicate()
        
        do {
            return try viewContext.count(for: fetchRequest)
        } catch {
            print("Error counting currently reading: \(error)")
            return 0
        }
    }
    
    func getReadingStreak() -> Int {
        guard validateUser() else { return 0 }
        
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.predicate = userAndFinishedPredicate()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: true)]
        
        do {
            let finishedBooks = try viewContext.fetch(fetchRequest)
            
            if finishedBooks.isEmpty {
                return 0
            }
            
            let calendar = Calendar.current
            var streak = 1
            var currentStreak = 1
            var lastDate = finishedBooks.first?.dateAdded ?? Date()
            
            for book in finishedBooks.dropFirst() {
                if let date = book.dateAdded {
                    let days = calendar.dateComponents([.day], from: lastDate, to: date).day ?? 0
                    if days <= 1 {
                        currentStreak += 1
                        streak = max(streak, currentStreak)
                    } else {
                        currentStreak = 1
                    }
                    lastDate = date
                }
            }
            
            return streak
        } catch {
            print("Error calculating streak: \(error)")
            return 0
        }
    }
    
    func getAllStats() -> (finished: Int, reading: Int, streak: Int) {
        return (getFinishedBooksCount(), getCurrentlyReadingCount(), getReadingStreak())
    }
    
    // MARK: - Clear User Data (Called on logout)
    func clearUserData() {
        // We don't delete data, just clear the user ID reference
        // Data remains in Core Data but won't be accessible without userId
        clearCurrentUser()
    }
    
    // MARK: - Debug Helpers
    func printAllBooks() {
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        
        do {
            let books = try viewContext.fetch(fetchRequest)
            print("All books in Core Data (\(books.count)):")
            for book in books {
                print("   - User: \(book.userId ?? "nil"), \(book.title ?? "Unknown"): fav=\(book.isFavorite), fin=\(book.isFinished)")
            }
        } catch {
            print("Error fetching books: \(error)")
        }
    }
    
    func printCurrentUserBooks() {
        guard validateUser() else {
            print("No user logged in")
            return
        }
        
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.predicate = userPredicate()
        
        do {
            let books = try viewContext.fetch(fetchRequest)
            print("Books for user \(currentUserId) (\(books.count)):")
            for book in books {
                print("   - \(book.title ?? "Unknown"): fav=\(book.isFavorite), fin=\(book.isFinished)")
            }
        } catch {
            print("Error fetching books: \(error)")
        }
    }
}
