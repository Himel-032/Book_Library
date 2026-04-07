//
//  BookDetailView.swift
//  BookLibrary
//
//  Created by macos on 25/2/26.
//

import SwiftUI
import WebKit

struct BookDetailView: View {
    
    let book: Book
    @ObservedObject var bookViewModel: BookViewModel
    @Environment(\.dismiss) var dismiss
    @State private var isFavorite = false
    @State private var isFinished = false
    @State private var showFullDescription = false
    @State private var showReader = false
    
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
                    
                    // Finished button
                    Button(action: toggleFinished) {
                        Image(systemName: isFinished ? "checkmark.circle.fill" : "checkmark.circle")
                            .font(.title2)
                            .foregroundColor(isFinished ? .green : .gray)
                    }
                    .padding(.leading, 8)
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
                        
                        // Finished status indicator
                        if isFinished {
                            Label("Finished", systemImage: "checkmark.seal.fill")
                                .font(.caption)
                                .foregroundColor(.green)
                                .padding(.top, 4)
                        }
                    }
                }
                .padding(.horizontal)
                
                Divider()
                    .padding(.horizontal)
                
                // Read Online Button
                if let previewLink = book.volumeInfo.previewLink,
                   let url = URL(string: previewLink) {
                    VStack(spacing: 12) {
                        Button(action: {
                            UIApplication.shared.open(url)
                        }) {
                            HStack {
                                Image(systemName: "book.fill")
                                    .font(.title2)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Read Online")
                                        .font(.headline)
                                    Text("Open in Google Books")
                                        .font(.caption)
                                }
                                Spacer()
                                Image(systemName: "arrow.up.right.square")
                                    .font(.title2)
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                        }
                        
                        // Preview in App
                        Button(action: {
                            showReader = true
                        }) {
                            HStack {
                                Image(systemName: "doc.text.magnifyingglass")
                                    .font(.title2)
                                Text("Preview in App")
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.title2)
                            }
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .padding(.horizontal)
                }
                
                // Categories
                if let categories = book.volumeInfo.categories, !categories.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Categories")
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(categories, id: \.self) { category in
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
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.vertical)
        }
        .onAppear {
            checkFavoriteStatus()
            checkFinishedStatus()
        }
        .sheet(isPresented: $showReader) {
            BookPreviewWebView(book: book)
        }
    }
    
    //  Book Thumbnail
    @ViewBuilder
    private var bookThumbnail: some View {
        if let thumbnailUrl = book.volumeInfo.thumbnailUrl {
            AsyncImage(url: thumbnailUrl) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 120, height: 160)
                        .overlay(
                            ProgressView()
                                .scaleEffect(0.8)
                        )
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 160)
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
                .frame(width: 120, height: 160)
            
            Image(systemName: "book.closed")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 70)
                .foregroundColor(.gray)
        }
    }
    
    //  Info Row
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
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    // MARK: - Toggle Finished (FIXED)
    private func toggleFinished() {
        // Pass the book to CoreDataManager so it can create if needed
        let newValue = CoreDataManager.shared.toggleFinished(bookId: book.id, book: book)
        
        // Update local state
        isFinished = newValue
        
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        print("Finished toggled: \(isFinished)")
    }
    
    // Check Favorite Status
    private func checkFavoriteStatus() {
        isFavorite = CoreDataManager.shared.isFavorite(bookId: book.id)
    }
    
    // Check Finished Status
    private func checkFinishedStatus() {
        isFinished = CoreDataManager.shared.isFinished(bookId: book.id)
    }
}

//  Book Preview WebView
struct BookPreviewWebView: View {
    let book: Book
    @Environment(\.dismiss) var dismiss
    @State private var isLoading = true
    
    var body: some View {
        NavigationView {
            ZStack {
                if let previewLink = book.volumeInfo.previewLink,
                   let url = URL(string: previewLink) {
                    WebView(url: url)
                        .edgesIgnoringSafeArea(.bottom)
                        .overlay(
                            Group {
                                if isLoading {
                                    ProgressView()
                                        .scaleEffect(1.5)
                                }
                            }
                        )
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                isLoading = false
                            }
                        }
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Preview not available")
                            .font(.headline)
                    }
                }
            }
            .navigationTitle(book.volumeInfo.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

//  Simple WebView
struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {}
}
