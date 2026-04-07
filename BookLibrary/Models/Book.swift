//
//  Book.swift
//  BookLibrary
//
//  Created by macos on 25/2/26.
//


//  https://www.googleapis.com/books/v1/volumes?q=harry+potter
import Foundation

//  Google Books API Response
struct GoogleBooksResponse: Codable {
    let items: [Book]?
}

//  Book Model
struct Book: Codable, Identifiable {
    let id: String
    let volumeInfo: VolumeInfo
    let accessInfo: AccessInfo? // Added for embed information
    
    // For Core Data compatibility
    var uniqueId: String {
        return id
    }
    
    // Custom init to handle missing accessInfo
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        volumeInfo = try container.decode(VolumeInfo.self, forKey: .volumeInfo)
        accessInfo = try container.decodeIfPresent(AccessInfo.self, forKey: .accessInfo)
    }
    
    // Manual initializer for preview/sample data
    init(id: String, volumeInfo: VolumeInfo, accessInfo: AccessInfo? = nil) {
        self.id = id
        self.volumeInfo = volumeInfo
        self.accessInfo = accessInfo
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case volumeInfo
        case accessInfo
    }
}

//  AccessInfo (Added for embed support)
struct AccessInfo: Codable {
    let country: String?
    let viewability: String?
    let embeddable: Bool?
    let publicDomain: Bool?
    let textToSpeechPermission: String?
    let epub: EpubInfo?
    let pdf: PdfInfo?
    let webReaderLink: String?
    let accessViewStatus: String?
    let quoteSharingAllowed: Bool?
    
    // Computed property to check if book can be embedded
    var isEmbeddable: Bool {
        return embeddable == true && webReaderLink != nil
    }
    
    // Computed property to check if preview is available
    var hasPreview: Bool {
        return accessViewStatus != "NONE" && webReaderLink != nil
    }
}

// Epub Info
struct EpubInfo: Codable {
    let isAvailable: Bool?
    let acsTokenLink: String?
}

// Pdf Info
struct PdfInfo: Codable {
    let isAvailable: Bool?
    let acsTokenLink: String?
}

//  VolumeInfo (Book Details) - Enhanced
struct VolumeInfo: Codable {
    let title: String
    let subtitle: String?
    let authors: [String]?
    let publisher: String?
    let publishedDate: String?
    let description: String?
    let pageCount: Int?
    let categories: [String]?
    let imageLinks: ImageLinks?
    let language: String?
    let previewLink: String?
    let infoLink: String?
    let canonicalVolumeLink: String?
    
    // Computed properties for safe access
    var authorNames: String {
        return authors?.joined(separator: ", ") ?? "Unknown Author"
    }
    
    var thumbnailUrl: URL? {
        guard let urlString = imageLinks?.thumbnail else { return nil }
        // Fix HTTP URLs to HTTPS
        let secureUrlString = urlString.replacingOccurrences(of: "http://", with: "https://")
        return URL(string: secureUrlString)
    }
    
    var smallThumbnailUrl: URL? {
        guard let urlString = imageLinks?.smallThumbnail else { return nil }
        let secureUrlString = urlString.replacingOccurrences(of: "http://", with: "https://")
        return URL(string: secureUrlString)
    }
    
    var categoryList: String {
        return categories?.joined(separator: ", ") ?? "Uncategorized"
    }
    
    var displayTitle: String {
        if let subtitle = subtitle, !subtitle.isEmpty {
            return "\(title): \(subtitle)"
        }
        return title
    }
    
    var formattedLanguage: String {
        guard let language = language else { return "Unknown" }
        switch language.lowercased() {
        case "en": return "English"
        case "es": return "Spanish"
        case "fr": return "French"
        case "de": return "German"
        case "it": return "Italian"
        case "pt": return "Portuguese"
        case "ru": return "Russian"
        case "zh": return "Chinese"
        case "ja": return "Japanese"
        case "ko": return "Korean"
        case "ar": return "Arabic"
        case "hi": return "Hindi"
        case "bn": return "Bengali" // For Bangladesh
        default: return language.uppercased()
        }
    }
    
    var formattedPublishedDate: String {
        guard let date = publishedDate else { return "Unknown" }
        
        // If it's just a year, return as is
        if date.count == 4 && Int(date) != nil {
            return date
        }
        
        // Try to format full date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let formattedDate = formatter.date(from: date) {
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter.string(from: formattedDate)
        }
        
        return date
    }
    
    var hasPreview: Bool {
        return previewLink != nil
    }
    
    var googleBooksUrl: URL? {
        guard let previewLink = previewLink else { return nil }
        return URL(string: previewLink)
    }
}

// Image Links
struct ImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
    let small: String?
    let medium: String?
    let large: String?
    let extraLarge: String?
    
    // Get best available image
    var bestImageUrl: URL? {
        if let urlString = extraLarge ?? large ?? medium ?? small ?? thumbnail ?? smallThumbnail {
            let secureUrlString = urlString.replacingOccurrences(of: "http://", with: "https://")
            return URL(string: secureUrlString)
        }
        return nil
    }
}

//  Book Extensions for UI
extension Book {
    var canBeRead: Bool {
        // Check if there's a preview link OR if it's embeddable
        return volumeInfo.hasPreview || (accessInfo?.isEmbeddable == true)
    }
    
    var readingUrl: URL? {
        // Prefer webReaderLink if available, otherwise use previewLink
        if let webReaderLink = accessInfo?.webReaderLink {
            return URL(string: webReaderLink)
        }
        return volumeInfo.googleBooksUrl
    }
    
    var embeddable: Bool {
        return accessInfo?.isEmbeddable == true
    }
    
    var previewStatus: String {
        guard let status = accessInfo?.accessViewStatus else {
            return volumeInfo.hasPreview ? "Preview Available" : "No Preview"
        }
        
        switch status {
        case "FULL": return "Full View"
        case "PARTIAL": return "Preview"
        case "SAMPLE": return "Sample"
        case "NONE": return "No Preview"
        default: return status
        }
    }
}

//  Sample Books for Preview
extension Book {
    static var sampleBook: Book {
        let volumeInfo = VolumeInfo(
            title: "Sample Book Title",
            subtitle: "With a Subtitle",
            authors: ["John Doe", "Jane Smith"],
            publisher: "Sample Publisher",
            publishedDate: "2024",
            description: "This is a sample book description that demonstrates how a typical book description might look in the app. It contains multiple sentences to show how the text wraps and appears in the UI.",
            pageCount: 350,
            categories: ["Fiction", "Science Fiction", "Adventure"],
            imageLinks: ImageLinks(
                smallThumbnail: nil,
                thumbnail: nil,
                small: nil,
                medium: nil,
                large: nil,
                extraLarge: nil
            ),
            language: "en",
            previewLink: "https://books.google.com/books?id=sample",
            infoLink: "https://books.google.com/books?id=sample",
            canonicalVolumeLink: "https://books.google.com/books/about/Sample.html?id=sample"
        )
        
        let accessInfo = AccessInfo(
            country: "US",
            viewability: "PARTIAL",
            embeddable: true,
            publicDomain: false,
            textToSpeechPermission: "ALLOWED",
            epub: EpubInfo(isAvailable: true, acsTokenLink: nil),
            pdf: PdfInfo(isAvailable: true, acsTokenLink: nil),
            webReaderLink: "https://play.google.com/books/reader?id=sample",
            accessViewStatus: "SAMPLE",
            quoteSharingAllowed: true
        )
        
        return Book(id: "sample123", volumeInfo: volumeInfo, accessInfo: accessInfo)
    }
}
