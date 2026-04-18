//
//  BookListView.swift
//  BookLibrary
//
//  Created by macos on 25/2/26.
//

//import SwiftUI
//
//struct BookListView: View {
//    
//    @StateObject private var bookViewModel = BookViewModel()
//    @State private var selectedCategory = "All"
//    @State private var isSearching = false
//    @State private var selectedBook: Book?
//    @State private var showDetail = false
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            // Search Bar
//            searchBar
//            
//            // Category Picker
//            categoryPicker
//            
//            // Book List
//            ZStack {
//                if bookViewModel.isLoading && bookViewModel.books.isEmpty {
//                    loadingView
//                } else {
//                    bookList
//                }
//            }
//        }
//        .navigationTitle("Library")
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                NavigationLink(destination: FavoritesView()) {
//                    Image(systemName: "heart.fill")
//                        .foregroundColor(.red)
//                }
//            }
//        }
//        .onAppear {
//            print("📚 BookListView appeared")
//            if bookViewModel.books.isEmpty {
//                print("📚 Fetching books for category: \(selectedCategory)")
//                bookViewModel.fetchBooks(category: selectedCategory == "All" ? "fiction" : selectedCategory)
//            }
//        }
//        .alert("Error", isPresented: .constant(bookViewModel.errorMessage != nil)) {
//            Button("OK") {
//                bookViewModel.errorMessage = nil
//            }
//            Button("Retry") {
//                let apiCategory = selectedCategory == "All" ? "fiction" : selectedCategory
//                bookViewModel.fetchBooks(category: apiCategory)
//            }
//        } message: {
//            Text(bookViewModel.errorMessage ?? "")
//        }
//        // FIXED: Removed 'return' and simplified sheet
//        .sheet(isPresented: $showDetail) {
//            if let book = selectedBook {
//                BookDetailView(book: book, bookViewModel: bookViewModel)
//            }
//        }
//    }
//    
//    // MARK: - Loading View
//    private var loadingView: some View {
//        VStack(spacing: 20) {
//            ProgressView()
//                .scaleEffect(1.5)
//                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
//            
//            Text("Loading books...")
//                .font(.headline)
//                .foregroundColor(.secondary)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//    }
//    
//    // MARK: - Search Bar
//    private var searchBar: some View {
//        HStack {
//            Image(systemName: "magnifyingglass")
//                .foregroundColor(.gray)
//            
//            TextField("Search books...", text: $bookViewModel.searchText)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .onSubmit {
//                    if !bookViewModel.searchText.isEmpty {
//                        isSearching = true
//                        bookViewModel.searchBooks(query: bookViewModel.searchText)
//                    }
//                }
//            
//            if !bookViewModel.searchText.isEmpty {
//                Button(action: {
//                    bookViewModel.clearSearch()
//                    isSearching = false
//                }) {
//                    Image(systemName: "xmark.circle.fill")
//                        .foregroundColor(.gray)
//                }
//            }
//        }
//        .padding(.horizontal)
//        .padding(.vertical, 8)
//        .background(Color(.systemBackground))
//    }
//    
//    // MARK: - Category Picker
//    private var categoryPicker: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 10) {
//                ForEach(bookViewModel.categories, id: \.self) { category in
//                    categoryButton(category)
//                }
//            }
//            .padding(.horizontal)
//        }
//        .padding(.vertical, 8)
//        .background(Color(.systemGray6))
//    }
//    
//    private func categoryButton(_ category: String) -> some View {
//        Button(action: {
//            selectedCategory = category
//            isSearching = false
//            bookViewModel.clearSearch()
//            let apiCategory = category == "All" ? "fiction" : category
//            print("📚 Category selected: \(category), fetching: \(apiCategory)")
//            bookViewModel.fetchBooks(category: apiCategory)
//        }) {
//            Text(category)
//                .font(.caption)
//                .fontWeight(selectedCategory == category ? .bold : .regular)
//                .padding(.horizontal, 12)
//                .padding(.vertical, 6)
//                .background(selectedCategory == category ? Color.blue : Color.gray.opacity(0.2))
//                .foregroundColor(selectedCategory == category ? .white : .primary)
//                .cornerRadius(15)
//        }
//    }
//    
//    // MARK: - Book List
//    @ViewBuilder
//    private var bookList: some View {
//        let displayBooks = bookViewModel.booksForCurrentMode(isSearching: isSearching)
//        
//        if displayBooks.isEmpty && !bookViewModel.isLoading {
//            emptyStateView
//        } else {
//            List(displayBooks) { book in
//                BookRowView(book: book, bookViewModel: bookViewModel)
//                    .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
//                    .onTapGesture {
//                        print("📚 Book tapped: \(book.volumeInfo.title)")
//                        selectedBook = book
//                        print("📚 selectedBook set to: \(selectedBook?.volumeInfo.title ?? "nil")")
//                        showDetail = true
//                        print("📚 showDetail set to: \(showDetail)")
//                    }
//            }
//            .listStyle(PlainListStyle())
//            .refreshable {
//                let apiCategory = selectedCategory == "All" ? "fiction" : selectedCategory
//                print("📚 Refreshing with category: \(apiCategory)")
//                bookViewModel.fetchBooks(category: apiCategory)
//            }
//        }
//    }
//    
//    // MARK: - Empty State View
//    private var emptyStateView: some View {
//        VStack(spacing: 20) {
//            Image(systemName: isSearching ? "magnifyingglass" : "book.closed")
//                .font(.system(size: 60))
//                .foregroundColor(.gray)
//            
//            Text(isSearching ? "No books found" : "No books available")
//                .font(.headline)
//                .foregroundColor(.gray)
//            
//            if isSearching {
//                Button("Clear Search") {
//                    bookViewModel.clearSearch()
//                    isSearching = false
//                }
//                .font(.subheadline)
//                .foregroundColor(.blue)
//                .padding(.horizontal, 20)
//                .padding(.vertical, 10)
//                .background(Color.blue.opacity(0.1))
//                .cornerRadius(8)
//            } else {
//                Button("Refresh") {
//                    let apiCategory = selectedCategory == "All" ? "fiction" : selectedCategory
//                    bookViewModel.fetchBooks(category: apiCategory)
//                }
//                .font(.subheadline)
//                .foregroundColor(.blue)
//                .padding(.horizontal, 20)
//                .padding(.vertical, 10)
//                .background(Color.blue.opacity(0.1))
//                .cornerRadius(8)
//            }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//    }
//}




//
//
//import SwiftUI
//
//struct BookListView: View {
//
//    @StateObject private var bookViewModel = BookViewModel()
//    @EnvironmentObject private var themeManager: ThemeManager
//    @State private var selectedCategory = "All"
//    @State private var isSearching = false
//    @State private var showSearchBar = false
//    @State private var selectedBook: Book?
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
//    var body: some View {
//        ZStack {
//            pageBackground
//                .ignoresSafeArea()
//
//            VStack(spacing: 10) {
//                topControls
//
//                if showSearchBar {
//                    searchBar
//                        .transition(.move(edge: .top).combined(with: .opacity))
//                }
//
//                ZStack {
//                    if bookViewModel.isLoading && bookViewModel.books.isEmpty {
//                        loadingView
//                    } else {
//                        bookList
//                    }
//                }
//            }
//            .padding(.horizontal, 12)
//            .padding(.top, 10)
//        }
//        .navigationTitle("")
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                NavigationLink(destination: FavoritesView()) {
//                    Image(systemName: "heart.fill")
//                        .foregroundColor(Color(red: 0.95, green: 0.46, blue: 0.67))
//                }
//            }
//        }
//        .onAppear {
//            if bookViewModel.books.isEmpty {
//                bookViewModel.fetchBooks(category: selectedCategory == "All" ? "fiction" : selectedCategory)
//            }
//        }
//        .alert("Error", isPresented: .constant(bookViewModel.errorMessage != nil)) {
//            Button("OK") {
//                bookViewModel.errorMessage = nil
//            }
//            Button("Retry") {
//                let apiCategory = selectedCategory == "All" ? "fiction" : selectedCategory
//                bookViewModel.fetchBooks(category: apiCategory)
//            }
//        } message: {
//            Text(bookViewModel.errorMessage ?? "")
//        }
//        // FIXED: Removed 'return' and simplified sheet
//        .sheet(item: $selectedBook) { book in
//            BookDetailView(book: book, bookViewModel: bookViewModel)
//        }
//    }
//
//    // MARK: - Top Controls
//    private var topControls: some View {
//        HStack(spacing: 10) {
//            Menu {
//                ForEach(bookViewModel.categories, id: \.self) { category in
//                    Button {
//                        applyCategory(category)
//                    } label: {
//                        if selectedCategory == category {
//                            Label(category, systemImage: "checkmark")
//                        } else {
//                            Text(category)
//                        }
//                    }
//                }
//            } label: {
//                HStack(spacing: 8) {
//                    Image(systemName: "line.3.horizontal.decrease.circle")
//                        .font(.system(size: 14, weight: .semibold))
//                    Text(selectedCategory)
//                        .font(.system(size: 14, weight: .semibold, design: .rounded))
//                        .lineLimit(1)
//                    Image(systemName: "chevron.down")
//                        .font(.system(size: 11, weight: .semibold))
//                }
//                .foregroundColor(primaryText)
//                .padding(.horizontal, 12)
//                .padding(.vertical, 10)
//                .background(fieldBackground)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(borderColor, lineWidth: 1)
//                )
//                .cornerRadius(10)
//            }
//
//            Spacer()
//
//            Button {
//                withAnimation(.easeInOut(duration: 0.2)) {
//                    showSearchBar.toggle()
//                    if showSearchBar {
//                        isSearching = true
//                    } else {
//                        isSearching = false
//                        bookViewModel.clearSearch()
//                    }
//                }
//            } label: {
//                Image(systemName: showSearchBar ? "xmark" : "magnifyingglass")
//                    .font(.system(size: 14, weight: .semibold))
//                    .foregroundColor(primaryText)
//                    .frame(width: 40, height: 40)
//                    .background(fieldBackground)
//                    .clipShape(Circle())
//                    .overlay(Circle().stroke(borderColor, lineWidth: 1))
//            }
//        }
//        .padding(10)
//        .background(cardBackground)
//        .overlay(
//            RoundedRectangle(cornerRadius: 12)
//                .stroke(borderColor, lineWidth: 1)
//        )
//        .cornerRadius(12)
//    }
//    
//    // MARK: - Loading View
//    private var loadingView: some View {
//        VStack(spacing: 20) {
//            ProgressView()
//                .scaleEffect(1.5)
//                .progressViewStyle(CircularProgressViewStyle(tint: accent))
//            
//            Text("Loading books...")
//                .font(.headline)
//                .foregroundColor(secondaryText)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//    }
//    
//    // MARK: - Search Bar
//    private var searchBar: some View {
//        HStack {
//            Image(systemName: "magnifyingglass")
//                .foregroundColor(secondaryText)
//            
//            TextField("Search books...", text: $bookViewModel.searchText)
//                .font(.system(size: 15, design: .rounded))
//                .foregroundColor(primaryText)
//                .onSubmit {
//                    if !bookViewModel.searchText.isEmpty {
//                        isSearching = true
//                        bookViewModel.searchBooks(query: bookViewModel.searchText)
//                    }
//                }
//            
//            if !bookViewModel.searchText.isEmpty {
//                Button(action: {
//                    bookViewModel.clearSearch()
//                    isSearching = false
//                }) {
//                    Image(systemName: "xmark.circle.fill")
//                        .foregroundColor(secondaryText)
//                }
//            }
//        }
//        .padding(.horizontal, 12)
//        .padding(.vertical, 10)
//        .background(fieldBackground)
//        .overlay(
//            RoundedRectangle(cornerRadius: 12)
//                .stroke(borderColor, lineWidth: 1)
//        )
//        .cornerRadius(12)
//    }
//
//    private func applyCategory(_ category: String) {
//        selectedCategory = category
//        isSearching = false
//        showSearchBar = false
//        bookViewModel.clearSearch()
//        let apiCategory = category == "All" ? "fiction" : category
//        bookViewModel.fetchBooks(category: apiCategory)
//    }
//    
//    // MARK: - Book List
//    @ViewBuilder
//    private var bookList: some View {
//        let displayBooks = prioritizedBooks(from: bookViewModel.booksForCurrentMode(isSearching: isSearching))
//        
//        if displayBooks.isEmpty && !bookViewModel.isLoading {
//            emptyStateView
//        } else {
//            List(displayBooks) { book in
//                BookRowView(book: book, bookViewModel: bookViewModel)
//                    .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
//                    .listRowBackground(Color.clear)
//                    .onTapGesture {
//                        selectedBook = book
//                    }
//            }
//            .listStyle(PlainListStyle())
//            .scrollContentBackground(.hidden)
//            .background(Color.clear)
//            .refreshable {
//                let apiCategory = selectedCategory == "All" ? "fiction" : selectedCategory
//                bookViewModel.fetchBooks(category: apiCategory)
//            }
//        }
//    }
//
//    private func prioritizedBooks(from books: [Book]) -> [Book] {
//        books.sorted { lhs, rhs in
//            let lhsPriority = bangladeshPriority(for: lhs)
//            let rhsPriority = bangladeshPriority(for: rhs)
//
//            if lhsPriority != rhsPriority {
//                return lhsPriority > rhsPriority
//            }
//
//            return lhs.volumeInfo.title.localizedCaseInsensitiveCompare(rhs.volumeInfo.title) == .orderedAscending
//        }
//    }
//
//    private func bangladeshPriority(for book: Book) -> Int {
//        let searchableParts: [String] = [
//            book.volumeInfo.title,
//            book.volumeInfo.subtitle,
//            book.volumeInfo.authorNames,
//            book.volumeInfo.publisher,
//            book.volumeInfo.description,
//            book.volumeInfo.categories?.joined(separator: " ")
//        ].compactMap { $0?.lowercased() }
//
//        let searchableText = searchableParts.joined(separator: " ")
//        if searchableText.contains("bangladesh") || searchableText.contains("bangladeshi") || searchableText.contains("dhaka") {
//            return 1
//        }
//
//        return 0
//    }
//    
//    // MARK: - Empty State View
//    private var emptyStateView: some View {
//        VStack(spacing: 20) {
//            Image(systemName: isSearching ? "magnifyingglass" : "book.closed")
//                .font(.system(size: 60))
//                .foregroundColor(secondaryText)
//            
//            Text(isSearching ? "No books found" : "No books available")
//                .font(.headline)
//                .foregroundColor(primaryText)
//            
//            if isSearching {
//                Button("Clear Search") {
//                    bookViewModel.clearSearch()
//                    isSearching = false
//                    showSearchBar = false
//                }
//                .font(.subheadline)
//                .foregroundColor(accent)
//                .padding(.horizontal, 20)
//                .padding(.vertical, 10)
//                .background(accent.opacity(0.12))
//                .cornerRadius(8)
//            } else {
//                Button("Refresh") {
//                    let apiCategory = selectedCategory == "All" ? "fiction" : selectedCategory
//                    bookViewModel.fetchBooks(category: apiCategory)
//                }
//                .font(.subheadline)
//                .foregroundColor(accent)
//                .padding(.horizontal, 20)
//                .padding(.vertical, 10)
//                .background(accent.opacity(0.12))
//                .cornerRadius(8)
//            }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//    }
//}
//




import SwiftUI
import FirebaseAuth

struct BookListView: View {

    @StateObject private var bookViewModel = BookViewModel()
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var selectedCategory = "All"
    @State private var isSearching = false
    @State private var showSearchBar = false
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
    
    var body: some View {
        ZStack {
            pageBackground
                .ignoresSafeArea()

            VStack(spacing: 10) {
                topControls

                if showSearchBar {
                    searchBar
                        .transition(.move(edge: .top).combined(with: .opacity))
                }

                ZStack {
                    if bookViewModel.isLoading && bookViewModel.books.isEmpty {
                        loadingView
                    } else {
                        bookList
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 10)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: FavoritesView()) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(Color(red: 0.95, green: 0.46, blue: 0.67))
                }
            }
        }
        .onAppear {
            if bookViewModel.books.isEmpty {
                bookViewModel.fetchBooks(category: selectedCategory == "All" ? "fiction" : selectedCategory)
            }
        }
        .alert("Error", isPresented: .constant(bookViewModel.errorMessage != nil)) {
            Button("OK") {
                bookViewModel.errorMessage = nil
            }
            Button("Retry") {
                let apiCategory = selectedCategory == "All" ? "fiction" : selectedCategory
                bookViewModel.fetchBooks(category: apiCategory)
            }
        } message: {
            Text(bookViewModel.errorMessage ?? "")
        }
        // FIXED: Removed 'return' and simplified sheet
        .sheet(item: $selectedBook) { book in
            BookDetailView(book: book, bookViewModel: bookViewModel)
        }
    }

    // MARK: - Top Controls
    private var topControls: some View {
        HStack(spacing: 10) {
            Menu {
                ForEach(bookViewModel.categories, id: \.self) { category in
                    Button {
                        applyCategory(category)
                    } label: {
                        if selectedCategory == category {
                            Label(category, systemImage: "checkmark")
                        } else {
                            Text(category)
                        }
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.system(size: 14, weight: .semibold))
                    Text(selectedCategory)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .lineLimit(1)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 11, weight: .semibold))
                }
                .foregroundColor(primaryText)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(fieldBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(borderColor, lineWidth: 1)
                )
                .cornerRadius(10)
            }

            Spacer()

            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showSearchBar.toggle()
                    if showSearchBar {
                        isSearching = true
                    } else {
                        isSearching = false
                        bookViewModel.clearSearch()
                    }
                }
            } label: {
                Image(systemName: showSearchBar ? "xmark" : "magnifyingglass")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(primaryText)
                    .frame(width: 40, height: 40)
                    .background(fieldBackground)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(borderColor, lineWidth: 1))
            }
        }
        .padding(10)
        .background(cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor, lineWidth: 1)
        )
        .cornerRadius(12)
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .progressViewStyle(CircularProgressViewStyle(tint: accent))
            
            Text("Loading books...")
                .font(.headline)
                .foregroundColor(secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Search Bar
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(secondaryText)
            
            TextField("Search books...", text: $bookViewModel.searchText)
                .font(.system(size: 15, design: .rounded))
                .foregroundColor(primaryText)
                .onSubmit {
                    if !bookViewModel.searchText.isEmpty {
                        isSearching = true
                        bookViewModel.searchBooks(query: bookViewModel.searchText)
                    }
                }
            
            if !bookViewModel.searchText.isEmpty {
                Button(action: {
                    bookViewModel.clearSearch()
                    isSearching = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(secondaryText)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(fieldBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor, lineWidth: 1)
        )
        .cornerRadius(12)
    }

    private func applyCategory(_ category: String) {
        selectedCategory = category
        isSearching = false
        showSearchBar = false
        bookViewModel.clearSearch()

        if let uid = Auth.auth().currentUser?.uid {
            RecommendationTracker.shared.trackBrowsedCategory(category, userId: uid)
        }

        let apiCategory = category == "All" ? "fiction" : category
        bookViewModel.fetchBooks(category: apiCategory)
    }
    
    // MARK: - Book List
    @ViewBuilder
    private var bookList: some View {
        let displayBooks = bookViewModel.booksForCurrentMode(isSearching: isSearching)
        
        if displayBooks.isEmpty && !bookViewModel.isLoading {
            emptyStateView
        } else {
            List(displayBooks) { book in
                BookRowView(book: book, bookViewModel: bookViewModel)
                    .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                    .listRowBackground(Color.clear)
                    .onTapGesture {
                        if let uid = Auth.auth().currentUser?.uid {
                            RecommendationTracker.shared.trackViewedBook(book, userId: uid)
                        }
                        selectedBook = book
                    }
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .refreshable {
                let apiCategory = selectedCategory == "All" ? "fiction" : selectedCategory
                bookViewModel.fetchBooks(category: apiCategory)
            }
        }
    }
    
    // MARK: - Empty State View
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: isSearching ? "magnifyingglass" : "book.closed")
                .font(.system(size: 60))
                .foregroundColor(secondaryText)
            
            Text(isSearching ? "No books found" : "No books available")
                .font(.headline)
                .foregroundColor(primaryText)
            
            if isSearching {
                Button("Clear Search") {
                    bookViewModel.clearSearch()
                    isSearching = false
                    showSearchBar = false
                }
                .font(.subheadline)
                .foregroundColor(accent)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(accent.opacity(0.12))
                .cornerRadius(8)
            } else {
                Button("Refresh") {
                    let apiCategory = selectedCategory == "All" ? "fiction" : selectedCategory
                    bookViewModel.fetchBooks(category: apiCategory)
                }
                .font(.subheadline)
                .foregroundColor(accent)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(accent.opacity(0.12))
                .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
