//
//  SignupView.swift
//  BookLibrary
//
//  Created by macos on 24/2/26.
//



//
//import SwiftUI
//
//struct SignupView: View {
//    
//    @Environment(\.dismiss) var dismiss
//    @ObservedObject var viewModel: AuthViewModel
//    
//    @State private var email = ""
//    @State private var password = ""
//    @State private var confirmPassword = ""
//    @State private var name = ""
//    @State private var country = ""
//    
//    @State private var filteredCountries: [String] = []
//    @State private var showDropdown = false
//    @FocusState private var isCountryFocused: Bool
//    
//    // Password visibility toggles
//    @State private var showPassword = false
//    @State private var showConfirmPassword = false
//    
//    var body: some View {
//        VStack {
//            
//            Spacer()
//            
//            // Header
//            VStack(spacing: 8) {
//                Image("book") // Your image asset name
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 80, height: 100)
//                    .clipShape(Circle())
//                    .shadow(radius: 5)
//                Text("Create Account")
//                    .font(.title)
//                    .fontWeight(.bold)
//                
//                Text("Join the library and explore thousands of books")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//            
//            Spacer().frame(height: 30)
//            
//            // Input Card
//            VStack(spacing: 16) {
//                
//                TextField("Full Name", text: $name)
//                    .padding()
//                    .background(Color(.systemGray6))
//                    .cornerRadius(10)
//                
//                // Country with Dropdown
//                VStack(alignment: .leading) {
//                    
//                    TextField("Country", text: $country)
//                        .padding()
//                        .background(Color(.systemGray6))
//                        .cornerRadius(10)
//                        .focused($isCountryFocused)
//                        .onChange(of: country) { newValue in
//                            filterCountries(query: newValue)
//                        }
//                        .onChange(of: isCountryFocused) { focused in
//                            if focused {
//                                filteredCountries = CountryList.countries
//                                showDropdown = true
//                            } else {
//                                showDropdown = false
//                            }
//                        }
//                    
//                    if showDropdown {
//                        ScrollView {
//                            VStack(alignment: .leading, spacing: 8) {
//                                ForEach(filteredCountries, id: \.self) { item in
//                                    Button(action: {
//                                        country = item
//                                        showDropdown = false
//                                        isCountryFocused = false
//                                    }) {
//                                        Text(item)
//                                            .padding(.vertical, 6)
//                                    }
//                                }
//                            }
//                        }
//                        .frame(maxHeight: 140)
//                        .padding(.horizontal)
//                        .background(Color(.systemGray6))
//                        .cornerRadius(10)
//                    }
//                }
//                
//                TextField("Email Address", text: $email)
//                    .padding()
//                    .background(Color(.systemGray6))
//                    .cornerRadius(10)
//                    .autocapitalization(.none)
//                    .keyboardType(.emailAddress)
//                
//                // Password Field with Eye Icon
//                HStack {
//                    if showPassword {
//                        TextField("Password", text: $password)
//                    } else {
//                        SecureField("Password", text: $password)
//                    }
//                    
//                    Button(action: {
//                        showPassword.toggle()
//                    }) {
//                        Image(systemName: showPassword ? "eye.slash" : "eye")
//                            .foregroundColor(.gray)
//                    }
//                }
//                .padding()
//                .background(Color(.systemGray6))
//                .cornerRadius(10)
//                
//                // Confirm Password Field with Eye Icon
//                HStack {
//                    if showConfirmPassword {
//                        TextField("Confirm Password", text: $confirmPassword)
//                    } else {
//                        SecureField("Confirm Password", text: $confirmPassword)
//                    }
//                    
//                    Button(action: {
//                        showConfirmPassword.toggle()
//                    }) {
//                        Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
//                            .foregroundColor(.gray)
//                    }
//                }
//                .padding()
//                .background(Color(.systemGray6))
//                .cornerRadius(10)
//            }
//            .padding()
//            .background(
//                RoundedRectangle(cornerRadius: 16)
//                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
//            )
//            .padding(.horizontal)
//            
//            // Sign Up Button
//            Button(action: signUpUser) {
//                Text("Sign Up")
//                    .fontWeight(.semibold)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(12)
//            }
//            .padding(.horizontal)
//            .padding(.top, 10)
//            
//            // Error Message
//            if let error = viewModel.errorMessage {
//                Text(error)
//                    .foregroundColor(.red)
//                    .font(.footnote)
//                    .padding(.top, 6)
//            }
//            
//            // Login Redirect
//            Button("Already have an account? Login") {
//                dismiss()
//            }
//            .font(.footnote)
//            .padding(.top, 6)
//            
//            Spacer()
//        }
//        .padding()
//    }
//    
//    // MARK: - Signup Logic
//    private func signUpUser() {
//        guard !email.isEmpty,
//              !password.isEmpty,
//              !name.isEmpty,
//              !country.isEmpty else {
//            viewModel.errorMessage = "Please fill all fields"
//            return
//        }
//        
//        guard password == confirmPassword else {
//            viewModel.errorMessage = "Passwords do not match"
//            return
//        }
//        
//        viewModel.signUp(
//            email: email,
//            password: password,
//            name: name,
//            country: country
//        )
//    }
//    
//    // MARK: - Country Filter
//    private func filterCountries(query: String) {
//        if query.isEmpty {
//            filteredCountries = CountryList.countries
//            showDropdown = true
//        } else {
//            filteredCountries = CountryList.countries.filter {
//                $0.lowercased().contains(query.lowercased())
//            }
//            showDropdown = !filteredCountries.isEmpty
//        }
//    }
//}
//




