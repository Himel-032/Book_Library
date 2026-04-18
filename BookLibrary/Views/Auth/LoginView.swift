//
//  LoginView.swift
//  BookLibrary
//
//  Created by macos on 24/2/26.
//


//import SwiftUI

//struct LoginView: View {
//    
//    @StateObject var viewModel = AuthViewModel()
//    
//    @State private var email = ""
//    @State private var password = ""
//    @State private var showPassword = false
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                
//                Spacer()
//                
//                // Header
//                VStack(spacing: 8) {
//                    Image("book") // Your image asset name
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 100, height: 100)
//                        .clipShape(Circle())
//                        .shadow(radius: 5)
//                    
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
//                    
//                    TextField("Email Address", text: $email)
//                        .padding()
//                        .background(Color(.systemGray6))
//                        .cornerRadius(10)
//                        .autocapitalization(.none)
//                        .keyboardType(.emailAddress)
//                    
//                    // Password Field with Eye Icon
//                    HStack {
//                        if showPassword {
//                            TextField("Password", text: $password)
//                        } else {
//                            SecureField("Password", text: $password)
//                        }
//                        
//                        Button(action: {
//                            showPassword.toggle()
//                        }) {
//                            Image(systemName: showPassword ? "eye.slash" : "eye")
//                                .foregroundColor(.gray)
//                        }
//                    }
//                    .padding()
//                    .background(Color(.systemGray6))
//                    .cornerRadius(10)
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
//                    NavigationLink("Create Account") {
//                        SignupView(viewModel: viewModel)
//                    }
//                    
//                    Spacer()
//                    
//                    NavigationLink("Forgot Password?") {
//                        ResetPasswordView(viewModel: viewModel)
//                    }
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
//                Spacer()
//            }
//            .padding()
//            .navigationBarHidden(true)
//            
//            // Navigation to Home on success
//            .navigationDestination(isPresented: $viewModel.isAuthenticated) {
//                HomeView(viewModel: viewModel)  // ✅ Pass the viewModel
//            }
//        }
//    }
//}

