//
//  ResetPasswordView.swift
//  BookLibrary
//
//  Created by macos on 24/2/26.
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
//            VStack {
//                
//                Spacer()
//                
//                // Logo / Icon (Professional Touch)
//                Image("book") // <-- Your image asset name
//                       .resizable()
//                       .scaledToFit()
//                       .frame(width: 100, height: 100)
//                       .clipShape(Circle())
//                       .shadow(radius: 5)
//                
//                // Header (Consistent Style)
//                VStack(spacing: 8) {
//                    Text("Reset Password")
//                        .font(.title)
//                        .fontWeight(.bold)
//                    
//                    Text("Enter your email and we will send a reset link")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                }
//                
//                Spacer().frame(height: 30)
//                
//                // Input Card
//                VStack(spacing: 16) {
//                    
//                    TextField("Email Address", text: $email)
//                        .padding()
//                        .background(Color(.systemGray6))
//                        .cornerRadius(10)
//                        .autocapitalization(.none)
//                        .keyboardType(.emailAddress)
//                }
//                .padding()
//                .background(
//                    RoundedRectangle(cornerRadius: 16)
//                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
//                )
//                .padding(.horizontal)
//                
//                // Reset Button
//                Button(action: resetUserPassword) {
//                    Text("Send Reset Link")
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
//                // Back to Login
//                Button("Back to Login") {
//                    dismiss()
//                }
//                .font(.footnote)
//                .padding(.top, 6)
//                
//                Spacer()
//            }
//            .padding()
//            
//            // Toast Notification (Top)
//            if showToast {
//                VStack {
//                    HStack {
//                        Spacer()
//                        Text(toastMessage)
//                            .padding()
//                            .background(Color.green.opacity(0.9))
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                    .padding()
//                    
//                    Spacer()
//                }
//                .transition(.move(edge: .top).combined(with: .opacity))
//            }
//        }
//        .animation(.easeInOut, value: showToast)
//    }
//    
//    // MARK: - Reset Password
//    private func resetUserPassword() {
//        guard !email.isEmpty else {
//            showToastMessage("Please enter your email")
//            return
//        }
//        
//        viewModel.resetPassword(email: email)
//        
//        showToastMessage("Reset link sent to your email")
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            dismiss()
//        }
//    }
//    
//    // MARK: - Toast Helper
//    private func showToastMessage(_ message: String) {
//        toastMessage = message
//        showToast = true
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            showToast = false
//        }
//    }
//}

