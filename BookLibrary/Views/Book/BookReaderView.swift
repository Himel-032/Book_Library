//
//  BookReaderView.swift
//  BookLibrary
//
//  Created by [Your Name] on [Date].
//
//
//import SwiftUI
//
//struct BookReaderView: View {
//    let book: Book
//    @Environment(\.dismiss) var dismiss
//    @State private var showControls = true
//    @State private var isLoading = true
//    
//    var body: some View {
//        ZStack {
//            // WebView for reading
//            GoogleBooksWebView(bookId: book.id)
//                .edgesIgnoringSafeArea(.all)
//                .overlay(
//                    // Loading overlay
//                    Group {
//                        if isLoading {
//                            Color.white
//                                .overlay(
//                                    VStack {
//                                        ProgressView()
//                                            .scaleEffect(1.5)
//                                        Text("Loading book...")
//                                            .font(.headline)
//                                            .foregroundColor(.secondary)
//                                            .padding(.top)
//                                    }
//                                )
//                                .transition(.opacity)
//                        }
//                    }
//                )
//                .onAppear {
//                    // Simulate loading delay
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        withAnimation {
//                            isLoading = false
//                        }
//                    }
//                }
//            
//            // Top Controls (appear on tap)
//            VStack {
//                if showControls {
//                    HStack {
//                        Button(action: { dismiss() }) {
//                            Image(systemName: "xmark")
//                                .font(.title2)
//                                .foregroundColor(.primary)
//                                .padding(12)
//                                .background(Color(.systemBackground).opacity(0.8))
//                                .clipShape(Circle())
//                                .shadow(radius: 3)
//                        }
//                        
//                        Spacer()
//                        
//                        // Book info
//                        VStack(alignment: .trailing) {
//                            Text(book.volumeInfo.title)
//                                .font(.headline)
//                                .lineLimit(1)
//                            Text(book.volumeInfo.authorNames)
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//                        }
//                        .padding(.horizontal, 12)
//                        .padding(.vertical, 8)
//                        .background(Color(.systemBackground).opacity(0.8))
//                        .cornerRadius(20)
//                        .shadow(radius: 3)
//                    }
//                    .padding()
//                    .transition(.move(edge: .top))
//                }
//                
//                Spacer()
//                
//                // Bottom hint
//                if showControls {
//                    Text("Tap anywhere to hide controls")
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                        .padding(.horizontal, 16)
//                        .padding(.vertical, 8)
//                        .background(Color(.systemBackground).opacity(0.7))
//                        .cornerRadius(20)
//                        .padding(.bottom)
//                        .transition(.move(edge: .bottom))
//                }
//            }
//        }
//        .onTapGesture {
//            withAnimation(.easeInOut(duration: 0.3)) {
//                showControls.toggle()
//            }
//        }
//    }
//}

//
//  BookReaderView.swift
//  BookLibrary
//
//  Created by Himel on 13/3/26.
//


import SwiftUI

struct BookReaderView: View {
    let book: Book
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showControls = true
    @State private var isLoading = true
    @State private var loadError: String?

    private var isDarkMode: Bool {
        themeManager.currentTheme == .dark
    }

    private var overlayBackground: Color {
        isDarkMode ? Color.black.opacity(0.65) : Color.black.opacity(0.35)
    }

    private var chipBackground: Color {
        isDarkMode ? Color.white.opacity(0.14) : Color.white.opacity(0.88)
    }

    private var borderColor: Color {
        isDarkMode ? Color.white.opacity(0.20) : Color.black.opacity(0.08)
    }

    private var primaryText: Color {
        isDarkMode ? .white : Color(red: 0.16, green: 0.14, blue: 0.13)
    }

    private var secondaryText: Color {
        isDarkMode ? Color.white.opacity(0.72) : Color(red: 0.46, green: 0.42, blue: 0.39)
    }

    private var accent: Color {
        Color(red: 0.18, green: 0.38, blue: 0.26)
    }
    
    var body: some View {
        ZStack {
            GoogleBooksWebView(
                bookId: book.id,
                onLoadStart: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        loadError = nil
                        isLoading = true
                    }
                },
                onLoadFinish: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isLoading = false
                    }
                },
                onLoadError: { error in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isLoading = false
                        loadError = error
                    }
                }
            )
                .edgesIgnoringSafeArea(.all)

            if isLoading {
                loadingOverlay
            }

            if let error = loadError {
                errorOverlay(message: error)
            }

            VStack {
                if showControls {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(accent)
                                .padding(12)
                                .background(chipBackground)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(borderColor, lineWidth: 1))
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text(book.volumeInfo.title)
                                .font(.system(size: 15, weight: .semibold, design: .serif))
                                .lineLimit(1)
                                .foregroundColor(primaryText)
                            Text(book.volumeInfo.authorNames)
                                .font(.system(size: 12, design: .rounded))
                                .foregroundColor(secondaryText)
                                .lineLimit(1)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(chipBackground)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(borderColor, lineWidth: 1)
                        )
                    }
                    .padding()
                    .transition(.move(edge: .top))
                }
                
                Spacer()
                
                if showControls {
                    HStack(spacing: 7) {
                        Image(systemName: "hand.tap")
                            .font(.system(size: 11, weight: .semibold))
                        Text("Tap anywhere to hide controls")
                            .font(.system(size: 12, design: .rounded))
                    }
                    .foregroundColor(secondaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(chipBackground)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(borderColor, lineWidth: 1)
                    )
                    .padding(.bottom)
                    .transition(.move(edge: .bottom))
                }
            }

            if !showControls {
                VStack {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(accent)
                                .padding(11)
                                .background(chipBackground)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(borderColor, lineWidth: 1))
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    Spacer()
                }
                .transition(.opacity)
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showControls.toggle()
                        }
                    } label: {
                        Image(systemName: showControls ? "eye.slash" : "eye")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(primaryText)
                            .padding(12)
                            .background(chipBackground)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(borderColor, lineWidth: 1))
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
        }
    }

    private var loadingOverlay: some View {
        overlayBackground
            .ignoresSafeArea()
            .overlay(
                VStack(spacing: 12) {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.35)
                    Text("Loading book preview...")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color.black.opacity(0.35))
                .cornerRadius(14)
            )
            .transition(.opacity)
    }

    private func errorOverlay(message: String) -> some View {
        overlayBackground
            .ignoresSafeArea()
            .overlay(
                VStack(spacing: 10) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 26))
                        .foregroundColor(.white)
                    Text("Preview unavailable")
                        .font(.system(size: 16, weight: .semibold, design: .serif))
                        .foregroundColor(.white)
                    Text(message)
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)

                    Button("Close") {
                        dismiss()
                    }
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(accent)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.top, 4)
                }
                .padding(18)
                .background(Color.black.opacity(0.42))
                .cornerRadius(14)
                .padding(.horizontal, 30)
            )
            .transition(.opacity)
    }
}
