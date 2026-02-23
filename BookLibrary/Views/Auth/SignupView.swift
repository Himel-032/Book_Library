//
//  SignupView.swift
//  BookLibrary
//
//  Created by Himel on 23/2/26.
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
//    @State private var filteredCountries: [String] = []
//    @State private var showDropdown = false
//    @FocusState private var isCountryFocused: Bool
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            
//            Text("Create Account")
//                .font(.largeTitle)
//                .bold()
//            TextField("Name", text: $name)
//                    .textFieldStyle(.roundedBorder)
//                    .autocapitalization(.none)
//                        
//            VStack(alignment: .leading) {
//
//                TextField("Country", text: $country)
//                    .textFieldStyle(.roundedBorder)
//                    .autocapitalization(.none)
//                    .focused($isCountryFocused)
//                    .onChange(of: country) { newValue in
//                        filterCountries(query: newValue)
//                    }
//                    .onChange(of: isCountryFocused) { focused in
//                        if focused {
//                            filteredCountries = CountryList.countries
//                            showDropdown = true
//                        } else {
//                            showDropdown = false
//                        }
//                    }
//
//                if showDropdown {
//                    ScrollView {
//                        VStack(alignment: .leading) {
//                            ForEach(filteredCountries, id: \.self) { item in
//                                Button(action: {
//                                    country = item
//                                    showDropdown = false
//                                }) {
//                                    Text(item)
//                                        .padding(.vertical, 5)
//                                }
//                            }
//                        }
//                    }
//                    .frame(maxHeight: 150)
//                    .background(Color(.systemGray6))
//                    .cornerRadius(8)
//                }
//            }
//          
//            
//            TextField("Email", text: $email)
//                .textFieldStyle(.roundedBorder)
//                .autocapitalization(.none)
//            
//            SecureField("Password", text: $password)
//                .textFieldStyle(.roundedBorder)
//            
//            SecureField("Confirm Password", text: $confirmPassword)
//                .textFieldStyle(.roundedBorder)
//            
//            Button("Sign Up") {
//                signUpUser()
//            }
//            .buttonStyle(.borderedProminent)
//            
//            if let error = viewModel.errorMessage {
//                Text(error)
//                    .foregroundColor(.red)
//            }
//            
//            Button("Already have an account? Login") {
//                dismiss()
//            }
//            .font(.footnote)
//        }
//        .padding()
//    }
//    
//    private func signUpUser() {
//            
//            guard !email.isEmpty,
//                  !password.isEmpty,
//                  !name.isEmpty,
//                  !country.isEmpty else {
//                viewModel.errorMessage = "Please fill all fields"
//                return
//            }
//            
//            guard password == confirmPassword else {
//                viewModel.errorMessage = "Passwords do not match"
//                return
//            }
//            
//            viewModel.signUp(
//                email: email,
//                password: password,
//                name: name,
//                country: country
//            )
//        }
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
//}
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
//    var body: some View {
//        VStack {
//            
//            Spacer()
//            
//            // Header (Consistent Style)
//            VStack(spacing: 8) {
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
//                SecureField("Password", text: $password)
//                    .padding()
//                    .background(Color(.systemGray6))
//                    .cornerRadius(10)
//                
//                SecureField("Confirm Password", text: $confirmPassword)
//                    .padding()
//                    .background(Color(.systemGray6))
//                    .cornerRadius(10)
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


import SwiftUI

struct SignupView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var name = ""
    @State private var country = ""
    
    @State private var filteredCountries: [String] = []
    @State private var showDropdown = false
    @FocusState private var isCountryFocused: Bool
    
    // Password visibility toggles
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    
    var body: some View {
        VStack {
            
            Spacer()
            
            // Header
            VStack(spacing: 8) {
                Image("book") // Your image asset name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 100)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                Text("Create Account")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Join the library and explore thousands of books")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer().frame(height: 30)
            
            // Input Card
            VStack(spacing: 16) {
                
                TextField("Full Name", text: $name)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                // Country with Dropdown
                VStack(alignment: .leading) {
                    
                    TextField("Country", text: $country)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
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
                    
                    if showDropdown {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(filteredCountries, id: \.self) { item in
                                    Button(action: {
                                        country = item
                                        showDropdown = false
                                        isCountryFocused = false
                                    }) {
                                        Text(item)
                                            .padding(.vertical, 6)
                                    }
                                }
                            }
                        }
                        .frame(maxHeight: 140)
                        .padding(.horizontal)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                }
                
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
                
                // Confirm Password Field with Eye Icon
                HStack {
                    if showConfirmPassword {
                        TextField("Confirm Password", text: $confirmPassword)
                    } else {
                        SecureField("Confirm Password", text: $confirmPassword)
                    }
                    
                    Button(action: {
                        showConfirmPassword.toggle()
                    }) {
                        Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
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
            
            // Sign Up Button
            Button(action: signUpUser) {
                Text("Sign Up")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            // Error Message
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.top, 6)
            }
            
            // Login Redirect
            Button("Already have an account? Login") {
                dismiss()
            }
            .font(.footnote)
            .padding(.top, 6)
            
            Spacer()
        }
        .padding()
    }
    
    // MARK: - Signup Logic
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
        
        viewModel.signUp(
            email: email,
            password: password,
            name: name,
            country: country
        )
    }
    
    // MARK: - Country Filter
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