//
//  ResetPasswordView.swift
//  BookLibrary
//
//  Redesigned with luxury dark aesthetic — matching LoginView
//
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
//    // Toast state (unchanged)
//    @State private var showToast = false
//    @State private var toastMessage = ""
//    @State private var toastIsSuccess = true
//
//    // Focus
//    @FocusState private var emailFocused: Bool
//
//    // Entrance animations
//    @State private var logoScale: CGFloat = 0.6
//    @State private var logoOpacity: Double = 0
//    @State private var titleOffset: CGFloat = 24
//    @State private var titleOpacity: Double = 0
//    @State private var cardOffset: CGFloat = 36
//    @State private var cardOpacity: Double = 0
//    @State private var buttonOpacity: Double = 0
//    @State private var isSending = false
//
//    // Colors
//    let gold = Color(red: 0.85, green: 0.72, blue: 0.50)
//    let darkBg = Color(red: 0.07, green: 0.07, blue: 0.10)
//    let cardBg = Color(red: 0.11, green: 0.11, blue: 0.15)
//
//    var body: some View {
//        ZStack {
//            // ── Background ──
//            darkBg.ignoresSafeArea()
//
//            // Ambient glow
//            ZStack {
//                Circle()
//                    .fill(
//                        RadialGradient(
//                            colors: [gold.opacity(0.14), .clear],
//                            center: .center,
//                            startRadius: 0,
//                            endRadius: 200
//                        )
//                    )
//                    .frame(width: 380, height: 380)
//                    .offset(x: -120, y: -240)
//                    .blur(radius: 30)
//
//                Circle()
//                    .fill(
//                        RadialGradient(
//                            colors: [Color(red: 0.3, green: 0.2, blue: 0.6).opacity(0.18), .clear],
//                            center: .center,
//                            startRadius: 0,
//                            endRadius: 180
//                        )
//                    )
//                    .frame(width: 340, height: 340)
//                    .offset(x: 150, y: 280)
//                    .blur(radius: 40)
//            }
//            .ignoresSafeArea()
//
//            // Particles
//            GeometryReader { geo in
//                FloatingParticle(size: 4, color: gold.opacity(0.4),  startX: geo.size.width * 0.82, startY: geo.size.height * 0.22, duration: 3.8)
//                FloatingParticle(size: 3, color: gold.opacity(0.28), startX: geo.size.width * 0.12, startY: geo.size.height * 0.45, duration: 4.5)
//                FloatingParticle(size: 2, color: Color.white.opacity(0.18), startX: geo.size.width * 0.5, startY: geo.size.height * 0.78, duration: 5.2)
//                FloatingParticle(size: 3, color: gold.opacity(0.22), startX: geo.size.width * 0.7, startY: geo.size.height * 0.62, duration: 4.1)
//            }
//            .ignoresSafeArea()
//
//            // ── Main content ──
//            VStack(spacing: 0) {
//                Spacer()
//
//                // Logo
//                ZStack {
//                    Circle()
//                        .fill(
//                            LinearGradient(
//                                colors: [gold.opacity(0.20), gold.opacity(0.04)],
//                                startPoint: .topLeading,
//                                endPoint: .bottomTrailing
//                            )
//                        )
//                        .frame(width: 100, height: 100)
//
//                    Circle()
//                        .stroke(gold.opacity(0.32), lineWidth: 1)
//                        .frame(width: 100, height: 100)
//
//                    Image(systemName: "key.horizontal")
//                        .font(.system(size: 38))
//                        .foregroundStyle(
//                            LinearGradient(
//                                colors: [gold, Color(red: 1, green: 0.9, blue: 0.65)],
//                                startPoint: .topLeading,
//                                endPoint: .bottomTrailing
//                            )
//                        )
//                }
//                .scaleEffect(logoScale)
//                .opacity(logoOpacity)
//
//                Spacer().frame(height: 24)
//
//                // Title
//                VStack(spacing: 7) {
//                    Text("Reset Password")
//                        .font(.system(size: 30, weight: .light, design: .serif))
//                        .foregroundColor(.white)
//                        .tracking(1)
//
//                    Text("We'll send a reset link to your email")
//                        .font(.system(size: 13, weight: .regular, design: .rounded))
//                        .foregroundColor(Color.white.opacity(0.40))
//                        .multilineTextAlignment(.center)
//                        .tracking(0.3)
//                }
//                .offset(y: titleOffset)
//                .opacity(titleOpacity)
//
//                Spacer().frame(height: 40)
//
//                // ── Card ──
//                VStack(spacing: 18) {
//
//                    // Divider
//                    HStack {
//                        Rectangle()
//                            .fill(Color.white.opacity(0.09))
//                            .frame(height: 1)
//                        Text("enter email")
//                            .font(.system(size: 10, weight: .medium, design: .rounded))
//                            .foregroundColor(Color.white.opacity(0.22))
//                            .padding(.horizontal, 10)
//                            .tracking(2)
//                        Rectangle()
//                            .fill(Color.white.opacity(0.09))
//                            .frame(height: 1)
//                    }
//
//                    // Email field
//                    VStack(alignment: .leading, spacing: 6) {
//                        Text("EMAIL ADDRESS")
//                            .font(.system(size: 10, weight: .semibold, design: .rounded))
//                            .foregroundColor(gold.opacity(0.8))
//                            .tracking(2)
//
//                        HStack(spacing: 12) {
//                            Image(systemName: "envelope")
//                                .font(.system(size: 15))
//                                .foregroundColor(emailFocused ? gold : Color.white.opacity(0.35))
//                                .frame(width: 20)
//                                .animation(.easeInOut(duration: 0.2), value: emailFocused)
//
//                            TextField("", text: $email, prompt:
//                                Text("your@email.com").foregroundColor(.white.opacity(0.25))
//                            )
//                            .focused($emailFocused)
//                            .autocapitalization(.none)
//                            .keyboardType(.emailAddress)
//                            .foregroundColor(.white)
//                            .font(.system(size: 16, weight: .light, design: .serif))
//                        }
//                        .padding(.horizontal, 18)
//                        .padding(.vertical, 16)
//                        .background(
//                            RoundedRectangle(cornerRadius: 14)
//                                .fill(Color.white.opacity(0.06))
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 14)
//                                        .stroke(
//                                            emailFocused ? gold : Color.white.opacity(0.12),
//                                            lineWidth: emailFocused ? 1.5 : 1
//                                        )
//                                )
//                        )
//                    }
//
//                    // Info hint
//                    HStack(spacing: 8) {
//                        Image(systemName: "info.circle")
//                            .font(.system(size: 12))
//                            .foregroundColor(gold.opacity(0.55))
//                        Text("Check your spam folder if you don't see the email")
//                            .font(.system(size: 12, weight: .light, design: .rounded))
//                            .foregroundColor(Color.white.opacity(0.3))
//                    }
//                    .padding(.top, -4)
//
//                    Spacer().frame(height: 4)
//
//                    // Send Button
//                    Button(action: resetUserPassword) {
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 16)
//                                .fill(
//                                    LinearGradient(
//                                        colors: [
//                                            Color(red: 0.85, green: 0.72, blue: 0.50),
//                                            Color(red: 0.70, green: 0.55, blue: 0.30)
//                                        ],
//                                        startPoint: .topLeading,
//                                        endPoint: .bottomTrailing
//                                    )
//                                )
//                                .frame(height: 56)
//                                .shadow(color: gold.opacity(0.3), radius: 14, y: 5)
//
//                            if isSending {
//                                ProgressView()
//                                    .tint(Color(red: 0.15, green: 0.12, blue: 0.07))
//                            } else {
//                                HStack(spacing: 10) {
//                                    Image(systemName: "paperplane")
//                                        .font(.system(size: 15, weight: .semibold))
//                                        .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.07))
//                                    Text("Send Reset Link")
//                                        .font(.system(size: 17, weight: .semibold, design: .rounded))
//                                        .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.07))
//                                        .tracking(0.5)
//                                }
//                            }
//                        }
//                    }
//                    .opacity(buttonOpacity)
//                }
//                .padding(26)
//                .background(
//                    RoundedRectangle(cornerRadius: 28)
//                        .fill(cardBg)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 28)
//                                .stroke(Color.white.opacity(0.07), lineWidth: 1)
//                        )
//                        .shadow(color: Color.black.opacity(0.4), radius: 28, y: 10)
//                )
//                .padding(.horizontal, 24)
//                .offset(y: cardOffset)
//                .opacity(cardOpacity)
//
//                Spacer().frame(height: 30)
//
//                // Back to Login
//                HStack(spacing: 6) {
//                    Image(systemName: "chevron.left")
//                        .font(.system(size: 12, weight: .semibold))
//                        .foregroundColor(gold.opacity(0.8))
//                    Button(action: { dismiss() }) {
//                        Text("Back to Login")
//                            .font(.system(size: 14, weight: .semibold, design: .rounded))
//                            .foregroundColor(gold)
//                    }
//                }
//                .opacity(buttonOpacity)
//
//                Spacer()
//            }
//
//            // ── Toast ──
//            if showToast {
//                VStack {
//                    HStack(spacing: 10) {
//                        Image(systemName: toastIsSuccess ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
//                            .font(.system(size: 15))
//                            .foregroundColor(toastIsSuccess
//                                ? Color(red: 0.35, green: 0.82, blue: 0.55)
//                                : Color(red: 1.0, green: 0.45, blue: 0.45))
//
//                        Text(toastMessage)
//                            .font(.system(size: 14, weight: .medium, design: .rounded))
//                            .foregroundColor(.white)
//
//                        Spacer()
//                    }
//                    .padding(.horizontal, 18)
//                    .padding(.vertical, 14)
//                    .background(
//                        RoundedRectangle(cornerRadius: 14)
//                            .fill(Color(red: 0.13, green: 0.13, blue: 0.18))
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 14)
//                                    .stroke(
//                                        (toastIsSuccess ? Color(red: 0.35, green: 0.82, blue: 0.55) : Color(red: 1.0, green: 0.45, blue: 0.45)).opacity(0.4),
//                                        lineWidth: 1
//                                    )
//                            )
//                            .shadow(color: Color.black.opacity(0.35), radius: 12, y: 4)
//                    )
//                    .padding(.horizontal, 20)
//                    .padding(.top, 56)
//
//                    Spacer()
//                }
//                .transition(.move(edge: .top).combined(with: .opacity))
//                .zIndex(10)
//            }
//        }
//        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: showToast)
//        .navigationBarHidden(true)
//        .onAppear { runEntrance() }
//    }
//
//    // MARK: - Logic (unchanged)
//    private func resetUserPassword() {
//        guard !email.isEmpty else {
//            showToastMessage("Please enter your email", success: false)
//            return
//        }
//
//        withAnimation { isSending = true }
//        viewModel.resetPassword(email: email)
//
//        showToastMessage("Reset link sent to your email", success: true)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            isSending = false
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            dismiss()
//        }
//    }
//
//    private func showToastMessage(_ message: String, success: Bool = true) {
//        toastMessage = message
//        toastIsSuccess = success
//        withAnimation { showToast = true }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//            withAnimation { showToast = false }
//        }
//    }
//
//    // MARK: - Entrance Animation
//    private func runEntrance() {
//        withAnimation(.spring(response: 0.65, dampingFraction: 0.65).delay(0.1)) {
//            logoScale = 1.0
//            logoOpacity = 1.0
//        }
//        withAnimation(.easeOut(duration: 0.55).delay(0.3)) {
//            titleOffset = 0
//            titleOpacity = 1
//        }
//        withAnimation(.spring(response: 0.7, dampingFraction: 0.7).delay(0.45)) {
//            cardOffset = 0
//            cardOpacity = 1
//        }
//        withAnimation(.easeOut(duration: 0.5).delay(0.65)) {
//            buttonOpacity = 1.0
//        }
//    }
//}