//
//import SwiftUI
//
//struct SignupView: View {
//
//    @Environment(\.dismiss) var dismiss
//    @ObservedObject var viewModel: AuthViewModel
//
//    // MARK: - State
//    @State private var email = ""
//    @State private var password = ""
//    @State private var confirmPassword = ""
//    @State private var name = ""
//    @State private var country = ""
//
//    @State private var filteredCountries: [String] = []
//    @State private var showDropdown = false
//    @FocusState private var focusedField: Field?
//    @FocusState private var isCountryFocused: Bool
//
//    @State private var showPassword = false
//    @State private var showConfirmPassword = false
//
//    // Entrance animations
//    @State private var logoScale: CGFloat = 0.6
//    @State private var logoOpacity: Double = 0
//    @State private var titleOffset: CGFloat = 24
//    @State private var titleOpacity: Double = 0
//    @State private var cardOffset: CGFloat = 36
//    @State private var cardOpacity: Double = 0
//    @State private var buttonOpacity: Double = 0
//
//    enum Field { case name, email, password, confirmPassword }
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
//            // Ambient glows
//            ZStack {
//                Circle()
//                    .fill(
//                        RadialGradient(
//                            colors: [gold.opacity(0.15), .clear],
//                            center: .center,
//                            startRadius: 0,
//                            endRadius: 220
//                        )
//                    )
//                    .frame(width: 400, height: 400)
//                    .offset(x: 140, y: -260)
//                    .blur(radius: 30)
//
//                Circle()
//                    .fill(
//                        RadialGradient(
//                            colors: [Color(red: 0.3, green: 0.2, blue: 0.6).opacity(0.2), .clear],
//                            center: .center,
//                            startRadius: 0,
//                            endRadius: 200
//                        )
//                    )
//                    .frame(width: 360, height: 360)
//                    .offset(x: -160, y: 320)
//                    .blur(radius: 40)
//            }
//            .ignoresSafeArea()
//
//            // Floating particles
//            GeometryReader { geo in
//                FloatingParticle(size: 4, color: gold.opacity(0.45), startX: geo.size.width * 0.85, startY: geo.size.height * 0.18, duration: 3.6)
//                FloatingParticle(size: 3, color: gold.opacity(0.3),  startX: geo.size.width * 0.1,  startY: geo.size.height * 0.3,  duration: 4.3)
//                FloatingParticle(size: 5, color: gold.opacity(0.2),  startX: geo.size.width * 0.65, startY: geo.size.height * 0.75, duration: 4.0)
//                FloatingParticle(size: 2, color: Color.white.opacity(0.2), startX: geo.size.width * 0.92, startY: geo.size.height * 0.6, duration: 5.1)
//            }
//            .ignoresSafeArea()
//
//            // ── Scrollable content ──
//            ScrollView(showsIndicators: false) {
//                VStack(spacing: 0) {
//                    Spacer().frame(height: 56)
//
//                    // Logo
//                    ZStack {
//                        Circle()
//                            .fill(
//                                LinearGradient(
//                                    colors: [gold.opacity(0.22), gold.opacity(0.04)],
//                                    startPoint: .topLeading,
//                                    endPoint: .bottomTrailing
//                                )
//                            )
//                            .frame(width: 100, height: 100)
//
//                        Circle()
//                            .stroke(gold.opacity(0.35), lineWidth: 1)
//                            .frame(width: 100, height: 100)
//
//                        Image(systemName: "person.badge.plus")
//                            .font(.system(size: 40))
//                            .foregroundStyle(
//                                LinearGradient(
//                                    colors: [gold, Color(red: 1, green: 0.9, blue: 0.65)],
//                                    startPoint: .topLeading,
//                                    endPoint: .bottomTrailing
//                                )
//                            )
//                    }
//                    .scaleEffect(logoScale)
//                    .opacity(logoOpacity)
//
//                    Spacer().frame(height: 24)
//
//                    // Title
//                    VStack(spacing: 6) {
//                        Text("Create Account")
//                            .font(.system(size: 30, weight: .light, design: .serif))
//                            .foregroundColor(.white)
//                            .tracking(1)
//
//                        Text("Join and explore thousands of books")
//                            .font(.system(size: 13, weight: .regular, design: .rounded))
//                            .foregroundColor(Color.white.opacity(0.40))
//                            .tracking(0.3)
//                    }
//                    .offset(y: titleOffset)
//                    .opacity(titleOpacity)
//
//                    Spacer().frame(height: 36)
//
//                    // ── Card ──
//                    VStack(spacing: 16) {
//
//                        dividerLabel("account details")
//
//                        // Full Name
//                        luxuryField(
//                            label: "FULL NAME",
//                            icon: "person",
//                            isFocused: focusedField == .name
//                        ) {
//                            TextField("", text: $name, prompt:
//                                Text("Your full name").foregroundColor(.white.opacity(0.25))
//                            )
//                            .focused($focusedField, equals: .name)
//                            .foregroundColor(.white)
//                            .font(.system(size: 16, weight: .light, design: .serif))
//                        }
//
//                        // Country with Dropdown
//                        VStack(alignment: .leading, spacing: 6) {
//                            Text("COUNTRY")
//                                .font(.system(size: 10, weight: .semibold, design: .rounded))
//                                .foregroundColor(gold.opacity(0.8))
//                                .tracking(2)
//
//                            HStack(spacing: 12) {
//                                Image(systemName: "globe")
//                                    .font(.system(size: 15))
//                                    .foregroundColor(isCountryFocused ? gold : Color.white.opacity(0.35))
//                                    .frame(width: 20)
//                                    .animation(.easeInOut(duration: 0.2), value: isCountryFocused)
//
//                                TextField("", text: $country, prompt:
//                                    Text("Select your country").foregroundColor(.white.opacity(0.25))
//                                )
//                                .focused($isCountryFocused)
//                                .foregroundColor(.white)
//                                .font(.system(size: 16, weight: .light, design: .serif))
//                                .onChange(of: country) { newValue in
//                                    filterCountries(query: newValue)
//                                }
//                                .onChange(of: isCountryFocused) { focused in
//                                    if focused {
//                                        filteredCountries = CountryList.countries
//                                        showDropdown = true
//                                    } else {
//                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
//                                            showDropdown = false
//                                        }
//                                    }
//                                }
//
//                                Image(systemName: showDropdown ? "chevron.up" : "chevron.down")
//                                    .font(.system(size: 11))
//                                    .foregroundColor(Color.white.opacity(0.3))
//                            }
//                            .padding(.horizontal, 18)
//                            .padding(.vertical, 16)
//                            .background(
//                                RoundedRectangle(cornerRadius: 14)
//                                    .fill(Color.white.opacity(0.06))
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 14)
//                                            .stroke(
//                                                isCountryFocused
//                                                    ? gold
//                                                    : Color.white.opacity(0.12),
//                                                lineWidth: isCountryFocused ? 1.5 : 1
//                                            )
//                                    )
//                            )
//
//                            // Dropdown
//                            if showDropdown {
//                                ScrollView {
//                                    VStack(alignment: .leading, spacing: 0) {
//                                        ForEach(filteredCountries, id: \.self) { item in
//                                            Button(action: {
//                                                country = item
//                                                showDropdown = false
//                                                isCountryFocused = false
//                                            }) {
//                                                HStack {
//                                                    Text(item)
//                                                        .font(.system(size: 14, weight: .light, design: .serif))
//                                                        .foregroundColor(country == item ? gold : Color.white.opacity(0.8))
//                                                    Spacer()
//                                                    if country == item {
//                                                        Image(systemName: "checkmark")
//                                                            .font(.system(size: 11))
//                                                            .foregroundColor(gold)
//                                                    }
//                                                }
//                                                .padding(.horizontal, 16)
//                                                .padding(.vertical, 11)
//                                                .background(
//                                                    country == item
//                                                        ? gold.opacity(0.1)
//                                                        : Color.clear
//                                                )
//                                            }
//                                            Divider()
//                                                .background(Color.white.opacity(0.06))
//                                        }
//                                    }
//                                }
//                                .frame(maxHeight: 160)
//                                .background(
//                                    RoundedRectangle(cornerRadius: 14)
//                                        .fill(Color(red: 0.13, green: 0.13, blue: 0.18))
//                                        .overlay(
//                                            RoundedRectangle(cornerRadius: 14)
//                                                .stroke(gold.opacity(0.25), lineWidth: 1)
//                                        )
//                                )
//                                .transition(.opacity.combined(with: .move(edge: .top)))
//                                .animation(.easeInOut(duration: 0.2), value: showDropdown)
//                            }
//                        }
//
//                        dividerLabel("contact info")
//
//                        // Email
//                        luxuryField(
//                            label: "EMAIL",
//                            icon: "envelope",
//                            isFocused: focusedField == .email
//                        ) {
//                            TextField("", text: $email, prompt:
//                                Text("your@email.com").foregroundColor(.white.opacity(0.25))
//                            )
//                            .focused($focusedField, equals: .email)
//                            .autocapitalization(.none)
//                            .keyboardType(.emailAddress)
//                            .foregroundColor(.white)
//                            .font(.system(size: 16, weight: .light, design: .serif))
//                        }
//
//                        dividerLabel("security")
//
//                        // Password
//                        VStack(alignment: .leading, spacing: 6) {
//                            Text("PASSWORD")
//                                .font(.system(size: 10, weight: .semibold, design: .rounded))
//                                .foregroundColor(gold.opacity(0.8))
//                                .tracking(2)
//
//                            HStack(spacing: 12) {
//                                Image(systemName: "lock")
//                                    .font(.system(size: 15))
//                                    .foregroundColor(focusedField == .password ? gold : Color.white.opacity(0.35))
//                                    .frame(width: 20)
//                                    .animation(.easeInOut(duration: 0.2), value: focusedField)
//
//                                Group {
//                                    if showPassword {
//                                        TextField("", text: $password, prompt:
//                                            Text("••••••••").foregroundColor(.white.opacity(0.25))
//                                        )
//                                    } else {
//                                        SecureField("", text: $password, prompt:
//                                            Text("••••••••").foregroundColor(.white.opacity(0.25))
//                                        )
//                                    }
//                                }
//                                .focused($focusedField, equals: .password)
//                                .foregroundColor(.white)
//                                .font(.system(size: 16, weight: .light, design: .serif))
//
//                                Button(action: { showPassword.toggle() }) {
//                                    Image(systemName: showPassword ? "eye.slash" : "eye")
//                                        .font(.system(size: 14))
//                                        .foregroundColor(Color.white.opacity(0.35))
//                                }
//                            }
//                            .padding(.horizontal, 18)
//                            .padding(.vertical, 16)
//                            .background(
//                                RoundedRectangle(cornerRadius: 14)
//                                    .fill(Color.white.opacity(0.06))
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 14)
//                                            .stroke(
//                                                focusedField == .password ? gold : Color.white.opacity(0.12),
//                                                lineWidth: focusedField == .password ? 1.5 : 1
//                                            )
//                                    )
//                            )
//                        }
//
//                        // Confirm Password
//                        VStack(alignment: .leading, spacing: 6) {
//                            Text("CONFIRM PASSWORD")
//                                .font(.system(size: 10, weight: .semibold, design: .rounded))
//                                .foregroundColor(gold.opacity(0.8))
//                                .tracking(2)
//
//                            HStack(spacing: 12) {
//                                Image(systemName: "lock.shield")
//                                    .font(.system(size: 15))
//                                    .foregroundColor(focusedField == .confirmPassword ? gold : Color.white.opacity(0.35))
//                                    .frame(width: 20)
//                                    .animation(.easeInOut(duration: 0.2), value: focusedField)
//
//                                Group {
//                                    if showConfirmPassword {
//                                        TextField("", text: $confirmPassword, prompt:
//                                            Text("••••••••").foregroundColor(.white.opacity(0.25))
//                                        )
//                                    } else {
//                                        SecureField("", text: $confirmPassword, prompt:
//                                            Text("••••••••").foregroundColor(.white.opacity(0.25))
//                                        )
//                                    }
//                                }
//                                .focused($focusedField, equals: .confirmPassword)
//                                .foregroundColor(.white)
//                                .font(.system(size: 16, weight: .light, design: .serif))
//
//                                Button(action: { showConfirmPassword.toggle() }) {
//                                    Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
//                                        .font(.system(size: 14))
//                                        .foregroundColor(Color.white.opacity(0.35))
//                                }
//                            }
//                            .padding(.horizontal, 18)
//                            .padding(.vertical, 16)
//                            .background(
//                                RoundedRectangle(cornerRadius: 14)
//                                    .fill(Color.white.opacity(0.06))
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 14)
//                                            .stroke(
//                                                focusedField == .confirmPassword ? gold : Color.white.opacity(0.12),
//                                                lineWidth: focusedField == .confirmPassword ? 1.5 : 1
//                                            )
//                                    )
//                            )
//                        }
//
//                        // Error message
//                        if let error = viewModel.errorMessage {
//                            HStack(spacing: 8) {
//                                Image(systemName: "exclamationmark.circle")
//                                    .font(.system(size: 13))
//                                Text(error)
//                                    .font(.system(size: 13))
//                            }
//                            .foregroundColor(Color(red: 1.0, green: 0.45, blue: 0.45))
//                            .padding(.top, 4)
//                        }
//
//                        Spacer().frame(height: 6)
//
//                        // Sign Up Button
//                        Button(action: signUpUser) {
//                            ZStack {
//                                RoundedRectangle(cornerRadius: 16)
//                                    .fill(
//                                        LinearGradient(
//                                            colors: [
//                                                Color(red: 0.85, green: 0.72, blue: 0.50),
//                                                Color(red: 0.70, green: 0.55, blue: 0.30)
//                                            ],
//                                            startPoint: .topLeading,
//                                            endPoint: .bottomTrailing
//                                        )
//                                    )
//                                    .frame(height: 56)
//                                    .shadow(color: gold.opacity(0.32), radius: 14, y: 5)
//
//                                HStack(spacing: 10) {
//                                    Text("Create Account")
//                                        .font(.system(size: 17, weight: .semibold, design: .rounded))
//                                        .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.07))
//                                        .tracking(0.5)
//                                    Image(systemName: "arrow.right")
//                                        .font(.system(size: 14, weight: .semibold))
//                                        .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.07))
//                                }
//                            }
//                        }
//                        .opacity(buttonOpacity)
//                    }
//                    .padding(26)
//                    .background(
//                        RoundedRectangle(cornerRadius: 28)
//                            .fill(cardBg)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 28)
//                                    .stroke(Color.white.opacity(0.07), lineWidth: 1)
//                            )
//                            .shadow(color: Color.black.opacity(0.4), radius: 28, y: 10)
//                    )
//                    .padding(.horizontal, 24)
//                    .offset(y: cardOffset)
//                    .opacity(cardOpacity)
//
//                    Spacer().frame(height: 30)
//
//                    // Already have account
//                    HStack(spacing: 6) {
//                        Text("Already have an account?")
//                            .font(.system(size: 14, weight: .light, design: .rounded))
//                            .foregroundColor(Color.white.opacity(0.4))
//
//                        Button(action: { dismiss() }) {
//                            Text("Sign in")
//                                .font(.system(size: 14, weight: .semibold, design: .rounded))
//                                .foregroundColor(gold)
//                        }
//                    }
//                    .opacity(buttonOpacity)
//
//                    Spacer().frame(height: 48)
//                }
//            }
//        }
//        .navigationBarHidden(true)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button(action: { dismiss() }) {
//                    HStack(spacing: 6) {
//                        Image(systemName: "chevron.left")
//                            .font(.system(size: 14, weight: .medium))
//                        Text("Back")
//                            .font(.system(size: 15))
//                    }
//                    .foregroundColor(gold)
//                }
//            }
//        }
//        .navigationBarHidden(true)
//        .onAppear { runEntrance() }
//    }
//
//    // MARK: - Subviews
//
//    @ViewBuilder
//    private func dividerLabel(_ label: String) -> some View {
//        HStack {
//            Rectangle()
//                .fill(Color.white.opacity(0.09))
//                .frame(height: 1)
//            Text(label)
//                .font(.system(size: 10, weight: .medium, design: .rounded))
//                .foregroundColor(Color.white.opacity(0.22))
//                .padding(.horizontal, 10)
//                .tracking(2)
//            Rectangle()
//                .fill(Color.white.opacity(0.09))
//                .frame(height: 1)
//        }
//    }
//
//    @ViewBuilder
//    private func luxuryField<Content: View>(
//        label: String,
//        icon: String,
//        isFocused: Bool,
//        @ViewBuilder content: () -> Content
//    ) -> some View {
//        VStack(alignment: .leading, spacing: 6) {
//            Text(label)
//                .font(.system(size: 10, weight: .semibold, design: .rounded))
//                .foregroundColor(gold.opacity(0.8))
//                .tracking(2)
//
//            HStack(spacing: 12) {
//                Image(systemName: icon)
//                    .font(.system(size: 15))
//                    .foregroundColor(isFocused ? gold : Color.white.opacity(0.35))
//                    .frame(width: 20)
//                    .animation(.easeInOut(duration: 0.2), value: isFocused)
//
//                content()
//            }
//            .padding(.horizontal, 18)
//            .padding(.vertical, 16)
//            .background(
//                RoundedRectangle(cornerRadius: 14)
//                    .fill(Color.white.opacity(0.06))
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 14)
//                            .stroke(
//                                isFocused ? gold : Color.white.opacity(0.12),
//                                lineWidth: isFocused ? 1.5 : 1
//                            )
//                    )
//            )
//        }
//    }
//
//    // MARK: - Logic (unchanged)
//    private func signUpUser() {
//        guard !email.isEmpty,
//              !password.isEmpty,
//              !name.isEmpty,
//              !country.isEmpty else {
//            viewModel.errorMessage = "Please fill all fields"
//            return
//        }
//
//        guard password == confirmPassword else {
//            viewModel.errorMessage = "Passwords do not match"
//            return
//        }
//
//        viewModel.signUp(
//            email: email,
//            password: password,
//            name: name,
//            country: country
//        )
//    }
//
//    private func filterCountries(query: String) {
//        if query.isEmpty {
//            filteredCountries = CountryList.countries
//            showDropdown = true
//        } else {
//            filteredCountries = CountryList.countries.filter {
//                $0.lowercased().contains(query.lowercased())
//            }
//            showDropdown = !filteredCountries.isEmpty
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
//        withAnimation(.easeOut(duration: 0.5).delay(0.7)) {
//            buttonOpacity = 1.0
//        }
//    }
//}


