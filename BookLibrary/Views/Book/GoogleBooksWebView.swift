
//
//import SwiftUI
//import WebKit
//
//struct GoogleBooksWebView: UIViewRepresentable {
//    let bookId: String
//    let initialPage: Int?
//    
//    init(bookId: String, initialPage: Int? = nil) {
//        self.bookId = bookId
//        self.initialPage = initialPage
//    }
//    
//    func makeUIView(context: Context) -> WKWebView {
//        let webView = WKWebView()
//        webView.navigationDelegate = context.coordinator
//        webView.backgroundColor = .white
//        return webView
//    }
//    
//    func updateUIView(_ webView: WKWebView, context: Context) {
//        loadBook(in: webView)
//    }
//    
//    private func loadBook(in webView: WKWebView) {
//        // Create HTML that loads the Google Books embed
//        let htmlString = """
//        <!DOCTYPE html>
//        <html>
//        <head>
//            <meta name="viewport" content="width=device-width, initial-scale=1.0">
//            <script type="text/javascript" src="https://www.google.com/books/jsapi.js"></script>
//            <script type="text/javascript">
//              google.books.load();
//              
//              function initialize() {
//                var viewer = new google.books.DefaultViewer(document.getElementById('viewerCanvas'));
//                viewer.load('\(bookId)'\(initialPage != nil ? ", { initialPage: \(initialPage!) }" : ""));
//              }
//              
//              google.books.setOnLoadCallback(initialize);
//            </script>
//            <style>
//              body { margin: 0; padding: 0; }
//              #viewerCanvas { width: 100%; height: 100vh; }
//            </style>
//        </head>
//        <body>
//            <div id="viewerCanvas"></div>
//        </body>
//        </html>
//        """
//        
//        webView.loadHTMLString(htmlString, baseURL: nil)
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    class Coordinator: NSObject, WKNavigationDelegate {
//        var parent: GoogleBooksWebView
//        
//        init(_ parent: GoogleBooksWebView) {
//            self.parent = parent
//        }
//        
//        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//            print("Failed to load book: \(error.localizedDescription)")
//        }
//        
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            print("Book viewer loaded successfully")
//        }
//    }
//}


import SwiftUI
import WebKit

struct GoogleBooksWebView: UIViewRepresentable {
    let bookId: String
    let initialPage: Int?
    var onLoadStart: (() -> Void)? = nil
    var onLoadFinish: (() -> Void)? = nil
    var onLoadError: ((String) -> Void)? = nil
    
    init(
        bookId: String,
        initialPage: Int? = nil,
        onLoadStart: (() -> Void)? = nil,
        onLoadFinish: (() -> Void)? = nil,
        onLoadError: ((String) -> Void)? = nil
    ) {
        self.bookId = bookId
        self.initialPage = initialPage
        self.onLoadStart = onLoadStart
        self.onLoadFinish = onLoadFinish
        self.onLoadError = onLoadError
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.backgroundColor = .white
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let targetKey = "\(bookId)-\(initialPage ?? -1)"
        if context.coordinator.lastLoadedKey != targetKey {
            context.coordinator.lastLoadedKey = targetKey
            onLoadStart?()
            loadBook(in: webView)
        }
    }
    
    private func loadBook(in webView: WKWebView) {
        // Create HTML that loads the Google Books embed
        let htmlString = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <script type="text/javascript" src="https://www.google.com/books/jsapi.js"></script>
            <script type="text/javascript">
              google.books.load();
              
              function initialize() {
                var viewer = new google.books.DefaultViewer(document.getElementById('viewerCanvas'));
                viewer.load('\(bookId)'\(initialPage != nil ? ", { initialPage: \(initialPage!) }" : ""));
              }
              
              google.books.setOnLoadCallback(initialize);
            </script>
            <style>
              body { margin: 0; padding: 0; }
              #viewerCanvas { width: 100%; height: 100vh; }
            </style>
        </head>
        <body>
            <div id="viewerCanvas"></div>
        </body>
        </html>
        """
        
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: GoogleBooksWebView
        var lastLoadedKey: String?
        
        init(_ parent: GoogleBooksWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("Failed to start loading book: \(error.localizedDescription)")
            parent.onLoadError?(error.localizedDescription)
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("Failed to load book: \(error.localizedDescription)")
            parent.onLoadError?(error.localizedDescription)
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("Book viewer loaded successfully")
            parent.onLoadFinish?()
        }
    }
}
