//
//  APIService.swift
//  BookLibrary
//
//  Created by macos on 25/2/26.
//

//
//import Foundation
//
//enum APIError: Error, LocalizedError {
//    case invalidURL
//    case noData
//    case decodingError
//    case networkError(Error)
//    case rateLimitExceeded
//    case unknown
//    
//    var errorDescription: String? {
//        switch self {
//        case .invalidURL:
//            return "Invalid URL. Please try again."
//        case .noData:
//            return "No data received from server."
//        case .decodingError:
//            return "Failed to process book data."
//        case .networkError(let error):
//            return "Network error: \(error.localizedDescription)"
//        case .rateLimitExceeded:
//            return "Too many requests. Please try again later."
//        case .unknown:
//            return "An unknown error occurred."
//        }
//    }
//}
//
//class APIService {
//    
//    static let shared = APIService()
//    private let baseURL = "https://www.googleapis.com/books/v1/volumes"
//    private let apiKey = "AIzaSyC8KtJQufx1Bek0vRcbsjqHsJNYGkc3wo0"  // 👈 ADD YOUR KEY HERE
//    private let cache = NSCache<NSString, NSArray>()
//    
//    private init() {}
//    
//    // MARK: - Fetch Books by Category
//    func fetchBooks(category: String, maxResults: Int = 20, completion: @escaping (Result<[Book], APIError>) -> Void) {
//        
//        let query = "subject:\(category)"
//        fetchBooks(query: query, maxResults: maxResults, completion: completion)
//    }
//    
//    // MARK: - Search Books
//    func searchBooks(query: String, maxResults: Int = 20, completion: @escaping (Result<[Book], APIError>) -> Void) {
//        
//        fetchBooks(query: query, maxResults: maxResults, completion: completion)
//    }
//    
//    // MARK: - Fetch Books by Query (Private)
//    private func fetchBooks(query: String, maxResults: Int, completion: @escaping (Result<[Book], APIError>) -> Void) {
//        
//        // Check cache first
//        let cacheKey = NSString(string: "\(query)-\(maxResults)")
//        if let cachedBooks = cache.object(forKey: cacheKey) as? [Book] {
//            completion(.success(cachedBooks))
//            return
//        }
//        
//        // Build URL with API key
//        var components = URLComponents(string: baseURL)
//        components?.queryItems = [
//            URLQueryItem(name: "q", value: query),
//            URLQueryItem(name: "maxResults", value: "\(maxResults)"),
//            URLQueryItem(name: "printType", value: "books"),
//            URLQueryItem(name: "orderBy", value: "relevance"),
//            URLQueryItem(name: "key", value: apiKey)  // 👈 ADD API KEY HERE
//        ]
//        
//        guard let url = components?.url else {
//            completion(.failure(.invalidURL))
//            return
//        }
//        
//        print("Fetching URL: \(url.absoluteString)") // For debugging
//        
//        // Create request
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        request.timeoutInterval = 15
//        
//        // Fetch data
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            
//            // Handle network error
//            if let error = error {
//                DispatchQueue.main.async {
//                    completion(.failure(.networkError(error)))
//                }
//                return
//            }
//            
//            // Check for HTTP errors
//            if let httpResponse = response as? HTTPURLResponse {
//                switch httpResponse.statusCode {
//                case 200:
//                    break // Success, continue
//                case 429:
//                    DispatchQueue.main.async {
//                        completion(.failure(.rateLimitExceeded))
//                    }
//                    return
//                default:
//                    DispatchQueue.main.async {
//                        completion(.failure(.unknown))
//                    }
//                    return
//                }
//            }
//            
//            // Check data
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    completion(.failure(.noData))
//                }
//                return
//            }
//            
//            // Decode response
//            do {
//                let decoder = JSONDecoder()
//                let response = try decoder.decode(GoogleBooksResponse.self, from: data)
//                let books = response.items ?? []
//                
//                // Cache results
//                self.cache.setObject(books as NSArray, forKey: cacheKey)
//                
//                DispatchQueue.main.async {
//                    completion(.success(books))
//                }
//                
//            } catch {
//                print("Decoding error: \(error)")
//                DispatchQueue.main.async {
//                    completion(.failure(.decodingError))
//                }
//            }
//        }.resume()
//    }
//    
//    // MARK: - Fetch Book Details by ID
//    func fetchBookDetails(bookId: String, completion: @escaping (Result<Book, APIError>) -> Void) {
//        
//        let urlString = "\(baseURL)/\(bookId)?key=\(apiKey)"  // 👈 ADD API KEY HERE TOO
//        
//        guard let url = URL(string: urlString) else {
//            completion(.failure(.invalidURL))
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            
//            if let error = error {
//                DispatchQueue.main.async {
//                    completion(.failure(.networkError(error)))
//                }
//                return
//            }
//            
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    completion(.failure(.noData))
//                }
//                return
//            }
//            
//            do {
//                let book = try JSONDecoder().decode(Book.self, from: data)
//                DispatchQueue.main.async {
//                    completion(.success(book))
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(.failure(.decodingError))
//                }
//            }
//        }.resume()
//    }
//    
//    // MARK: - Clear Cache
//    func clearCache() {
//        cache.removeAllObjects()
//    }
//}