import SwiftUI

struct SignupView: View {

    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AuthViewModel
    @EnvironmentObject private var themeManager: ThemeManager

    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var name = ""
    @State private var country = ""

    @State private var filteredCountries: [String] = []
    @State private var showDropdown = false
    @FocusState private var isCountryFocused: Bool

    @State private var showPassword = false
    @State private var showConfirmPassword = false

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
        ZStack {
            pageBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    header

                    card

                    if let error = viewModel.errorMessage, !error.isEmpty {
                        errorBanner(error)
                            .padding(.horizontal, 18)
                    }

                    Button {
                        dismiss()
                    } label: {
                        Text("Already have an account? Sign In")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(accent)
                    }
                    .padding(.bottom, 20)
                }
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
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text("Create Account")
                .font(.system(size: 30, weight: .semibold, design: .serif))
                .foregroundColor(primaryText)

            Text("Build your profile and start your personalized library")
                .font(.system(size: 13, design: .rounded))
                .foregroundColor(secondaryText)
        }
        .padding(.top, 20)
    }

    private var card: some View {
        VStack(spacing: 12) {
            field(icon: "person", placeholder: "Full Name", text: $name)

            countryField

            field(icon: "envelope", placeholder: "Email Address", text: $email, keyboardType: .emailAddress)

            secureField(icon: "lock", placeholder: "Password", text: $password, isVisible: $showPassword)

            secureField(icon: "lock.rotation", placeholder: "Confirm Password", text: $confirmPassword, isVisible: $showConfirmPassword)

            Button {
                signUpUser()
            } label: {
                Text("Sign Up")
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
        .padding(.horizontal, 18)
    }

    private var countryField: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: "globe")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(secondaryText)
                    .frame(width: 18)

                TextField("Country", text: $country)
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(primaryText)
                    .focused($isCountryFocused)
                        .onChange(of: country) { newValue in
                            filterCountries(query: newValue)
                        }
                        .onChange(of: isCountryFocused) { focused in
                            if focused {
                                filteredCountries = CountryList.countries
                                showDropdown = true
                            } else {
                                showDropdown = false
                            }
                        }

                Image(systemName: "chevron.down")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(secondaryText)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(fieldBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 1)
            )
            .cornerRadius(10)

            if showDropdown {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(filteredCountries, id: \.self) { item in
                            Button {
                                country = item
                                showDropdown = false
                                isCountryFocused = false
                            } label: {
                                HStack {
                                    Text(item)
                                        .font(.system(size: 13, design: .rounded))
                                        .foregroundColor(primaryText)
                                    Spacer()
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                            }
                            .buttonStyle(.plain)

                            Divider().overlay(borderColor)
                        }
                    }
                }
                .frame(maxHeight: 140)
                .background(cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(borderColor, lineWidth: 1)
                )
                .cornerRadius(10)
            }
        }
    }

    private func field(icon: String, placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType = .default) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(secondaryText)
                .frame(width: 18)

            TextField(placeholder, text: text)
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(primaryText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .keyboardType(keyboardType)
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

    private func secureField(icon: String, placeholder: String, text: Binding<String>, isVisible: Binding<Bool>) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(secondaryText)
                .frame(width: 18)

            if isVisible.wrappedValue {
                TextField(placeholder, text: text)
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(primaryText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
            } else {
                SecureField(placeholder, text: text)
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(primaryText)
            }

            Button {
                isVisible.wrappedValue.toggle()
            } label: {
                Image(systemName: isVisible.wrappedValue ? "eye.slash" : "eye")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(secondaryText)
            }
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

    private func errorBanner(_ message: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.circle.fill")
                .font(.system(size: 13))
            Text(message)
                .font(.system(size: 12, design: .rounded))
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

    private func signUpUser() {
        guard !email.isEmpty,
              !password.isEmpty,
              !name.isEmpty,
              !country.isEmpty else {
            viewModel.errorMessage = "Please fill all fields"
            return
        }

        guard password == confirmPassword else {
            viewModel.errorMessage = "Passwords do not match"
            return
        }

        viewModel.signUp(email: email, password: password, name: name, country: country)
    }

    private func filterCountries(query: String) {
        if query.isEmpty {
            filteredCountries = CountryList.countries
            showDropdown = true
        } else {
            filteredCountries = CountryList.countries.filter {
                $0.lowercased().contains(query.lowercased())
            }
            showDropdown = !filteredCountries.isEmpty
        }
    }
}
