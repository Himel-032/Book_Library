//
//  FavoritesView.swift
//  BookLibrary
//
//  Created by Dipta on 23/2/26.
//
//
//import SwiftUI
//import CoreData
//
//struct FavoritesView: View {
//    
//    @StateObject private var favoritesViewModel = FavoritesViewModel()
//    @State private var showingClearAlert = false
//    @State private var selectedBook: Book?
//    @State private var showDetail = false
//    
//    var body: some View {
//        ZStack {
//            if favoritesViewModel.isLoading {
//                ProgressView("Loading favorites...")
//                    .progressViewStyle(CircularProgressViewStyle())
//            } else if favoritesViewModel.isEmpty {
//                emptyStateView
//            } else {
//                favoritesList
//            }
//        }
//        // REMOVED: .navigationTitle("Favorites")
//        // REMOVED: .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            if !favoritesViewModel.isEmpty {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: { showingClearAlert = true }) {
//                        Image(systemName: "trash")
//                            .foregroundColor(.red)
//                    }
//                }
//            }
//        }
//        .alert("Clear All Favorites", isPresented: $showingClearAlert) {
//            Button("Cancel", role: .cancel) { }
//            Button("Clear", role: .destructive) {
//                withAnimation {
//                    favoritesViewModel.clearAllFavorites()
//                }
//            }
//        } message: {
//            Text("Are you sure you want to remove all favorites?")
//        }
//        .onAppear {
//            favoritesViewModel.loadFavorites()
//        }
//        .sheet(isPresented: $showDetail) {
//            if let book = selectedBook {
//                BookDetailView(
//                    book: book,
//                    bookViewModel: BookViewModel()
//                )
//            }
//        }
//    }
//    
//    // MARK: - Favorites List
//    private var favoritesList: some View {
//        List {
//            ForEach(favoritesViewModel.favorites, id: \.objectID) { entity in
//                FavoriteRowView(
//                    entity: entity,
//                    onSelect: {
//                        if let book = convertEntityToBook(entity) {
//                            selectedBook = book
//                            showDetail = true
//                        }
//                    }
//                )
//            }
//            .onDelete { indexSet in
//                deleteFavorites(at: indexSet)
//            }
//        }
//        .listStyle(PlainListStyle())
//        .refreshable {
//            favoritesViewModel.loadFavorites()
//        }
//    }
//    
//    // MARK: - Empty State View
//    private var emptyStateView: some View {
//        VStack(spacing: 20) {
//            Image(systemName: "heart.slash")
//                .font(.system(size: 70))
//                .foregroundColor(.gray.opacity(0.5))
//            
//            Text("No Favorites Yet")
//                .font(.title2)
//                .fontWeight(.semibold)
//            
//            Text("Books you mark as favorite will appear here")
//                .font(.body)
//                .foregroundColor(.gray)
//                .multilineTextAlignment(.center)
//                .padding(.horizontal, 40)
//            
//            NavigationLink(destination: BookListView()) {
//                Text("Browse Books")
//                    .fontWeight(.semibold)
//                    .foregroundColor(.white)
//                    .padding(.horizontal, 30)
//                    .padding(.vertical, 12)
//                    .background(Color.blue)
//                    .cornerRadius(10)
//            }
//            .padding(.top, 10)
//        }
//    }
//    
//    // MARK: - Delete Favorites
//    private func deleteFavorites(at offsets: IndexSet) {
//        for index in offsets {
//            let entity = favoritesViewModel.favorites[index]
//            if let bookId = entity.id {
//                favoritesViewModel.removeFavorite(bookId: bookId)
//            }
//        }
//    }
//    
//    // MARK: - Convert Entity to Book
//    private func convertEntityToBook(_ entity: BookEntity) -> Book? {
//        guard let id = entity.id, let title = entity.title else {
//            return nil
//        }
//        
//        // Parse authors
//        let authorsArray: [String]
//        if let authorsString = entity.authors as? String {
//            authorsArray = authorsString.components(separatedBy: ", ")
//        } else {
//            authorsArray = ["Unknown Author"]
//        }
//        
//        // Parse categories
//        let categoriesArray: [String]?
//        if let categoriesString = entity.categories as? String {
//            categoriesArray = categoriesString.components(separatedBy: ", ")
//        } else {
//            categoriesArray = nil
//        }
//        
//        // Create ImageLinks
//        let imageLinks = ImageLinks(
//            smallThumbnail: entity.thumbnailUrl,
//            thumbnail: entity.thumbnailUrl,
//            small: nil,
//            medium: nil,
//            large: nil,
//            extraLarge: nil
//        )
//        
//        // Construct Google Books preview link
//        let previewLink = "https://books.google.com/books?id=\(id)"
//        
//        // Create VolumeInfo
//        let volumeInfo = VolumeInfo(
//            title: title,
//            subtitle: nil,
//            authors: authorsArray,
//            publisher: entity.publisher,
//            publishedDate: entity.publishedDate,
//            description: entity.bookDescription,
//            pageCount: Int(entity.pageCount),
//            categories: categoriesArray,
//            imageLinks: imageLinks,
//            language: nil,
//            previewLink: previewLink,
//            infoLink: previewLink,
//            canonicalVolumeLink: previewLink
//        )
//        
//        return Book(id: id, volumeInfo: volumeInfo, accessInfo: nil)
//    }
//}
//
//// MARK: - Favorite Row View
//struct FavoriteRowView: View {
//    
//    let entity: BookEntity
//    let onSelect: () -> Void
//    
//    var body: some View {
//        Button(action: onSelect) {
//            HStack(spacing: 12) {
//                
//                // Thumbnail
//                favoriteThumbnail
//                    .frame(width: 50, height: 70)
//                    .cornerRadius(6)
//                
//                // Details
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(entity.title ?? "Unknown Title")
//                        .font(.headline)
//                        .foregroundColor(.primary)
//                        .lineLimit(2)
//                    
//                    // Display authors
//                    if let authors = entity.authors as? String {
//                        Text(authors)
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                            .lineLimit(1)
//                    } else {
//                        Text("Unknown Author")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                    }
//                    
//                    if let dateAdded = entity.dateAdded {
//                        Text("Added: \(dateAdded, formatter: dateFormatter)")
//                            .font(.caption2)
//                            .foregroundColor(.gray)
//                    }
//                }
//                
//                Spacer()
//                
//                Image(systemName: "chevron.right")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//            }
//            .padding(.vertical, 4)
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
//    
//    // MARK: - Thumbnail
//    @ViewBuilder
//    private var favoriteThumbnail: some View {
//        if let urlString = entity.thumbnailUrl,
//           let url = URL(string: urlString) {
//            AsyncImage(url: url) { phase in
//                switch phase {
//                case .empty:
//                    ProgressView()
//                        .frame(width: 50, height: 70)
//                case .success(let image):
//                    image
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 50, height: 70)
//                        .clipped()
//                case .failure:
//                    fallbackImage
//                @unknown default:
//                    fallbackImage
//                }
//            }
//        } else {
//            fallbackImage
//        }
//    }
//    
//    private var fallbackImage: some View {
//        ZStack {
//            Rectangle()
//                .fill(Color.gray.opacity(0.2))
//                .frame(width: 50, height: 70)
//            
//            Image(systemName: "book.closed")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 25, height: 35)
//                .foregroundColor(.gray)
//        }
//    }
//}
//
//// MARK: - Date Formatter
//private let dateFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .medium
//    formatter.timeStyle = .none
//    return formatter
//}()


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
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showingClearAlert = false
    @State private var selectedBook: Book?

    private var isDarkMode: Bool {
        themeManager.currentTheme == .dark
    }

    private var pageBackground: Color {
        isDarkMode ? Color(red: 0.08, green: 0.09, blue: 0.11) : Color(red: 0.97, green: 0.95, blue: 0.90)
    }

    private var cardBackground: Color {
        isDarkMode ? Color(red: 0.14, green: 0.15, blue: 0.18) : Color(red: 1.00, green: 0.98, blue: 0.95)
    }

    private var fieldBackground: Color {
        isDarkMode ? Color(red: 0.20, green: 0.21, blue: 0.25) : Color(red: 0.98, green: 0.96, blue: 0.91)
    }

    private var borderColor: Color {
        isDarkMode ? Color.white.opacity(0.10) : Color(red: 0.86, green: 0.81, blue: 0.73)
    }

    private var primaryText: Color {
        isDarkMode ? Color.white : Color(red: 0.16, green: 0.14, blue: 0.13)
    }

    private var secondaryText: Color {
        isDarkMode ? Color.white.opacity(0.66) : Color(red: 0.46, green: 0.42, blue: 0.39)
    }

    private var accent: Color {
        Color(red: 0.18, green: 0.38, blue: 0.26)
    }

    private var heartColor: Color {
        Color(red: 0.95, green: 0.46, blue: 0.67)
    }
    
    var body: some View {
        ZStack {
            pageBackground.ignoresSafeArea()

            if favoritesViewModel.isLoading {
                VStack(spacing: 12) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: accent))
                        .scaleEffect(1.2)
                    Text("Loading favorites...")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(secondaryText)
                }
            } else if favoritesViewModel.isEmpty {
                emptyStateView
            } else {
                favoritesList
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(primaryText)
                        .padding(10)
                        .background(fieldBackground)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(borderColor, lineWidth: 1))
                }
                .padding(.leading, 6)
            }

            if !favoritesViewModel.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingClearAlert = true }) {
                        Image(systemName: "trash")
                            .foregroundColor(heartColor)
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
        .sheet(item: $selectedBook) { book in
            BookDetailView(
                book: book,
                bookViewModel: BookViewModel()
            )
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Favorites List
    private var favoritesList: some View {
        List {
            Section {
                headerCard
                    .listRowInsets(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }

            ForEach(favoritesViewModel.favorites, id: \.objectID) { entity in
                FavoriteRowView(
                    entity: entity,
                    onSelect: {
                        if let book = convertEntityToBook(entity) {
                            selectedBook = book
                        }
                    },
                    onRemove: {
                        if let bookId = entity.id {
                            withAnimation {
                                favoritesViewModel.removeFavorite(bookId: bookId)
                            }
                        }
                    }
                )
                .listRowInsets(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .onDelete { indexSet in
                deleteFavorites(at: indexSet)
            }
        }
        .listStyle(PlainListStyle())
        .scrollContentBackground(.hidden)
        .background(Color.clear)
        .refreshable {
            favoritesViewModel.loadFavorites()
        }
    }

    private var headerCard: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(heartColor.opacity(0.14))
                    .frame(width: 38, height: 38)
                Image(systemName: "heart.fill")
                    .foregroundColor(heartColor)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text("Saved Favorites")
                    .font(.system(size: 16, weight: .semibold, design: .serif))
                    .foregroundColor(primaryText)
                Text("\(favoritesViewModel.favorites.count) book\(favoritesViewModel.favorites.count == 1 ? "" : "s")")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(secondaryText)
            }

            Spacer()
        }
        .padding(14)
        .background(cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(borderColor, lineWidth: 1)
        )
        .cornerRadius(14)
    }
    
    // MARK: - Empty State View
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .font(.system(size: 70))
                .foregroundColor(heartColor.opacity(0.7))
            
            Text("No Favorites Yet")
                .font(.system(size: 24, weight: .semibold, design: .serif))
                .foregroundColor(primaryText)
            
            Text("Books you mark as favorite will appear here")
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            NavigationLink(destination: BookListView()) {
                Text("Browse Books")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(accent)
                    .cornerRadius(10)
            }
            .padding(.top, 10)
        }
        .padding(20)
        .background(cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(borderColor, lineWidth: 1)
        )
        .cornerRadius(16)
        .padding(.horizontal, 16)
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
        if let authorsString = entity.authors {
            authorsArray = authorsString.components(separatedBy: ", ")
        } else {
            authorsArray = ["Unknown Author"]
        }
        
        // Parse categories
        let categoriesArray: [String]?
        if let categoriesString = entity.categories {
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
    let onRemove: () -> Void

    @EnvironmentObject private var themeManager: ThemeManager

    private var isDarkMode: Bool {
        themeManager.currentTheme == .dark
    }

    private var cardBackground: Color {
        isDarkMode ? Color(red: 0.14, green: 0.15, blue: 0.18) : Color(red: 1.00, green: 0.98, blue: 0.95)
    }

    private var borderColor: Color {
        isDarkMode ? Color.white.opacity(0.10) : Color(red: 0.86, green: 0.81, blue: 0.73)
    }

    private var primaryText: Color {
        isDarkMode ? Color.white : Color(red: 0.16, green: 0.14, blue: 0.13)
    }

    private var secondaryText: Color {
        isDarkMode ? Color.white.opacity(0.66) : Color(red: 0.46, green: 0.42, blue: 0.39)
    }
    
    private var chevronText: Color {
        isDarkMode ? Color.white.opacity(0.5) : Color(red: 0.46, green: 0.42, blue: 0.39)
    }
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: onSelect) {
                rowContent
            }
            .buttonStyle(PlainButtonStyle())

            Button(action: onRemove) {
                Image(systemName: "trash")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(red: 0.95, green: 0.46, blue: 0.67))
                    .frame(width: 34, height: 34)
                    .background(Color.red.opacity(isDarkMode ? 0.16 : 0.10))
                    .clipShape(Circle())
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    private var rowContent: some View {
        HStack(spacing: 12) {
            // Thumbnail
            favoriteThumbnail
                .frame(width: 50, height: 70)
                .cornerRadius(6)

            // Details
            VStack(alignment: .leading, spacing: 4) {
                Text(entity.title ?? "Unknown Title")
                    .font(.system(size: 15, weight: .semibold, design: .serif))
                    .foregroundColor(primaryText)
                    .lineLimit(2)

                // Display authors
                if let authors = entity.authors {
                    Text(authors)
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(secondaryText)
                        .lineLimit(1)
                } else {
                    Text("Unknown Author")
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(secondaryText)
                }

                if let dateAdded = entity.dateAdded {
                    Text("Added: \(dateAdded, formatter: dateFormatter)")
                        .font(.system(size: 11, design: .rounded))
                        .foregroundColor(secondaryText)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(chevronText)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor, lineWidth: 1)
        )
        .cornerRadius(12)
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
                .fill(Color.gray.opacity(isDarkMode ? 0.28 : 0.2))
                .frame(width: 50, height: 70)
            
            Image(systemName: "book.closed")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 35)
                .foregroundColor(secondaryText)
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
