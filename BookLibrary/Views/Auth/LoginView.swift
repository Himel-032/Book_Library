//
//  LoginView.swift
//  BookLibrary
//
//  Created by Himel on 23/2/26.
//

//import SwiftUI
//
//struct LoginView: View {
//    
//    @StateObject var viewModel = AuthViewModel()
//    
//    @State private var email = ""
//    @State private var password = ""
//    
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 20) {
//                
//                Text("Login")
//                    .font(.largeTitle)
//                
//                TextField("Email", text: $email)
//                    .textFieldStyle(.roundedBorder)
//                    .autocapitalization(.none)
//                
//                SecureField("Password", text: $password)
//                    .textFieldStyle(.roundedBorder)
//                
//                Button("Login") {
//                    viewModel.login(email: email, password: password)
//                }
//                .buttonStyle(.borderedProminent)
//                
//                NavigationLink("Signup", destination: SignupView(viewModel: viewModel))
//                
//                NavigationLink("Forgot Password?", destination: ResetPasswordView(viewModel: viewModel))
//                
//                if let error = viewModel.errorMessage {
//                    Text(error)
//                        .foregroundColor(.red)
//                }
//                
//                NavigationLink(
//                    destination: HomeView(),
//                    isActive: $viewModel.isAuthenticated
//                ) {
//                    EmptyView()
//                }
//            }
//            .padding()
//        }
//    }
//}
//import SwiftUI
//
//struct LoginView: View {
//    
//    @StateObject var viewModel = AuthViewModel()
//    
//    @State private var email = ""
//    @State private var password = ""
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                
//                Spacer()
//                
//                // Header
//                VStack(spacing: 8) {
//                    Image("book") // <-- Your image asset name
//                           .resizable()
//                           .scaledToFit()
//                           .frame(width: 100, height: 100)
//                           .clipShape(Circle())
//                           .shadow(radius: 5)
//                    Text("Welcome Back")
//                        .font(.title)
//                        .fontWeight(.bold)
//                    
//                    Text("Sign in to continue to your library")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                }
//                
//                Spacer().frame(height: 40)
//                
//                // Input Card
//                VStack(spacing: 16) {
//                    TextField("Email Address", text: $email)
//                        .padding()
//                        .background(Color(.systemGray6))
//                        .cornerRadius(10)
//                        .autocapitalization(.none)
//                        .keyboardType(.emailAddress)
//                    
//                    SecureField("Password", text: $password)
//                        .padding()
//                        .background(Color(.systemGray6))
//                        .cornerRadius(10)
//                }
//                .padding()
//                .background(
//                    RoundedRectangle(cornerRadius: 16)
//                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
//                )
//                .padding(.horizontal)
//                
//                // Login Button
//                Button(action: {
//                    viewModel.login(email: email, password: password)
//                }) {
//                    Text("Login")
//                        .fontWeight(.semibold)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(12)
//                }
//                .padding(.horizontal)
//                .padding(.top, 10)
//                
//                // Links
//                HStack {
//                    NavigationLink("Create Account", destination: SignupView(viewModel: viewModel))
//                    
//                    Spacer()
//                    
//                    NavigationLink("Forgot Password?", destination: ResetPasswordView(viewModel: viewModel))
//                }
//                .font(.footnote)
//                .padding(.horizontal)
//                .padding(.top, 6)
//                
//                // Error Message
//                if let error = viewModel.errorMessage {
//                    Text(error)
//                        .foregroundColor(.red)
//                        .font(.footnote)
//                        .padding(.top, 10)
//                }
//                
//                // Navigation to Home on success
//                NavigationLink(
//                    destination: HomeView(),
//                    isActive: $viewModel.isAuthenticated
//                ) {
//                    EmptyView()
//                }
//                
//                Spacer()
//            }
//            .padding()
//            .navigationBarHidden(true)
//        }
//    }
//}


import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = AuthViewModel()
    
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                
                // Header
                VStack(spacing: 8) {
                    Image("book") // Your image asset name
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                    
                    Text("Welcome Back")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Sign in to continue to your library")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer().frame(height: 40)
                
                // Input Card
                VStack(spacing: 16) {
                    
                    TextField("Email Address", text: $email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    // Password Field with Eye Icon
                    HStack {
                        if showPassword {
                            TextField("Password", text: $password)
                        } else {
                            SecureField("Password", text: $password)
                        }
                        
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .padding(.horizontal)
                
                // Login Button
                Button(action: {
                    viewModel.login(email: email, password: password)
                }) {
                    Text("Login")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                // Links
                HStack {
                    NavigationLink("Create Account") {
                        SignupView(viewModel: viewModel)
                    }
                    
                    Spacer()
                    
                    NavigationLink("Forgot Password?") {
                        ResetPasswordView(viewModel: viewModel)
                    }
                }
                .font(.footnote)
                .padding(.horizontal)
                .padding(.top, 6)
                
                // Error Message
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.top, 10)
                }
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
            
            // Navigation to Home on success
            .navigationDestination(isPresented: $viewModel.isAuthenticated) {
                HomeView()
            }
        }
    }
}
