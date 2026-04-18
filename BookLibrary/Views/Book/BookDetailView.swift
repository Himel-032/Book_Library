//
//  BookDetailView.swift
//  BookLibrary
//
//  Created by macos on 25/2/26.
//
//
//import SwiftUI
//import WebKit
//
//struct BookDetailView: View {
//    
//    let book: Book
//    @ObservedObject var bookViewModel: BookViewModel
//    @Environment(\.dismiss) var dismiss
//    @State private var isFavorite = false
//    @State private var isFinished = false
//    @State private var showFullDescription = false
//    @State private var showReader = false
//    
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 16) {
//                
//                // Header with dismiss button
//                HStack {
//                    Button(action: { dismiss() }) {
//                        Image(systemName: "xmark.circle.fill")
//                            .font(.title2)
//                            .foregroundColor(.gray)
//                    }
//                    
//                    Spacer()
//                    
//                    Text("Book Details")
//                        .font(.headline)
//                    
//                    Spacer()
//                    
//                    // Favorite button
//                    Button(action: toggleFavorite) {
//                        Image(systemName: isFavorite ? "heart.fill" : "heart")
//                            .font(.title2)
//                            .foregroundColor(isFavorite ? Color(red: 0.95, green: 0.46, blue: 0.67) : .gray)
//                    }
//                    
//                    // Finished button
//                    Button(action: toggleFinished) {
//                        Image(systemName: isFinished ? "checkmark.circle.fill" : "checkmark.circle")
//                            .font(.title2)
//                            .foregroundColor(isFinished ? .green : .gray)
//                    }
//                    .padding(.leading, 8)
//                }
//                .padding(.horizontal)
//                
//                // Book Cover and Basic Info
//                HStack(alignment: .top, spacing: 16) {
//                    
//                    // Thumbnail
//                    bookThumbnail
//                        .frame(width: 120, height: 160)
//                        .cornerRadius(8)
//                        .shadow(radius: 5)
//                    
//                    // Basic Info
//                    VStack(alignment: .leading, spacing: 8) {
//                        Text(book.volumeInfo.title)
//                            .font(.title2)
//                            .fontWeight(.bold)
//                            .fixedSize(horizontal: false, vertical: true)
//                        
//                        Text(book.volumeInfo.authorNames)
//                            .font(.headline)
//                            .foregroundColor(.secondary)
//                        
//                        if let publisher = book.volumeInfo.publisher {
//                            Label(publisher, systemImage: "building.2")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                        }
//                        
//                        if let publishedDate = book.volumeInfo.publishedDate {
//                            Label(publishedDate, systemImage: "calendar")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                        }
//                        
//                        if let pageCount = book.volumeInfo.pageCount {
//                            Label("\(pageCount) pages", systemImage: "book.pages")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                        }
//                        
//                        // Finished status indicator
//                        if isFinished {
//                            Label("Finished", systemImage: "checkmark.seal.fill")
//                                .font(.caption)
//                                .foregroundColor(.green)
//                                .padding(.top, 4)
//                        }
//                    }
//                }
//                .padding(.horizontal)
//                
//                Divider()
//                    .padding(.horizontal)
//                
//                // Read Online Button
//                if let previewLink = book.volumeInfo.previewLink,
//                   let url = URL(string: previewLink) {
//                    VStack(spacing: 12) {
//                        Button(action: {
//                            UIApplication.shared.open(url)
//                        }) {
//                            HStack {
//                                Image(systemName: "book.fill")
//                                    .font(.title2)
//                                VStack(alignment: .leading, spacing: 2) {
//                                    Text("Read Online")
//                                        .font(.headline)
//                                    Text("Open in Google Books")
//                                        .font(.caption)
//                                }
//                                Spacer()
//                                Image(systemName: "arrow.up.right.square")
//                                    .font(.title2)
//                            }
//                            .foregroundColor(.white)
//                            .padding()
//                            .background(Color.green)
//                            .cornerRadius(12)
//                        }
//                        
//                        // Preview in App
//                        Button(action: {
//                            showReader = true
//                        }) {
//                            HStack {
//                                Image(systemName: "doc.text.magnifyingglass")
//                                    .font(.title2)
//                                Text("Preview in App")
//                                    .font(.headline)
//                                Spacer()
//                                Image(systemName: "chevron.right")
//                                    .font(.title2)
//                            }
//                            .foregroundColor(.blue)
//                            .padding()
//                            .background(Color.blue.opacity(0.1))
//                            .cornerRadius(12)
//                        }
//                    }
//                    .padding(.horizontal)
//                    
//                    Divider()
//                        .padding(.horizontal)
//                }
//                
//                // Categories
//                if let categories = book.volumeInfo.categories, !categories.isEmpty {
//                    VStack(alignment: .leading, spacing: 8) {
//                        Text("Categories")
//                            .font(.headline)
//                        
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            HStack {
//                                ForEach(categories, id: \.self) { category in
//                                    Text(category)
//                                        .font(.caption)
//                                        .padding(.horizontal, 10)
//                                        .padding(.vertical, 5)
//                                        .background(Color.blue.opacity(0.1))
//                                        .cornerRadius(12)
//                                }
//                            }
//                        }
//                    }
//                    .padding(.horizontal)
//                    
//                    Divider()
//                        .padding(.horizontal)
//                }
//                
//                // Description
//                if let description = book.volumeInfo.description {
//                    VStack(alignment: .leading, spacing: 8) {
//                        Text("Description")
//                            .font(.headline)
//                        
//                        Text(description)
//                            .font(.body)
//                            .lineLimit(showFullDescription ? nil : 5)
//                        
//                        Button(action: {
//                            withAnimation {
//                                showFullDescription.toggle()
//                            }
//                        }) {
//                            Text(showFullDescription ? "Show Less" : "Read More")
//                                .font(.footnote)
//                                .foregroundColor(.blue)
//                        }
//                    }
//                    .padding(.horizontal)
//                }
//                
//                // Additional Info
//                VStack(alignment: .leading, spacing: 8) {
//                    Text("Additional Information")
//                        .font(.headline)
//                    
//                    if let language = book.volumeInfo.language {
//                        infoRow(label: "Language", value: language.uppercased())
//                    }
//                }
//                .padding(.horizontal)
//                
//                Spacer()
//            }
//            .padding(.vertical)
//        }
//        .onAppear {
//            checkFavoriteStatus()
//            checkFinishedStatus()
//        }
//        .sheet(isPresented: $showReader) {
//            BookPreviewWebView(book: book)
//        }
//    }
//    
//    // MARK: - Book Thumbnail
//    @ViewBuilder
//    private var bookThumbnail: some View {
//        if let thumbnailUrl = book.volumeInfo.thumbnailUrl {
//            AsyncImage(url: thumbnailUrl) { phase in
//                switch phase {
//                case .empty:
//                    Rectangle()
//                        .fill(Color.gray.opacity(0.2))
//                        .frame(width: 120, height: 160)
//                        .overlay(
//                            ProgressView()
//                                .scaleEffect(0.8)
//                        )
//                case .success(let image):
//                    image
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 120, height: 160)
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
//                .frame(width: 120, height: 160)
//            
//            Image(systemName: "book.closed")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 50, height: 70)
//                .foregroundColor(.gray)
//        }
//    }
//    
//    // MARK: - Info Row
//    private func infoRow(label: String, value: String) -> some View {
//        HStack {
//            Text(label + ":")
//                .font(.subheadline)
//                .foregroundColor(.secondary)
//            Text(value)
//                .font(.subheadline)
//            Spacer()
//        }
//    }
//    
//    // MARK: - Toggle Favorite
//    private func toggleFavorite() {
//        isFavorite.toggle()
//        _ = CoreDataManager.shared.toggleFavorite(book: book)
//        
//        let generator = UINotificationFeedbackGenerator()
//        generator.notificationOccurred(.success)
//    }
//    
//    // MARK: - Toggle Finished (FIXED)
//    private func toggleFinished() {
//        // Pass the book to CoreDataManager so it can create if needed
//        let newValue = CoreDataManager.shared.toggleFinished(bookId: book.id, book: book)
//        
//        // Update local state
//        isFinished = newValue
//        
//        // Haptic feedback
//        let generator = UINotificationFeedbackGenerator()
//        generator.notificationOccurred(.success)
//        
//        print("📚 Finished toggled: \(isFinished)")
//    }
//    
//    // MARK: - Check Favorite Status
//    private func checkFavoriteStatus() {
//        isFavorite = CoreDataManager.shared.isFavorite(bookId: book.id)
//    }
//    
//    // MARK: - Check Finished Status
//    private func checkFinishedStatus() {
//        isFinished = CoreDataManager.shared.isFinished(bookId: book.id)
//    }
//}
//
//// MARK: - Book Preview WebView
//struct BookPreviewWebView: View {
//    let book: Book
//    @Environment(\.dismiss) var dismiss
//    @State private var isLoading = true
//    
//    var body: some View {
//        NavigationView {
//            ZStack {
//                if let previewLink = book.volumeInfo.previewLink,
//                   let url = URL(string: previewLink) {
//                    WebView(url: url)
//                        .edgesIgnoringSafeArea(.bottom)
//                        .overlay(
//                            Group {
//                                if isLoading {
//                                    ProgressView()
//                                        .scaleEffect(1.5)
//                                }
//                            }
//                        )
//                        .onAppear {
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                                isLoading = false
//                            }
//                        }
//                } else {
//                    VStack(spacing: 20) {
//                        Image(systemName: "exclamationmark.triangle")
//                            .font(.system(size: 60))
//                            .foregroundColor(.gray)
//                        Text("Preview not available")
//                            .font(.headline)
//                    }
//                }
//            }
//            .navigationTitle(book.volumeInfo.title)
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Done") {
//                        dismiss()
//                    }
//                }
//            }
//        }
//    }
//}
//
//// MARK: - Simple WebView
//struct WebView: UIViewRepresentable {
//    let url: URL
//    
//    func makeUIView(context: Context) -> WKWebView {
//        let webView = WKWebView()
//        webView.load(URLRequest(url: url))
//        return webView
//    }
//    
//    func updateUIView(_ webView: WKWebView, context: Context) {}
//}

//import SwiftUI
//
//struct BookDetailView: View {
//
//    let book: Book
//    @ObservedObject var bookViewModel: BookViewModel
//    @Environment(\.dismiss) private var dismiss
//    @EnvironmentObject private var themeManager: ThemeManager
//
//    @State private var isFavorite = false
//    @State private var isFinished = false
//    @State private var showFullDescription = false
//    @State private var showReader = false
//    @State private var showAccessAlert = false
//    @State private var accessAlertMessage = ""
//
//    private var isDarkMode: Bool {
//        themeManager.currentTheme == .dark
//    }
//
//    private var pageBackground: Color {
//        isDarkMode ? Color(red: 0.08, green: 0.09, blue: 0.11) : Color(red: 0.97, green: 0.95, blue: 0.90)
//    }
//
//    private var cardBackground: Color {
//        isDarkMode ? Color(red: 0.14, green: 0.15, blue: 0.18) : Color(red: 1.00, green: 0.98, blue: 0.95)
//    }
//
//    private var fieldBackground: Color {
//        isDarkMode ? Color(red: 0.20, green: 0.21, blue: 0.25) : Color(red: 0.98, green: 0.96, blue: 0.91)
//    }
//
//    private var borderColor: Color {
//        isDarkMode ? Color.white.opacity(0.10) : Color(red: 0.86, green: 0.81, blue: 0.73)
//    }
//
//    private var primaryText: Color {
//        isDarkMode ? Color.white : Color(red: 0.16, green: 0.14, blue: 0.13)
//    }
//
//    private var secondaryText: Color {
//        isDarkMode ? Color.white.opacity(0.66) : Color(red: 0.46, green: 0.42, blue: 0.39)
//    }
//
//    private var accent: Color {
//        Color(red: 0.18, green: 0.38, blue: 0.26)
//    }
//
//    private var accentSoft: Color {
//        accent.opacity(isDarkMode ? 0.18 : 0.12)
//    }
//
//    private var heartColor: Color {
//        Color(red: 0.95, green: 0.46, blue: 0.67)
//    }
//
//    private var canReadOnline: Bool {
//        book.readingUrl != nil || book.volumeInfo.googleBooksUrl != nil
//    }
//
//    private var canPreviewInApp: Bool {
//        if let accessInfo = book.accessInfo {
//            return accessInfo.isEmbeddable && book.readingUrl != nil
//        }
//
//        // Favorites reconstructed from CoreData may not have accessInfo.
//        // In that case, allow preview when a preview link exists.
//        return book.volumeInfo.previewLink != nil
//    }
//
//    var body: some View {
//        ZStack {
//            pageBackground.ignoresSafeArea()
//
//            ScrollView {
//                VStack(spacing: 16) {
//                    headerBar
//                    heroCard
//                    actionCard
//                    categoriesCard
//                    descriptionCard
//                    additionalInfoCard
//                }
//                .padding(.horizontal, 14)
//                .padding(.top, 10)
//                .padding(.bottom, 24)
//            }
//        }
//        .onAppear {
//            checkFavoriteStatus()
//            checkFinishedStatus()
//        }
//        .sheet(isPresented: $showReader) {
//            BookReaderView(book: book)
//        }
//        .alert("Preview Unavailable", isPresented: $showAccessAlert) {
//            Button("OK", role: .cancel) { }
//        } message: {
//            Text(accessAlertMessage)
//        }
//    }
//
//    private var headerBar: some View {
//        HStack(spacing: 10) {
//            Button(action: { dismiss() }) {
//                Image(systemName: "xmark")
//                    .font(.system(size: 14, weight: .semibold))
//                    .foregroundColor(primaryText)
//                    .frame(width: 38, height: 38)
//                    .background(fieldBackground)
//                    .clipShape(Circle())
//                    .overlay(Circle().stroke(borderColor, lineWidth: 1))
//            }
//
//            Text("Book Details")
//                .font(.system(size: 18, weight: .semibold, design: .serif))
//                .foregroundColor(primaryText)
//
//            Spacer()
//
//            Button(action: toggleFavorite) {
//                Image(systemName: isFavorite ? "heart.fill" : "heart")
//                    .font(.system(size: 16, weight: .semibold))
//                    .foregroundColor(isFavorite ? heartColor : secondaryText)
//                    .frame(width: 38, height: 38)
//                    .background(fieldBackground)
//                    .clipShape(Circle())
//                    .overlay(Circle().stroke(borderColor, lineWidth: 1))
//            }
//
//            Button(action: toggleFinished) {
//                Image(systemName: isFinished ? "checkmark.circle.fill" : "checkmark.circle")
//                    .font(.system(size: 16, weight: .semibold))
//                    .foregroundColor(isFinished ? Color(red: 0.18, green: 0.56, blue: 0.31) : secondaryText)
//                    .frame(width: 38, height: 38)
//                    .background(fieldBackground)
//                    .clipShape(Circle())
//                    .overlay(Circle().stroke(borderColor, lineWidth: 1))
//            }
//        }
//    }
//
//    private var heroCard: some View {
//        HStack(alignment: .top, spacing: 14) {
//            bookThumbnail
//                .frame(width: 112, height: 156)
//                .cornerRadius(10)
//                .shadow(color: .black.opacity(isDarkMode ? 0.28 : 0.12), radius: 6, y: 3)
//
//            VStack(alignment: .leading, spacing: 7) {
//                Text(book.volumeInfo.title)
//                    .font(.system(size: 20, weight: .semibold, design: .serif))
//                    .foregroundColor(primaryText)
//                    .fixedSize(horizontal: false, vertical: true)
//
//                Text(book.volumeInfo.authorNames)
//                    .font(.system(size: 14, weight: .medium, design: .rounded))
//                    .foregroundColor(secondaryText)
//
//                if let publisher = book.volumeInfo.publisher {
//                    metaRow(icon: "building.2", value: publisher)
//                }
//
//                if let publishedDate = book.volumeInfo.publishedDate {
//                    metaRow(icon: "calendar", value: publishedDate)
//                }
//
//                if let pageCount = book.volumeInfo.pageCount {
//                    metaRow(icon: "book.pages", value: "\(pageCount) pages")
//                }
//
//                if isFinished {
//                    HStack(spacing: 6) {
//                        Image(systemName: "checkmark.seal.fill")
//                        Text("Finished")
//                    }
//                    .font(.system(size: 12, weight: .semibold, design: .rounded))
//                    .foregroundColor(Color(red: 0.18, green: 0.56, blue: 0.31))
//                    .padding(.top, 2)
//                }
//            }
//
//            Spacer()
//        }
//        .padding(16)
//        .background(cardBackground)
//        .overlay(
//            RoundedRectangle(cornerRadius: 14)
//                .stroke(borderColor, lineWidth: 1)
//        )
//        .cornerRadius(14)
//    }
//
//    private var actionCard: some View {
//        VStack(spacing: 10) {
//            Button(action: openReadOnline) {
//                HStack(spacing: 10) {
//                    Image(systemName: "arrow.up.right.square")
//                        .font(.system(size: 14, weight: .semibold))
//                    Text("Read Online")
//                        .font(.system(size: 14, weight: .semibold, design: .rounded))
//                    Spacer()
//                    Image(systemName: "chevron.right")
//                        .font(.system(size: 11, weight: .semibold))
//                }
//                .foregroundColor(.white)
//                .padding(.horizontal, 14)
//                .padding(.vertical, 12)
//                .background(accent)
//                .cornerRadius(10)
//            }
//            .buttonStyle(.plain)
//            .disabled(!canReadOnline)
//            .opacity(canReadOnline ? 1 : 0.6)
//
//            Button(action: openPreviewInApp) {
//                HStack(spacing: 10) {
//                    Image(systemName: "doc.text.magnifyingglass")
//                        .font(.system(size: 14, weight: .semibold))
//                    Text("Preview in App")
//                        .font(.system(size: 14, weight: .semibold, design: .rounded))
//                    Spacer()
//                    Image(systemName: "chevron.right")
//                        .font(.system(size: 11, weight: .semibold))
//                }
//                .foregroundColor(primaryText)
//                .padding(.horizontal, 14)
//                .padding(.vertical, 12)
//                .background(fieldBackground)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(borderColor, lineWidth: 1)
//                )
//                .cornerRadius(10)
//            }
//            .buttonStyle(.plain)
//
//            if !canPreviewInApp {
//                Text("Some books do not allow embedded preview. Use Read Online when available.")
//                    .font(.system(size: 12, design: .rounded))
//                    .foregroundColor(secondaryText)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//            }
//        }
//        .padding(14)
//        .background(cardBackground)
//        .overlay(
//            RoundedRectangle(cornerRadius: 14)
//                .stroke(borderColor, lineWidth: 1)
//        )
//        .cornerRadius(14)
//    }
//
//    private var categoriesCard: some View {
//        Group {
//            if let categories = book.volumeInfo.categories, !categories.isEmpty {
//                VStack(alignment: .leading, spacing: 10) {
//                    sectionTitle("Categories")
//
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 8) {
//                            ForEach(categories, id: \.self) { category in
//                                Text(category)
//                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
//                                    .foregroundColor(primaryText)
//                                    .padding(.horizontal, 10)
//                                    .padding(.vertical, 6)
//                                    .background(accentSoft)
//                                    .cornerRadius(12)
//                            }
//                        }
//                    }
//                }
//                .padding(14)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .background(cardBackground)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 14)
//                        .stroke(borderColor, lineWidth: 1)
//                )
//                .cornerRadius(14)
//            }
//        }
//    }
//
//    private var descriptionCard: some View {
//        Group {
//            if let description = book.volumeInfo.description {
//                VStack(alignment: .leading, spacing: 10) {
//                    sectionTitle("Description")
//
//                    Text(description)
//                        .font(.system(size: 14, design: .rounded))
//                        .foregroundColor(primaryText)
//                        .lineLimit(showFullDescription ? nil : 6)
//
//                    Button(action: {
//                        withAnimation(.easeInOut(duration: 0.2)) {
//                            showFullDescription.toggle()
//                        }
//                    }) {
//                        Text(showFullDescription ? "Show Less" : "Read More")
//                            .font(.system(size: 12, weight: .semibold, design: .rounded))
//                            .foregroundColor(accent)
//                    }
//                }
//                .padding(14)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .background(cardBackground)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 14)
//                        .stroke(borderColor, lineWidth: 1)
//                )
//                .cornerRadius(14)
//            }
//        }
//    }
//
//    private var additionalInfoCard: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            sectionTitle("Additional Information")
//
//            if let language = book.volumeInfo.language {
//                infoRow(label: "Language", value: language.uppercased())
//            }
//
//            infoRow(label: "Preview Status", value: book.previewStatus)
//        }
//        .padding(14)
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .background(cardBackground)
//        .overlay(
//            RoundedRectangle(cornerRadius: 14)
//                .stroke(borderColor, lineWidth: 1)
//        )
//        .cornerRadius(14)
//    }
//
//    private func sectionTitle(_ title: String) -> some View {
//        Text(title)
//            .font(.system(size: 16, weight: .semibold, design: .serif))
//            .foregroundColor(primaryText)
//    }
//
//    private func metaRow(icon: String, value: String) -> some View {
//        HStack(spacing: 6) {
//            Image(systemName: icon)
//                .font(.system(size: 11, weight: .semibold))
//            Text(value)
//                .lineLimit(1)
//        }
//        .font(.system(size: 12, design: .rounded))
//        .foregroundColor(secondaryText)
//    }
//
//    @ViewBuilder
//    private var bookThumbnail: some View {
//        if let thumbnailUrl = book.volumeInfo.thumbnailUrl {
//            AsyncImage(url: thumbnailUrl) { phase in
//                switch phase {
//                case .empty:
//                    Rectangle()
//                        .fill(fieldBackground)
//                        .overlay(ProgressView().tint(accent))
//                case .success(let image):
//                    image
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
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
//            Rectangle().fill(fieldBackground)
//            Image(systemName: "book.closed")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 42, height: 58)
//                .foregroundColor(secondaryText)
//        }
//    }
//
//    private func infoRow(label: String, value: String) -> some View {
//        HStack(alignment: .top) {
//            Text("\(label):")
//                .font(.system(size: 13, weight: .semibold, design: .rounded))
//                .foregroundColor(secondaryText)
//            Text(value)
//                .font(.system(size: 13, design: .rounded))
//                .foregroundColor(primaryText)
//            Spacer()
//        }
//    }
//
//    private func openReadOnline() {
//        if let url = book.readingUrl ?? book.volumeInfo.googleBooksUrl {
//            UIApplication.shared.open(url)
//        } else {
//            accessAlertMessage = "This book does not provide an online preview link."
//            showAccessAlert = true
//        }
//    }
//
//    private func openPreviewInApp() {
//        if let accessInfo = book.accessInfo,
//           !accessInfo.isEmbeddable {
//            accessAlertMessage = "Preview is not allowed for this book in the app reader."
//            showAccessAlert = true
//            return
//        }
//
//        guard canPreviewInApp else {
//            accessAlertMessage = "Preview is not available for this book."
//            showAccessAlert = true
//            return
//        }
//        showReader = true
//    }
//
//    private func toggleFavorite() {
//        isFavorite.toggle()
//        _ = CoreDataManager.shared.toggleFavorite(book: book)
//        UINotificationFeedbackGenerator().notificationOccurred(.success)
//    }
//
//    private func toggleFinished() {
//        isFinished = CoreDataManager.shared.toggleFinished(bookId: book.id, book: book)
//        UINotificationFeedbackGenerator().notificationOccurred(.success)
//    }
//
//    private func checkFavoriteStatus() {
//        isFavorite = CoreDataManager.shared.isFavorite(bookId: book.id)
//    }
//
//    private func checkFinishedStatus() {
//        isFinished = CoreDataManager.shared.isFinished(bookId: book.id)
//    }
//}




import SwiftUI
import FirebaseAuth

struct BookDetailView: View {

    let book: Book
    @ObservedObject var bookViewModel: BookViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager

    @State private var isFavorite = false
    @State private var isFinished = false
    @State private var showFullDescription = false
    @State private var showReader = false
    @State private var showAccessAlert = false
    @State private var accessAlertMessage = ""

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

    private var accentSoft: Color {
        accent.opacity(isDarkMode ? 0.18 : 0.12)
    }

    private var heartColor: Color {
        Color(red: 0.95, green: 0.46, blue: 0.67)
    }

    private var canReadOnline: Bool {
        book.readingUrl != nil || book.volumeInfo.googleBooksUrl != nil
    }

    private var canPreviewInApp: Bool {
        if let accessInfo = book.accessInfo {
            return accessInfo.isEmbeddable && book.readingUrl != nil
        }

        // Favorites reconstructed from CoreData may not have accessInfo.
        // In that case, allow preview when a preview link exists.
        return book.volumeInfo.previewLink != nil
    }

    var body: some View {
        ZStack {
            pageBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    headerBar
                    heroCard
                    actionCard
                    categoriesCard
                    descriptionCard
                    additionalInfoCard
                }
                .padding(.horizontal, 14)
                .padding(.top, 10)
                .padding(.bottom, 24)
            }
        }
        .onAppear {
            checkFavoriteStatus()
            checkFinishedStatus()
        }
        .sheet(isPresented: $showReader) {
            BookReaderView(book: book)
        }
        .alert("Preview Unavailable", isPresented: $showAccessAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(accessAlertMessage)
        }
    }

    private var headerBar: some View {
        HStack(spacing: 10) {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(primaryText)
                    .frame(width: 38, height: 38)
                    .background(fieldBackground)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(borderColor, lineWidth: 1))
            }

            Text("Book Details")
                .font(.system(size: 18, weight: .semibold, design: .serif))
                .foregroundColor(primaryText)

            Spacer()

            Button(action: toggleFavorite) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isFavorite ? heartColor : secondaryText)
                    .frame(width: 38, height: 38)
                    .background(fieldBackground)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(borderColor, lineWidth: 1))
            }

            Button(action: toggleFinished) {
                Image(systemName: isFinished ? "checkmark.circle.fill" : "checkmark.circle")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isFinished ? Color(red: 0.18, green: 0.56, blue: 0.31) : secondaryText)
                    .frame(width: 38, height: 38)
                    .background(fieldBackground)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(borderColor, lineWidth: 1))
            }
        }
    }

    private var heroCard: some View {
        HStack(alignment: .top, spacing: 14) {
            bookThumbnail
                .frame(width: 112, height: 156)
                .cornerRadius(10)
                .shadow(color: .black.opacity(isDarkMode ? 0.28 : 0.12), radius: 6, y: 3)

            VStack(alignment: .leading, spacing: 7) {
                Text(book.volumeInfo.title)
                    .font(.system(size: 20, weight: .semibold, design: .serif))
                    .foregroundColor(primaryText)
                    .fixedSize(horizontal: false, vertical: true)

                Text(book.volumeInfo.authorNames)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(secondaryText)

                if let publisher = book.volumeInfo.publisher {
                    metaRow(icon: "building.2", value: publisher)
                }

                if let publishedDate = book.volumeInfo.publishedDate {
                    metaRow(icon: "calendar", value: publishedDate)
                }

                if let pageCount = book.volumeInfo.pageCount {
                    metaRow(icon: "book.pages", value: "\(pageCount) pages")
                }

                if isFinished {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.seal.fill")
                        Text("Finished")
                    }
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(red: 0.18, green: 0.56, blue: 0.31))
                    .padding(.top, 2)
                }
            }

            Spacer()
        }
        .padding(16)
        .background(cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(borderColor, lineWidth: 1)
        )
        .cornerRadius(14)
    }

    private var actionCard: some View {
        VStack(spacing: 10) {
            Button(action: openReadOnline) {
                HStack(spacing: 10) {
                    Image(systemName: "arrow.up.right.square")
                        .font(.system(size: 14, weight: .semibold))
                    Text("Read Online")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(accent)
                .cornerRadius(10)
            }
            .buttonStyle(.plain)
            .disabled(!canReadOnline)
            .opacity(canReadOnline ? 1 : 0.6)

            Button(action: openPreviewInApp) {
                HStack(spacing: 10) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 14, weight: .semibold))
                    Text("Preview in App")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .semibold))
                }
                .foregroundColor(primaryText)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(fieldBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(borderColor, lineWidth: 1)
                )
                .cornerRadius(10)
            }
            .buttonStyle(.plain)

            if !canPreviewInApp {
                Text("Some books do not allow embedded preview. Use Read Online when available.")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(secondaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(14)
        .background(cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(borderColor, lineWidth: 1)
        )
        .cornerRadius(14)
    }

    private var categoriesCard: some View {
        Group {
            if let categories = book.volumeInfo.categories, !categories.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    sectionTitle("Categories")

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(categories, id: \.self) { category in
                                Text(category)
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .foregroundColor(primaryText)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(accentSoft)
                                    .cornerRadius(12)
                            }
                        }
                    }
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(borderColor, lineWidth: 1)
                )
                .cornerRadius(14)
            }
        }
    }

    private var descriptionCard: some View {
        Group {
            if let description = book.volumeInfo.description {
                VStack(alignment: .leading, spacing: 10) {
                    sectionTitle("Description")

                    Text(description)
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(primaryText)
                        .lineLimit(showFullDescription ? nil : 6)

                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showFullDescription.toggle()
                        }
                    }) {
                        Text(showFullDescription ? "Show Less" : "Read More")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(accent)
                    }
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(borderColor, lineWidth: 1)
                )
                .cornerRadius(14)
            }
        }
    }

    private var additionalInfoCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Additional Information")

            if let language = book.volumeInfo.language {
                infoRow(label: "Language", value: language.uppercased())
            }

            infoRow(label: "Preview Status", value: book.previewStatus)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(borderColor, lineWidth: 1)
        )
        .cornerRadius(14)
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 16, weight: .semibold, design: .serif))
            .foregroundColor(primaryText)
    }

    private func metaRow(icon: String, value: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 11, weight: .semibold))
            Text(value)
                .lineLimit(1)
        }
        .font(.system(size: 12, design: .rounded))
        .foregroundColor(secondaryText)
    }

    @ViewBuilder
    private var bookThumbnail: some View {
        if let thumbnailUrl = book.volumeInfo.thumbnailUrl {
            AsyncImage(url: thumbnailUrl) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(fieldBackground)
                        .overlay(ProgressView().tint(accent))
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
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
            Rectangle().fill(fieldBackground)
            Image(systemName: "book.closed")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 42, height: 58)
                .foregroundColor(secondaryText)
        }
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text("\(label):")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(secondaryText)
            Text(value)
                .font(.system(size: 13, design: .rounded))
                .foregroundColor(primaryText)
            Spacer()
        }
    }

    private func openReadOnline() {
        if let uid = Auth.auth().currentUser?.uid {
            RecommendationTracker.shared.trackReadingBook(book, userId: uid)
        }

        if let url = book.readingUrl ?? book.volumeInfo.googleBooksUrl {
            UIApplication.shared.open(url)
        } else {
            accessAlertMessage = "This book does not provide an online preview link."
            showAccessAlert = true
        }
    }

    private func openPreviewInApp() {
        if let accessInfo = book.accessInfo,
           !accessInfo.isEmbeddable {
            accessAlertMessage = "Preview is not allowed for this book in the app reader."
            showAccessAlert = true
            return
        }

        guard canPreviewInApp else {
            accessAlertMessage = "Preview is not available for this book."
            showAccessAlert = true
            return
        }

        if let uid = Auth.auth().currentUser?.uid {
            RecommendationTracker.shared.trackReadingBook(book, userId: uid)
        }
        showReader = true
    }

    private func toggleFavorite() {
        isFavorite.toggle()
        _ = CoreDataManager.shared.toggleFavorite(book: book)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    private func toggleFinished() {
        isFinished = CoreDataManager.shared.toggleFinished(bookId: book.id, book: book)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    private func checkFavoriteStatus() {
        isFavorite = CoreDataManager.shared.isFavorite(bookId: book.id)
    }

    private func checkFinishedStatus() {
        isFinished = CoreDataManager.shared.isFinished(bookId: book.id)
    }
}
