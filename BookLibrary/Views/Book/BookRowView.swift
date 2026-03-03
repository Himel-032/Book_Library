//
//  BookRowView.swift
//  BookLibrary
//
//  Created by macos on 25/2/26.
//

import SwiftUI

struct BookRowView: View {
    
    let book: Book
    @ObservedObject var bookViewModel: BookViewModel
    @State private var isFavorite = false
    @State private var showDetail = false
    
    var body: some View {
        Button(action: {
            showDetail.toggle()
        }) {
            HStack(alignment: .top, spacing: 12) {
                
                // Book Thumbnail
                bookThumbnail
                    .frame(width: 60, height: 80)
                    .cornerRadius(6)
                    .shadow(radius: 2)
                
                // Book Details
                VStack(alignment: .leading, spacing: 4) {
                    Text(book.volumeInfo.title)
                        .font(.headline)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Text(book.volumeInfo.authorNames)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    
                    HStack {
                        if let publisher = book.volumeInfo.publisher {
                            Text(publisher)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        // Favorite Button
                        Button(action: toggleFavorite) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(isFavorite ? .red : .gray)
                                .font(.system(size: 16))
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
            .padding(.vertical, 8)
        }
        .sheet(isPresented: $showDetail) {
            BookDetailView(book: book, bookViewModel: bookViewModel)
        }
        .onAppear {
            checkFavoriteStatus()
        }
    }
    
    // MARK: - Book Thumbnail
    @ViewBuilder
    private var bookThumbnail: some View {
        if let thumbnailUrl = book.volumeInfo.thumbnailUrl {
            AsyncImageLoader(url: thumbnailUrl, placeholder: Image(systemName: "book.closed"))
                .frame(width: 60, height: 80)
        } else {
            Image(systemName: "book.closed")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 60)
                .foregroundColor(.gray)
                .padding(10)
                .background(Color.gray.opacity(0.1))
        }
    }
    
    // MARK: - Toggle Favorite
    private func toggleFavorite() {
        isFavorite.toggle()
        _ = CoreDataManager.shared.toggleFavorite(book: book)
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    // MARK: - Check Favorite Status
    private func checkFavoriteStatus() {
        isFavorite = CoreDataManager.shared.isFavorite(bookId: book.id)
    }
}
