//
//  APIService.swift
//  BookLibrary
//
//  Created by macos on 25/2/26.
//


import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
    case rateLimitExceeded
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL. Please try again."
        case .noData:
            return "No data received from server."
        case .decodingError:
            return "Failed to process book data."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .rateLimitExceeded:
            return "Too many requests. Please try again later."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

class APIService {
    
    static let shared = APIService()
    private let baseURL = "https://www.googleapis.com/books/v1/volumes"
    private let apiKey = "AIzaSyC8KtJQufx1Bek0vRcbsjqHsJNYGkc3wo0"  // 👈 ADD YOUR KEY HERE
    private let cache = NSCache<NSString, NSArray>()
    
    private init() {}
    
    // MARK: - Fetch Books by Category
    func fetchBooks(category: String, maxResults: Int = 20, completion: @escaping (Result<[Book], APIError>) -> Void) {
        
        let query = "subject:\(category)"
        fetchBooks(query: query, maxResults: maxResults, completion: completion)
    }
    
    // MARK: - Search Books
    func searchBooks(query: String, maxResults: Int = 20, completion: @escaping (Result<[Book], APIError>) -> Void) {
        
        fetchBooks(query: query, maxResults: maxResults, completion: completion)
    }
    
    // MARK: - Fetch Books by Query (Private)
    private func fetchBooks(query: String, maxResults: Int, completion: @escaping (Result<[Book], APIError>) -> Void) {
        
        // Check cache first
        let cacheKey = NSString(string: "\(query)-\(maxResults)")
        if let cachedBooks = cache.object(forKey: cacheKey) as? [Book] {
            completion(.success(cachedBooks))
            return
        }
        
        // Build URL with API key
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "maxResults", value: "\(maxResults)"),
            URLQueryItem(name: "printType", value: "books"),
            URLQueryItem(name: "orderBy", value: "relevance"),
            URLQueryItem(name: "key", value: apiKey)  // 👈 ADD API KEY HERE
        ]
        
        guard let url = components?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        print("Fetching URL: \(url.absoluteString)") // For debugging
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 15
        
        // Fetch data
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Handle network error
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.networkError(error)))
                }
                return
            }
            
            // Check for HTTP errors
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    break // Success, continue
                case 429:
                    DispatchQueue.main.async {
                        completion(.failure(.rateLimitExceeded))
                    }
                    return
                default:
                    DispatchQueue.main.async {
                        completion(.failure(.unknown))
                    }
                    return
                }
            }
            
            // Check data
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            // Decode response
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(GoogleBooksResponse.self, from: data)
                let books = response.items ?? []
                
                // Cache results
                self.cache.setObject(books as NSArray, forKey: cacheKey)
                
                DispatchQueue.main.async {
                    completion(.success(books))
                }
                
            } catch {
                print("Decoding error: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    // MARK: - Fetch Book Details by ID
    func fetchBookDetails(bookId: String, completion: @escaping (Result<Book, APIError>) -> Void) {
        
        let urlString = "\(baseURL)/\(bookId)?key=\(apiKey)"  // 👈 ADD API KEY HERE TOO
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.networkError(error)))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            do {
                let book = try JSONDecoder().decode(Book.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(book))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    // MARK: - Clear Cache
    func clearCache() {
        cache.removeAllObjects()
    }
}
