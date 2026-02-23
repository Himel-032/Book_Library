//
//  ResetPasswordView.swift
//  BookLibrary
//
//  Created by Himel on 23/2/26.
//
//import SwiftUI
//
//struct ResetPasswordView: View {
//    
//    @Environment(\.dismiss) var dismiss
//    @ObservedObject var viewModel: AuthViewModel
//    
//    @State private var email = ""
//    
//    // Toast state
//    @State private var showToast = false
//    @State private var toastMessage = ""
//    
//    var body: some View {
//        ZStack {
//            VStack(spacing: 20) {
//                
//                Text("Reset Password")
//                    .font(.largeTitle)
//                    .bold()
//                
//                TextField("Enter your email", text: $email)
//                    .textFieldStyle(.roundedBorder)
//                    .autocapitalization(.none)
//                
//                Button("Send Reset Link") {
//                    resetUserPassword()
//                }
//                .buttonStyle(.borderedProminent)
//                
//                // Manual back to login button
//                Button("Back to Login") {
//                    dismiss()
//                }
//                .font(.footnote)
//            }
//            .padding()
//            
//            // Toast (top-right)
//            if showToast {
//                VStack {
//                    HStack {
//                        Spacer()
//                        Text(toastMessage)
//                            .padding()
//                            .background(Color.green.opacity(0.9))
//                            .cornerRadius(10)
//                    }
//                    .padding()
//                    
//                    Spacer()
//                }
//                .transition(.move(edge: .top).combined(with: .opacity))
//                .animation(.easeInOut, value: showToast)
//            }
//        }
//    }
//    
//    private func resetUserPassword() {
//        guard !email.isEmpty else {
//            viewModel.errorMessage = "Please enter your email"
//            return
//        }
//        
//        viewModel.resetPassword(email: email)
//        
//        // Toast message
//        toastMessage = "Reset link sent to your email"
//        showToast = true
//        
//        // Auto hide toast
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            showToast = false
//        }
//        
//        // Auto go back to login after success
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            dismiss()
//        }
//    }
//}


import SwiftUI

struct ResetPasswordView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AuthViewModel
    
    @State private var email = ""
    
    // Toast state
    @State private var showToast = false
    @State private var toastMessage = ""
    
    var body: some View {
        ZStack {
            VStack {
                
                Spacer()
                
                // Logo / Icon (Professional Touch)
                Image("book") // <-- Your image asset name
                       .resizable()
                       .scaledToFit()
                       .frame(width: 100, height: 100)
                       .clipShape(Circle())
                       .shadow(radius: 5)
                
                // Header (Consistent Style)
                VStack(spacing: 8) {
                    Text("Reset Password")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Enter your email and we will send a reset link")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer().frame(height: 30)
                
                // Input Card
                VStack(spacing: 16) {
                    
                    TextField("Email Address", text: $email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .padding(.horizontal)
                
                // Reset Button
                Button(action: resetUserPassword) {
                    Text("Send Reset Link")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                // Back to Login
                Button("Back to Login") {
                    dismiss()
                }
                .font(.footnote)
                .padding(.top, 6)
                
                Spacer()
            }
            .padding()
            
            // Toast Notification (Top)
            if showToast {
                VStack {
                    HStack {
                        Spacer()
                        Text(toastMessage)
                            .padding()
                            .background(Color.green.opacity(0.9))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut, value: showToast)
    }
    
    // MARK: - Reset Password
    private func resetUserPassword() {
        guard !email.isEmpty else {
            showToastMessage("Please enter your email")
            return
        }
        
        viewModel.resetPassword(email: email)
        
        showToastMessage("Reset link sent to your email")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            dismiss()
        }
    }
    
    // MARK: - Toast Helper
    private func showToastMessage(_ message: String) {
        toastMessage = message
        showToast = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showToast = false
        }
    }
}
