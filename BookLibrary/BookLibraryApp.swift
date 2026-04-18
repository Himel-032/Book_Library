//
//  BookLibraryApp.swift
//  BookLibrary
//
//  Created by Himel on 23/2/26.
//

import SwiftUI
import Firebase

@main
struct BookLibraryApp: App {
    @StateObject var viewModel = AuthViewModel()
        @StateObject var themeManager = ThemeManager()
        
        init() {
            FirebaseApp.configure()
            print("Configured Firebase")
        }
        
        var body: some Scene {
            WindowGroup {
                if viewModel.isAuthenticated {
                    HomeView(viewModel: viewModel)
                        .environmentObject(themeManager)
                } else {
                    LoginView(viewModel: viewModel)
                        .environmentObject(themeManager)
                }
            }
        }
}
