//
//  FavoritesView.swift
//  BookLibrary
//
//  Created by Dipta on 23/2/26.
//

import SwiftUI
import CoreData

struct FavoritesView: View {
    
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    @State private var showingClearAlert = false
    @State private var selectedBook: Book?
    @State private var showDetail = false
    
    var body: some View {
        ZStack {
            if favoritesViewModel.isLoading {
                ProgressView("Loading favorites...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else if favoritesViewModel.isEmpty {
                emptyStateView
            } else {
                favoritesList
            }
        }
        // REMOVED: .navigationTitle("Favorites")
        // REMOVED: .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !favoritesViewModel.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingClearAlert = true }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .alert("Clear All Favorites", isPresented: $showingClearAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                withAnimation {
                    favoritesViewModel.clearAllFavorites()
                }
            }
        } message: {
            Text("Are you sure you want to remove all favorites?")
        }
        .onAppear {
            favoritesViewModel.loadFavorites()
        }
        .sheet(isPresented: $showDetail) {
            if let book = selectedBook {
                BookDetailView(
                    book: book,
                    bookViewModel: BookViewModel()
                )
            }
        }
    }
    
    // MARK: - Favorites List
    private var favoritesList: some View {
        List {
            ForEach(favoritesViewModel.favorites, id: \.objectID) { entity in
                FavoriteRowView(
                    entity: entity,
                    onSelect: {
                        if let book = convertEntityToBook(entity) {
                            selectedBook = book
                            showDetail = true
                        }
                    }
                )
            }
            .onDelete { indexSet in
                deleteFavorites(at: indexSet)
            }
        }
        .listStyle(PlainListStyle())
        .refreshable {
            favoritesViewModel.loadFavorites()
        }
    }
    
    // MARK: - Empty State View
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .font(.system(size: 70))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("No Favorites Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Books you mark as favorite will appear here")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            NavigationLink(destination: BookListView()) {
                Text("Browse Books")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 10)
        }
    }
    
    // MARK: - Delete Favorites
    private func deleteFavorites(at offsets: IndexSet) {
        for index in offsets {
            let entity = favoritesViewModel.favorites[index]
            if let bookId = entity.id {
                favoritesViewModel.removeFavorite(bookId: bookId)
            }
        }
    }
    
    // MARK: - Convert Entity to Book
    private func convertEntityToBook(_ entity: BookEntity) -> Book? {
        guard let id = entity.id, let title = entity.title else {
            return nil
        }
        
        // Parse authors
        let authorsArray: [String]
        if let authorsString = entity.authors as? String {
            authorsArray = authorsString.components(separatedBy: ", ")
        } else {
            authorsArray = ["Unknown Author"]
        }
        
        // Parse categories
        let categoriesArray: [String]?
        if let categoriesString = entity.categories as? String {
            categoriesArray = categoriesString.components(separatedBy: ", ")
        } else {
            categoriesArray = nil
        }
        
        // Create ImageLinks
        let imageLinks = ImageLinks(
            smallThumbnail: entity.thumbnailUrl,
            thumbnail: entity.thumbnailUrl,
            small: nil,
            medium: nil,
            large: nil,
            extraLarge: nil
        )
        
        // Construct Google Books preview link
        let previewLink = "https://books.google.com/books?id=\(id)"
        
        // Create VolumeInfo
        let volumeInfo = VolumeInfo(
            title: title,
            subtitle: nil,
            authors: authorsArray,
            publisher: entity.publisher,
            publishedDate: entity.publishedDate,
            description: entity.bookDescription,
            pageCount: Int(entity.pageCount),
            categories: categoriesArray,
            imageLinks: imageLinks,
            language: nil,
            previewLink: previewLink,
            infoLink: previewLink,
            canonicalVolumeLink: previewLink
        )
        
        return Book(id: id, volumeInfo: volumeInfo, accessInfo: nil)
    }
}

// MARK: - Favorite Row View
struct FavoriteRowView: View {
    
    let entity: BookEntity
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                
                // Thumbnail
                favoriteThumbnail
                    .frame(width: 50, height: 70)
                    .cornerRadius(6)
                
                // Details
                VStack(alignment: .leading, spacing: 4) {
                    Text(entity.title ?? "Unknown Title")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    // Display authors
                    if let authors = entity.authors as? String {
                        Text(authors)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    } else {
                        Text("Unknown Author")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    if let dateAdded = entity.dateAdded {
                        Text("Added: \(dateAdded, formatter: dateFormatter)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Thumbnail
    @ViewBuilder
    private var favoriteThumbnail: some View {
        if let urlString = entity.thumbnailUrl,
           let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 50, height: 70)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 70)
                        .clipped()
                case .failure:
                    fallbackImage
                @unknown default:
                    fallbackImage
                }
            }
        } else {
            fallbackImage
        }
    }
    
    private var fallbackImage: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 50, height: 70)
            
            Image(systemName: "book.closed")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 35)
                .foregroundColor(.gray)
        }
    }
}

// MARK: - Date Formatter
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()