//
//  APIService.swift
//  BookLibrary
//
//  Created by macos on 25/2/26.
//

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
    case noInternet
    case badRequest(String?)
    case unauthorized
    case forbidden(String?)
    case notFound
    case rateLimitExceeded
    case serverError(Int)
    case httpError(Int, String?)
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
        case .noInternet:
            return "No internet connection. Please check your network and try again."
        case .badRequest(let details):
            return details ?? "Bad request sent to server."
        case .unauthorized:
            return "Unauthorized request. Please verify API credentials."
        case .forbidden(let details):
            return details ?? "Access forbidden. Check API key restrictions and billing."
        case .notFound:
            return "Requested resource was not found."
        case .rateLimitExceeded:
            return "Too many requests. Please try again later."
        case .serverError:
            return "Server error. Please try again in a moment."
        case .httpError(let code, let details):
            return details ?? "HTTP error \(code)."
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
    private let maxRetryCount = 2
    
    private init() {}

    // MARK: - Error Helpers
    private func mapNetworkError(_ error: Error) -> APIError {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost, .cannotFindHost, .cannotConnectToHost, .dnsLookupFailed:
                return .noInternet
            case .timedOut:
                return .networkError(urlError)
            default:
                return .networkError(urlError)
            }
        }
        return .networkError(error)
    }

    private func parseGoogleAPIMessage(from data: Data?) -> String? {
        guard let data else { return nil }

        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let error = json["error"] as? [String: Any] {
            if let message = error["message"] as? String, !message.isEmpty {
                return message
            }
        }
        return nil
    }

    private func mapHTTPStatus(_ statusCode: Int, data: Data?) -> APIError {
        let details = parseGoogleAPIMessage(from: data)
        switch statusCode {
        case 200:
            return .unknown
        case 400:
            return .badRequest(details)
        case 401:
            return .unauthorized
        case 403:
            return .forbidden(details)
        case 404:
            return .notFound
        case 429:
            return .rateLimitExceeded
        case 500...599:
            return .serverError(statusCode)
        default:
            return .httpError(statusCode, details)
        }
    }

    private func shouldRetry(for error: APIError, attempt: Int) -> Bool {
        guard attempt < maxRetryCount else { return false }

        switch error {
        case .serverError:
            return true
        case .httpError(let code, _):
            return code == 502 || code == 503 || code == 504
        case .networkError(let wrapped):
            guard let urlError = wrapped as? URLError else { return false }
            return urlError.code == .timedOut ||
                urlError.code == .networkConnectionLost ||
                urlError.code == .cannotConnectToHost ||
                urlError.code == .cannotFindHost
        default:
            return false
        }
    }

    private func retryDelay(for attempt: Int) -> TimeInterval {
        0.8 * pow(2.0, Double(attempt))
    }

    private func performBooksRequest(
        request: URLRequest,
        cacheKey: NSString,
        attempt: Int,
        completion: @escaping (Result<[Book], APIError>) -> Void
    ) {
        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                let mapped = self.mapNetworkError(error)
                if self.shouldRetry(for: mapped, attempt: attempt) {
                    DispatchQueue.global().asyncAfter(deadline: .now() + self.retryDelay(for: attempt)) {
                        self.performBooksRequest(
                            request: request,
                            cacheKey: cacheKey,
                            attempt: attempt + 1,
                            completion: completion
                        )
                    }
                    return
                }

                DispatchQueue.main.async {
                    completion(.failure(mapped))
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode != 200 {
                let mapped = self.mapHTTPStatus(httpResponse.statusCode, data: data)
                if self.shouldRetry(for: mapped, attempt: attempt) {
                    DispatchQueue.global().asyncAfter(deadline: .now() + self.retryDelay(for: attempt)) {
                        self.performBooksRequest(
                            request: request,
                            cacheKey: cacheKey,
                            attempt: attempt + 1,
                            completion: completion
                        )
                    }
                    return
                }

                DispatchQueue.main.async {
                    completion(.failure(mapped))
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
                let response = try JSONDecoder().decode(GoogleBooksResponse.self, from: data)
                let books = response.items ?? []
                self.cache.setObject(books as NSArray, forKey: cacheKey)

                DispatchQueue.main.async {
                    completion(.success(books))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
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
        
        performBooksRequest(request: request, cacheKey: cacheKey, attempt: 0, completion: completion)
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
                    completion(.failure(self.mapNetworkError(error)))
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode != 200 {
                let mappedError = self.mapHTTPStatus(httpResponse.statusCode, data: data)
                DispatchQueue.main.async {
                    completion(.failure(mappedError))
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
