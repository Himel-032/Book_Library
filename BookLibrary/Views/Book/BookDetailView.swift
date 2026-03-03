//
//  BookDetailView.swift
//  BookLibrary
//
//  Created by macos on 25/2/26.
//

import SwiftUI

struct BookDetailView: View {
    
    let book: Book
    @ObservedObject var bookViewModel: BookViewModel
    @Environment(\.dismiss) var dismiss
    @State private var isFavorite = false
    @State private var showFullDescription = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // Header with dismiss button
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Text("Book Details")
                        .font(.headline)
                    
                    Spacer()
                    
                    // Favorite button
                    Button(action: toggleFavorite) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.title2)
                            .foregroundColor(isFavorite ? .red : .gray)
                    }
                }
                .padding(.horizontal)
                
                // Book Cover and Basic Info
                HStack(alignment: .top, spacing: 16) {
                    
                    // Thumbnail
                    bookThumbnail
                        .frame(width: 120, height: 160)
                        .cornerRadius(8)
                        .shadow(radius: 5)
                    
                    // Basic Info
                    VStack(alignment: .leading, spacing: 8) {
                        Text(book.volumeInfo.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text(book.volumeInfo.authorNames)
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        if let publisher = book.volumeInfo.publisher {
                            Label(publisher, systemImage: "building.2")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        if let publishedDate = book.volumeInfo.publishedDate {
                            Label(publishedDate, systemImage: "calendar")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        if let pageCount = book.volumeInfo.pageCount {
                            Label("\(pageCount) pages", systemImage: "book.pages")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal)
                
                Divider()
                    .padding(.horizontal)
                
                // Categories
                if !book.volumeInfo.categoryList.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Categories")
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(book.volumeInfo.categories ?? [], id: \.self) { category in
                                    Text(category)
                                        .font(.caption)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(12)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .padding(.horizontal)
                }
                
                // Description
                if let description = book.volumeInfo.description {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        
                        Text(description)
                            .font(.body)
                            .lineLimit(showFullDescription ? nil : 5)
                        
                        Button(action: {
                            withAnimation {
                                showFullDescription.toggle()
                            }
                        }) {
                            Text(showFullDescription ? "Show Less" : "Read More")
                                .font(.footnote)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Additional Info
                VStack(alignment: .leading, spacing: 8) {
                    Text("Additional Information")
                        .font(.headline)
                    
                    if let language = book.volumeInfo.language {
                        infoRow(label: "Language", value: language.uppercased())
                    }
                    
                    if let previewLink = book.volumeInfo.previewLink,
                       let url = URL(string: previewLink) {
                        Link(destination: url) {
                            HStack {
                                Text("Preview on Google Books")
                                Image(systemName: "arrow.up.right.square")
                            }
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.vertical)
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
        } else {
            Image(systemName: "book.closed")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 120)
                .foregroundColor(.gray)
                .padding(20)
                .background(Color.gray.opacity(0.1))
        }
    }
    
    // MARK: - Info Row
    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label + ":")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.subheadline)
            Spacer()
        }
    }
    
    // MARK: - Toggle Favorite
    private func toggleFavorite() {
        isFavorite.toggle()
        _ = CoreDataManager.shared.toggleFavorite(book: book)
        
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    // MARK: - Check Favorite Status
    private func checkFavoriteStatus() {
        isFavorite = CoreDataManager.shared.isFavorite(bookId: book.id)
    }
}