import SwiftUI

struct ResetPasswordView: View {

    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AuthViewModel
    @EnvironmentObject private var themeManager: ThemeManager

    @State private var email = ""
    @State private var showToast = false
    @State private var toastMessage = ""

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
        isDarkMode ? Color.white.opacity(0.12) : Color(red: 0.86, green: 0.81, blue: 0.73)
    }

    private var primaryText: Color {
        isDarkMode ? .white : Color(red: 0.16, green: 0.14, blue: 0.13)
    }

    private var secondaryText: Color {
        isDarkMode ? Color.white.opacity(0.66) : Color(red: 0.46, green: 0.42, blue: 0.39)
    }

    private var accent: Color {
        Color(red: 0.18, green: 0.38, blue: 0.26)
    }

    var body: some View {
        ZStack(alignment: .top) {
            pageBackground.ignoresSafeArea()

            VStack(spacing: 14) {
                Spacer().frame(height: 20)

                header
                resetCard

                Button {
                    dismiss()
                } label: {
                    Text("Return to Sign In")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundColor(accent)
                }

                Spacer()
            }
            .padding(.horizontal, 18)

            if showToast {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                    Text(toastMessage)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .lineLimit(2)
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(accent)
                .cornerRadius(12)
                .padding(.horizontal, 18)
                .padding(.top, 12)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(primaryText)
                }
            }
        }
        .animation(.easeInOut, value: showToast)
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text("Reset Password")
                .font(.system(size: 30, weight: .semibold, design: .serif))
                .foregroundColor(primaryText)

            Text("Enter your account email to receive a password reset link")
                .font(.system(size: 13, design: .rounded))
                .foregroundColor(secondaryText)
                .multilineTextAlignment(.center)
        }
    }

    private var resetCard: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "envelope")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(secondaryText)
                    .frame(width: 18)

                TextField("Email Address", text: $email)
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(primaryText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .keyboardType(.emailAddress)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(fieldBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 1)
            )
            .cornerRadius(10)

            Button {
                resetUserPassword()
            } label: {
                Text("Send Reset Link")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(accent)
                    .cornerRadius(12)
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(borderColor, lineWidth: 1)
        )
        .cornerRadius(16)
    }

    private func resetUserPassword() {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showToastMessage("Please enter your email")
            return
        }

        viewModel.resetPassword(email: email)
        showToastMessage("Reset link sent. Please check your email.")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            dismiss()
        }
    }

    private func showToastMessage(_ message: String) {
        toastMessage = message
        showToast = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            showToast = false
        }
    }
}