//
//
//import SwiftUI
//
//// MARK: - Animated Floating Particle
//struct FloatingParticle: View {
//    let size: CGFloat
//    let color: Color
//    @State private var offsetY: CGFloat = 0
//    @State private var opacity: Double = 0
//    let startX: CGFloat
//    let startY: CGFloat
//    let duration: Double
//
//    var body: some View {
//        Circle()
//            .fill(color)
//            .frame(width: size, height: size)
//            .position(x: startX, y: startY + offsetY)
//            .opacity(opacity)
//            .onAppear {
//                withAnimation(
//                    .easeInOut(duration: duration)
//                    .repeatForever(autoreverses: true)
//                ) {
//                    offsetY = -30
//                    opacity = 0.6
//                }
//            }
//    }
//}
//
//// MARK: - Custom Text Field Style
//struct LuxuryTextFieldStyle: ViewModifier {
//    var isFocused: Bool
//
//    func body(content: Content) -> some View {
//        content
//            .padding(.horizontal, 18)
//            .padding(.vertical, 16)
//            .background(
//                RoundedRectangle(cornerRadius: 14)
//                    .fill(Color.white.opacity(0.06))
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 14)
//                            .stroke(
//                                isFocused
//                                    ? Color(red: 0.85, green: 0.72, blue: 0.50)
//                                    : Color.white.opacity(0.12),
//                                lineWidth: isFocused ? 1.5 : 1
//                            )
//                    )
//            )
//            .foregroundColor(.white)
//            .font(.system(size: 16, weight: .regular, design: .serif))
//    }
//}
//
//// MARK: - Login View
//struct LoginView: View {
//
//    @StateObject var viewModel = AuthViewModel()
//
//    @State private var email = ""
//    @State private var password = ""
//    @State private var showPassword = false
//
//    @FocusState private var focusedField: Field?
//    enum Field { case email, password }
//
//    // Animation states
//    @State private var logoScale: CGFloat = 0.6
//    @State private var logoOpacity: Double = 0
//    @State private var titleOffset: CGFloat = 30
//    @State private var titleOpacity: Double = 0
//    @State private var cardOffset: CGFloat = 40
//    @State private var cardOpacity: Double = 0
//    @State private var buttonScale: CGFloat = 0.9
//    @State private var buttonOpacity: Double = 0
//    @State private var isLoggingIn = false
//
//    // Gold accent color
//    let gold = Color(red: 0.85, green: 0.72, blue: 0.50)
//    let darkBg = Color(red: 0.07, green: 0.07, blue: 0.10)
//    let cardBg = Color(red: 0.11, green: 0.11, blue: 0.15)
//
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                // ── Background ──
//                darkBg.ignoresSafeArea()
//
//                // Subtle ambient glows
//                ZStack {
//                    Circle()
//                        .fill(
//                            RadialGradient(
//                                colors: [gold.opacity(0.18), .clear],
//                                center: .center,
//                                startRadius: 0,
//                                endRadius: 220
//                            )
//                        )
//                        .frame(width: 440, height: 440)
//                        .offset(x: -140, y: -280)
//                        .blur(radius: 30)
//
//                    Circle()
//                        .fill(
//                            RadialGradient(
//                                colors: [Color(red: 0.3, green: 0.2, blue: 0.6).opacity(0.22), .clear],
//                                center: .center,
//                                startRadius: 0,
//                                endRadius: 200
//                            )
//                        )
//                        .frame(width: 380, height: 380)
//                        .offset(x: 160, y: 300)
//                        .blur(radius: 40)
//                }
//                .ignoresSafeArea()
//
//                // Floating particles
//                GeometryReader { geo in
//                    FloatingParticle(size: 4, color: gold.opacity(0.5), startX: geo.size.width * 0.15, startY: geo.size.height * 0.25, duration: 3.5)
//                    FloatingParticle(size: 3, color: gold.opacity(0.35), startX: geo.size.width * 0.8,  startY: geo.size.height * 0.15, duration: 4.2)
//                    FloatingParticle(size: 5, color: gold.opacity(0.25), startX: geo.size.width * 0.6,  startY: geo.size.height * 0.72, duration: 3.8)
//                    FloatingParticle(size: 2, color: gold.opacity(0.4),  startX: geo.size.width * 0.9,  startY: geo.size.height * 0.55, duration: 5.0)
//                    FloatingParticle(size: 3, color: Color.white.opacity(0.2), startX: geo.size.width * 0.3, startY: geo.size.height * 0.85, duration: 4.5)
//                }
//                .ignoresSafeArea()
//
//                // ── Content ──
//                ScrollView(showsIndicators: false) {
//                    VStack(spacing: 0) {
//                        Spacer().frame(height: 60)
//
//                        // ── Logo / Icon ──
//                        ZStack {
//                            Circle()
//                                .fill(
//                                    LinearGradient(
//                                        colors: [gold.opacity(0.25), gold.opacity(0.05)],
//                                        startPoint: .topLeading,
//                                        endPoint: .bottomTrailing
//                                    )
//                                )
//                                .frame(width: 110, height: 110)
//
//                            Circle()
//                                .stroke(gold.opacity(0.4), lineWidth: 1)
//                                .frame(width: 110, height: 110)
//
//                            Image(systemName: "books.vertical.fill")
//                                .font(.system(size: 44))
//                                .foregroundStyle(
//                                    LinearGradient(
//                                        colors: [gold, Color(red: 1, green: 0.9, blue: 0.65)],
//                                        startPoint: .topLeading,
//                                        endPoint: .bottomTrailing
//                                    )
//                                )
//                        }
//                        .scaleEffect(logoScale)
//                        .opacity(logoOpacity)
//
//                        Spacer().frame(height: 28)
//
//                        // ── Title ──
//                        VStack(spacing: 8) {
//                            Text("Welcome Back")
//                                .font(.system(size: 32, weight: .light, design: .serif))
//                                .foregroundColor(.white)
//                                .tracking(1)
//
//                            Text("Sign in to your library")
//                                .font(.system(size: 14, weight: .regular, design: .rounded))
//                                .foregroundColor(Color.white.opacity(0.45))
//                                .tracking(0.5)
//                        }
//                        .offset(y: titleOffset)
//                        .opacity(titleOpacity)
//
//                        Spacer().frame(height: 44)
//
//                        // ── Card ──
//                        VStack(spacing: 18) {
//
//                            // Divider line with label
//                            HStack {
//                                Rectangle()
//                                    .fill(Color.white.opacity(0.1))
//                                    .frame(height: 1)
//                                Text("credentials")
//                                    .font(.system(size: 11, weight: .medium, design: .rounded))
//                                    .foregroundColor(Color.white.opacity(0.25))
//                                    .padding(.horizontal, 10)
//                                    .tracking(2)
//                                Rectangle()
//                                    .fill(Color.white.opacity(0.1))
//                                    .frame(height: 1)
//                            }
//                            .padding(.bottom, 4)
//
//                            // Email Field
//                            VStack(alignment: .leading, spacing: 6) {
//                                Text("EMAIL")
//                                    .font(.system(size: 10, weight: .semibold, design: .rounded))
//                                    .foregroundColor(gold.opacity(0.8))
//                                    .tracking(2)
//
//                                HStack(spacing: 12) {
//                                    Image(systemName: "envelope")
//                                        .font(.system(size: 15))
//                                        .foregroundColor(focusedField == .email ? gold : Color.white.opacity(0.35))
//                                        .frame(width: 20)
//                                        .animation(.easeInOut(duration: 0.2), value: focusedField)
//
//                                    TextField("", text: $email, prompt:
//                                        Text("your@email.com")
//                                            .foregroundColor(.white.opacity(0.25))
//                                    )
//                                    .focused($focusedField, equals: .email)
//                                    .autocapitalization(.none)
//                                    .keyboardType(.emailAddress)
//                                    .foregroundColor(.white)
//                                    .font(.system(size: 16, weight: .light, design: .serif))
//                                }
//                                .modifier(LuxuryTextFieldStyle(isFocused: focusedField == .email))
//                            }
//
//                            // Password Field
//                            VStack(alignment: .leading, spacing: 6) {
//                                Text("PASSWORD")
//                                    .font(.system(size: 10, weight: .semibold, design: .rounded))
//                                    .foregroundColor(gold.opacity(0.8))
//                                    .tracking(2)
//
//                                HStack(spacing: 12) {
//                                    Image(systemName: "lock")
//                                        .font(.system(size: 15))
//                                        .foregroundColor(focusedField == .password ? gold : Color.white.opacity(0.35))
//                                        .frame(width: 20)
//                                        .animation(.easeInOut(duration: 0.2), value: focusedField)
//
//                                    Group {
//                                        if showPassword {
//                                            TextField("", text: $password, prompt:
//                                                Text("••••••••")
//                                                    .foregroundColor(.white.opacity(0.25))
//                                            )
//                                        } else {
//                                            SecureField("", text: $password, prompt:
//                                                Text("••••••••")
//                                                    .foregroundColor(.white.opacity(0.25))
//                                            )
//                                        }
//                                    }
//                                    .focused($focusedField, equals: .password)
//                                    .foregroundColor(.white)
//                                    .font(.system(size: 16, weight: .light, design: .serif))
//
//                                    Button(action: { showPassword.toggle() }) {
//                                        Image(systemName: showPassword ? "eye.slash" : "eye")
//                                            .font(.system(size: 14))
//                                            .foregroundColor(Color.white.opacity(0.35))
//                                    }
//                                }
//                                .modifier(LuxuryTextFieldStyle(isFocused: focusedField == .password))
//                            }
//
//                            // Forgot Password
//                            HStack {
//                                Spacer()
//                                NavigationLink {
//                                    ResetPasswordView(viewModel: viewModel)
//                                } label: {
//                                    Text("Forgot password?")
//                                        .font(.system(size: 13, weight: .regular, design: .rounded))
//                                        .foregroundColor(gold.opacity(0.75))
//                                }
//                            }
//                            .padding(.top, -4)
//
//                            // Error
//                            if let error = viewModel.errorMessage {
//                                HStack(spacing: 8) {
//                                    Image(systemName: "exclamationmark.circle")
//                                        .font(.system(size: 13))
//                                    Text(error)
//                                        .font(.system(size: 13))
//                                }
//                                .foregroundColor(Color(red: 1.0, green: 0.45, blue: 0.45))
//                                .padding(.top, 4)
//                            }
//
//                            Spacer().frame(height: 8)
//
//                            // ── Login Button ──
//                            Button(action: handleLogin) {
//                                ZStack {
//                                    RoundedRectangle(cornerRadius: 16)
//                                        .fill(
//                                            LinearGradient(
//                                                colors: [
//                                                    Color(red: 0.85, green: 0.72, blue: 0.50),
//                                                    Color(red: 0.70, green: 0.55, blue: 0.30)
//                                                ],
//                                                startPoint: .topLeading,
//                                                endPoint: .bottomTrailing
//                                            )
//                                        )
//                                        .frame(height: 56)
//                                        .shadow(color: gold.opacity(0.35), radius: 16, y: 6)
//
//                                    if isLoggingIn {
//                                        ProgressView()
//                                            .tint(Color(red: 0.15, green: 0.12, blue: 0.07))
//                                    } else {
//                                        HStack(spacing: 10) {
//                                            Text("Sign In")
//                                                .font(.system(size: 17, weight: .semibold, design: .rounded))
//                                                .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.07))
//                                                .tracking(0.5)
//                                            Image(systemName: "arrow.right")
//                                                .font(.system(size: 14, weight: .semibold))
//                                                .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.07))
//                                        }
//                                    }
//                                }
//                            }
//                            .scaleEffect(buttonScale)
//                            .opacity(buttonOpacity)
//                        }
//                        .padding(28)
//                        .background(
//                            RoundedRectangle(cornerRadius: 28)
//                                .fill(cardBg)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 28)
//                                        .stroke(Color.white.opacity(0.07), lineWidth: 1)
//                                )
//                                .shadow(color: Color.black.opacity(0.4), radius: 30, y: 10)
//                        )
//                        .padding(.horizontal, 24)
//                        .offset(y: cardOffset)
//                        .opacity(cardOpacity)
//
//                        Spacer().frame(height: 36)
//
//                        // ── Sign Up ──
//                        HStack(spacing: 6) {
//                            Text("New to BookLibrary?")
//                                .font(.system(size: 14, weight: .light, design: .rounded))
//                                .foregroundColor(Color.white.opacity(0.4))
//
//                            NavigationLink {
//                                SignupView(viewModel: viewModel)
//                            } label: {
//                                Text("Create account")
//                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
//                                    .foregroundColor(gold)
//                            }
//                        }
//                        .opacity(buttonOpacity)
//
//                        Spacer().frame(height: 48)
//                    }
//                }
//            }
//            .navigationBarHidden(true)
//            .navigationDestination(isPresented: $viewModel.isAuthenticated) {
//                HomeView(viewModel: viewModel)
//            }
//            .onAppear { runEntrance() }
//        }
//    }
//
//    // MARK: - Actions
//    private func handleLogin() {
//        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
//            isLoggingIn = true
//        }
//        viewModel.login(email: email, password: password)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            isLoggingIn = false
//        }
//    }
//
//    // MARK: - Entrance Animation
//    private func runEntrance() {
//        withAnimation(.spring(response: 0.7, dampingFraction: 0.65).delay(0.1)) {
//            logoScale = 1.0
//            logoOpacity = 1.0
//        }
//        withAnimation(.easeOut(duration: 0.6).delay(0.35)) {
//            titleOffset = 0
//            titleOpacity = 1
//        }
//        withAnimation(.spring(response: 0.75, dampingFraction: 0.7).delay(0.5)) {
//            cardOffset = 0
//            cardOpacity = 1
//        }
//        withAnimation(.easeOut(duration: 0.5).delay(0.75)) {
//            buttonScale = 1.0
//            buttonOpacity = 1.0
//        }
//    }
//}


