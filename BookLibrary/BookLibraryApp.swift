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
    init() {
            FirebaseApp.configure()
            print("Configured Firebase")
        }
    var body: some Scene {
        WindowGroup {
            if viewModel.isAuthenticated {
                HomeView(viewModel: viewModel)
            } else {
                LoginView(viewModel: viewModel)
            }
        }
    }
}