import SwiftUI

struct LoginView: View {

    @ObservedObject var viewModel: AuthViewModel
    @EnvironmentObject private var themeManager: ThemeManager

    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false

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
        NavigationStack {
            ZStack {
                pageBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    header

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 16) {
                            authCard

                            if let error = viewModel.errorMessage, !error.isEmpty {
                                errorBanner(error)
                            }

                            authLinks
                        }
                        .padding(.horizontal, 18)
                        .padding(.top, 14)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }

    private var header: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(accent.opacity(isDarkMode ? 0.25 : 0.13))
                    .frame(width: 96, height: 96)

                Image("book")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 66, height: 66)
                    .clipShape(Circle())
            }

            Text("Welcome Back")
                .font(.system(size: 30, weight: .semibold, design: .serif))
                .foregroundColor(primaryText)

            Text("Sign in to continue your reading journey")
                .font(.system(size: 13, design: .rounded))
                .foregroundColor(secondaryText)
        }
        .padding(.top, 30)
        .padding(.bottom, 10)
    }

    private var authCard: some View {
        VStack(spacing: 12) {
            field(icon: "envelope", placeholder: "Email Address", text: $email, isSecure: false)

            field(icon: "lock", placeholder: "Password", text: $password, isSecure: !showPassword, trailing: {
                Button {
                    showPassword.toggle()
                } label: {
                    Image(systemName: showPassword ? "eye.slash" : "eye")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(secondaryText)
                }
            })

            Button {
                viewModel.login(email: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password)
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 14, weight: .semibold))
                    Text("Login")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                }
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

    private var authLinks: some View {
        VStack(spacing: 10) {
            NavigationLink {
                SignupView(viewModel: viewModel)
            } label: {
                Text("Create a new account")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(accent)
            }

            NavigationLink {
                ResetPasswordView(viewModel: viewModel)
            } label: {
                Text("Forgot password?")
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(secondaryText)
            }
        }
    }

    private func errorBanner(_ message: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.circle.fill")
                .font(.system(size: 13))
            Text(message)
                .font(.system(size: 12, design: .rounded))
                .lineLimit(3)
            Spacer()
        }
        .foregroundColor(Color(red: 0.82, green: 0.35, blue: 0.35))
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color(red: 0.82, green: 0.35, blue: 0.35).opacity(isDarkMode ? 0.18 : 0.10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(red: 0.82, green: 0.35, blue: 0.35).opacity(0.35), lineWidth: 1)
        )
        .cornerRadius(10)
    }

    private func field<Trailing: View>(
        icon: String,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool,
        @ViewBuilder trailing: () -> Trailing = { EmptyView() }
    ) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(secondaryText)
                .frame(width: 18)

            if isSecure {
                SecureField(placeholder, text: text)
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(primaryText)
            } else {
                TextField(placeholder, text: text)
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(primaryText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
            }

            trailing()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(fieldBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(borderColor, lineWidth: 1)
        )
        .cornerRadius(10)
    }
}
