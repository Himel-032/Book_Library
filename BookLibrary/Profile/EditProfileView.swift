//
//  EditProfileView.swift
//  BookLibrary
//
//  Created by macos on 24/2/26.
//

import SwiftUI

//struct EditProfileView: View {
//
//    @ObservedObject var viewModel: AuthViewModel
//    @Environment(\.dismiss) var dismiss
//
//    @State private var name = ""
//    @State private var country = ""
//    @State private var showMessage = false
//    @State private var message = ""
//
//    var body: some View {
//        VStack(spacing: 20) {
//
//            Text("Edit Profile")
//                .font(.largeTitle)
//                .bold()
//
//            TextField("Name", text: $name)
//                .textFieldStyle(.roundedBorder)
//
//            TextField("Country", text: $country)
//                .textFieldStyle(.roundedBorder)
//
//            Button("Save Changes") {
//                updateProfile()
//            }
//            .buttonStyle(.borderedProminent)
//
//            if showMessage {
//                Text(message)
//                    .foregroundColor(.green)
//            }
//        }
//        .padding()
//        .onAppear {
//            loadCurrentData()
//        }
//    }
//
//    private func loadCurrentData() {
//        name = viewModel.profile?.name ?? ""
//        country = viewModel.profile?.country ?? ""
//    }
//
//    private func updateProfile() {
//        viewModel.updateProfile(name: name, country: country) { success in
//            if success {
//                message = "Profile updated"
//                showMessage = true
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                    dismiss()
//                }
//            } else {
//                message = "Update failed"
//                showMessage = true
//            }
//        }
//    }
//}

//
//struct EditProfileView: View {
//    
//    @ObservedObject var viewModel: AuthViewModel
//    @Environment(\.dismiss) var dismiss
//    
//    @State private var name = ""
//    @State private var country = ""
//    
//    @State private var filteredCountries: [String] = []
//    @State private var showDropdown = false
//    @FocusState private var isCountryFocused: Bool
//    
//    @State private var showMessage = false
//    @State private var message = ""
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            
//            Text("Edit Profile")
//                .font(.largeTitle)
//                .bold()
//            
//            // Name
//            TextField("Name", text: $name)
//                .textFieldStyle(.roundedBorder)
//            
//            // Country with dropdown
//            VStack(alignment: .leading) {
//                
//                TextField("Country", text: $country)
//                    .textFieldStyle(.roundedBorder)
//                    .focused($isCountryFocused)
//                    .onChange(of: country) { newValue in
//                        filterCountries(query: newValue)
//                    }
//                    .onChange(of: isCountryFocused) { focused in
//                        if focused {
//                            filteredCountries = CountryList.countries
//                            showDropdown = true
//                        } else {
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                                showDropdown = false
//                            }
//                        }
//                    }
//                
//                if showDropdown {
//                    ScrollView {
//                        VStack(alignment: .leading) {
//                            ForEach(filteredCountries, id: \.self) { item in
//                                Button {
//                                    country = item
//                                    showDropdown = false
//                                } label: {
//                                    Text(item)
//                                        .padding(.vertical, 6)
//                                        .frame(maxWidth: .infinity, alignment: .leading)
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
//            // Save button
//            Button("Save Changes") {
//                updateProfile()
//            }
//            .buttonStyle(.borderedProminent)
//            .disabled(name.isEmpty || country.isEmpty)
//            
//            if showMessage {
//                Text(message)
//                    .foregroundColor(.green)
//            }
//            
//            Spacer()
//        }
//        .padding()
//        .onAppear {
//            loadCurrentData()
//        }
//    }
//    
//    private func loadCurrentData() {
//        name = viewModel.profile?.name ?? ""
//        country = viewModel.profile?.country ?? ""
//    }
//    
//    private func updateProfile() {
//        viewModel.updateProfile(name: name, country: country) { success in
//            if success {
//                message = "Profile updated successfully"
//                showMessage = true
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                    dismiss()
//                }
//            } else {
//                message = "Update failed"
//                showMessage = true
//            }
//        }
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
//}
//



//
//import SwiftUI
//
//struct EditProfileView: View {
//
//    @ObservedObject var viewModel: AuthViewModel
//    @Environment(\.dismiss) var dismiss
//    @EnvironmentObject var themeManager: ThemeManager
//
//    @State private var name = ""
//    @State private var country = ""
//
//    @State private var filteredCountries: [String] = []
//    @State private var showDropdown = false
//    @FocusState private var isCountryFocused: Bool
//
//    @State private var showMessage = false
//    @State private var message = ""
//    @State private var isSuccess = false
//    @State private var isSaving = false
//
//    private var isDarkMode: Bool {
//        themeManager.currentTheme == .dark
//    }
//
//    private var screenBackground: some View {
//        LinearGradient(
//            colors: isDarkMode
//                ? [Color(red: 0.08, green: 0.09, blue: 0.12), Color(red: 0.13, green: 0.11, blue: 0.16), Color(red: 0.07, green: 0.07, blue: 0.09)]
//                : [Color(red: 0.98, green: 0.95, blue: 0.90), Color(red: 0.96, green: 0.97, blue: 0.99), Color(red: 1.00, green: 0.98, blue: 0.95)],
//            startPoint: .topLeading,
//            endPoint: .bottomTrailing
//        )
//    }
//
//    private var cardBackground: Color {
//        isDarkMode ? Color.white.opacity(0.06) : Color.white.opacity(0.82)
//    }
//
//    private var elevatedCardBackground: Color {
//        isDarkMode ? Color.white.opacity(0.08) : Color.white
//    }
//
//    private var primaryText: Color {
//        isDarkMode ? Color.white : Color(red: 0.14, green: 0.12, blue: 0.11)
//    }
//
//    private var secondaryText: Color {
//        isDarkMode ? Color.white.opacity(0.68) : Color(red: 0.44, green: 0.39, blue: 0.35)
//    }
//
//    private var accent: Color {
//        Color(red: 0.18, green: 0.38, blue: 0.26)
//    }
//
//    private var accentSoft: Color {
//        Color(red: 0.18, green: 0.38, blue: 0.26).opacity(isDarkMode ? 0.22 : 0.12)
//    }
//
//    private var borderColor: Color {
//        isDarkMode ? Color.white.opacity(0.10) : Color(red: 0.86, green: 0.81, blue: 0.73)
//    }
//
//    private var fieldBackground: Color {
//        isDarkMode ? Color.black.opacity(0.18) : Color(red: 0.99, green: 0.98, blue: 0.97)
//    }
//
//    var body: some View {
//        ZStack {
//            screenBackground
//                .ignoresSafeArea()
//
//            decorativeBackground
//
//            ScrollView(showsIndicators: false) {
//                VStack(spacing: 20) {
//                    headerCard
//
//                    VStack(spacing: 18) {
//                        profileField(
//                            title: "Full Name",
//                            icon: "person.fill",
//                            placeholder: "Enter your name",
//                            text: $name
//                        )
//
//                        countryField
//
//                        actionButton
//
//                        if showMessage {
//                            statusBanner
//                        }
//                    }
//                    .padding(18)
//                    .background(
//                        RoundedRectangle(cornerRadius: 28, style: .continuous)
//                            .fill(cardBackground)
//                            .shadow(color: .black.opacity(isDarkMode ? 0.24 : 0.08), radius: 18, y: 8)
//                    )
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 28, style: .continuous)
//                            .stroke(borderColor, lineWidth: 1)
//                    )
//
//                    tipCard
//                }
//                .padding(.horizontal, 18)
//                .padding(.top, 20)
//                .padding(.bottom, 28)
//            }
//        }
//        .navigationTitle("Edit Profile")
//        .navigationBarTitleDisplayMode(.inline)
//        .onAppear {
//            loadCurrentData()
//            filteredCountries = CountryList.countries
//        }
//    }
//
//    private var decorativeBackground: some View {
//        ZStack {
//            Circle()
//                .fill(accent.opacity(isDarkMode ? 0.20 : 0.14))
//                .frame(width: 220, height: 220)
//                .blur(radius: 18)
//                .offset(x: 120, y: -240)
//
//            Circle()
//                .fill(Color(red: 0.72, green: 0.44, blue: 0.18).opacity(isDarkMode ? 0.12 : 0.10))
//                .frame(width: 180, height: 180)
//                .blur(radius: 16)
//                .offset(x: -130, y: 240)
//        }
//        .allowsHitTesting(false)
//    }
//
//    private var headerCard: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            HStack(alignment: .center, spacing: 14) {
//                ZStack {
//                    Circle()
//                        .fill(
//                            LinearGradient(
//                                colors: [accent, Color(red: 0.72, green: 0.44, blue: 0.18)],
//                                startPoint: .topLeading,
//                                endPoint: .bottomTrailing
//                            )
//                        )
//                        .frame(width: 62, height: 62)
//                        .shadow(color: accent.opacity(0.35), radius: 10, y: 4)
//
//                    Text(name.isEmpty ? "U" : String(name.prefix(1)).uppercased())
//                        .font(.system(size: 24, weight: .semibold, design: .serif))
//                        .foregroundColor(.white)
//                }
//
//                VStack(alignment: .leading, spacing: 4) {
//                    Text("Update your profile")
//                        .font(.system(size: 26, weight: .semibold, design: .serif))
//                        .foregroundColor(primaryText)
//
//                    Text("Keep your reader identity current across the library.")
//                        .font(.system(size: 13, design: .rounded))
//                        .foregroundColor(secondaryText)
//                        .fixedSize(horizontal: false, vertical: true)
//                }
//
//                Spacer()
//            }
//
//            HStack(spacing: 10) {
//                profilePill(icon: "book.fill", text: "Reader profile")
//                profilePill(icon: "globe", text: country.isEmpty ? "Country pending" : country)
//            }
//        }
//        .padding(20)
//        .background(
//            RoundedRectangle(cornerRadius: 30, style: .continuous)
//                .fill(elevatedCardBackground)
//                .shadow(color: .black.opacity(isDarkMode ? 0.22 : 0.08), radius: 16, y: 6)
//        )
//        .overlay(
//            RoundedRectangle(cornerRadius: 30, style: .continuous)
//                .stroke(borderColor, lineWidth: 1)
//        )
//    }
//
//    private func profilePill(icon: String, text: String) -> some View {
//        HStack(spacing: 7) {
//            Image(systemName: icon)
//                .font(.system(size: 11, weight: .semibold))
//            Text(text)
//                .font(.system(size: 11, weight: .semibold, design: .rounded))
//        }
//        .foregroundColor(primaryText)
//        .padding(.horizontal, 12)
//        .padding(.vertical, 8)
//        .background(Capsule().fill(accentSoft))
//    }
//
//    private func profileField(title: String, icon: String, placeholder: String, text: Binding<String>) -> some View {
//        VStack(alignment: .leading, spacing: 10) {
//            labelRow(title: title, icon: icon)
//
//            HStack(spacing: 12) {
//                ZStack {
//                    RoundedRectangle(cornerRadius: 14, style: .continuous)
//                        .fill(accentSoft)
//                        .frame(width: 38, height: 38)
//
//                    Image(systemName: icon)
//                        .font(.system(size: 14, weight: .semibold))
//                        .foregroundColor(accent)
//                }
//
//                TextField(placeholder, text: text)
//                    .font(.system(size: 16, design: .rounded))
//                    .foregroundColor(primaryText)
//                    .textInputAutocapitalization(.words)
//                    .autocorrectionDisabled()
//
//                Spacer(minLength: 0)
//            }
//            .padding(.horizontal, 14)
//            .padding(.vertical, 14)
//            .background(
//                RoundedRectangle(cornerRadius: 18, style: .continuous)
//                    .fill(fieldBackground)
//            )
//            .overlay(
//                RoundedRectangle(cornerRadius: 18, style: .continuous)
//                    .stroke(borderColor, lineWidth: 1)
//            )
//        }
//    }
//
//    private var countryField: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            labelRow(title: "Country", icon: "location.fill")
//
//            VStack(alignment: .leading, spacing: 10) {
//                HStack(spacing: 12) {
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 14, style: .continuous)
//                            .fill(accentSoft)
//                            .frame(width: 38, height: 38)
//
//                        Image(systemName: "location.fill")
//                            .font(.system(size: 14, weight: .semibold))
//                            .foregroundColor(accent)
//                    }
//
//                    TextField("Search country", text: $country)
//                        .font(.system(size: 16, design: .rounded))
//                        .foregroundColor(primaryText)
//                        .focused($isCountryFocused)
//                        .textInputAutocapitalization(.words)
//                        .autocorrectionDisabled()
//                        .onChange(of: country) { newValue in
//                            filterCountries(query: newValue)
//                        }
//                        .onChange(of: isCountryFocused) { focused in
//                            if focused {
//                                filteredCountries = CountryList.countries
//                                showDropdown = true
//                            } else {
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                                    showDropdown = false
//                                }
//                            }
//                        }
//
//                    Image(systemName: showDropdown ? "chevron.up" : "chevron.down")
//                        .font(.system(size: 11, weight: .semibold))
//                        .foregroundColor(secondaryText)
//                }
//                .padding(.horizontal, 14)
//                .padding(.vertical, 14)
//                .background(
//                    RoundedRectangle(cornerRadius: 18, style: .continuous)
//                        .fill(fieldBackground)
//                )
//                .overlay(
//                    RoundedRectangle(cornerRadius: 18, style: .continuous)
//                        .stroke(borderColor, lineWidth: 1)
//                )
//
//                if showDropdown {
//                    ScrollView(showsIndicators: false) {
//                        VStack(spacing: 0) {
//                            ForEach(filteredCountries, id: \.self) { item in
//                                Button {
//                                    country = item
//                                    showDropdown = false
//                                    isCountryFocused = false
//                                } label: {
//                                    HStack {
//                                        Text(item)
//                                            .font(.system(size: 14, design: .rounded))
//                                            .foregroundColor(primaryText)
//                                            .lineLimit(1)
//
//                                        Spacer()
//
//                                        Image(systemName: "arrow.up.left.and.arrow.down.right")
//                                            .font(.system(size: 10, weight: .semibold))
//                                            .foregroundColor(secondaryText.opacity(0.7))
//                                    }
//                                    .padding(.horizontal, 14)
//                                    .padding(.vertical, 11)
//                                }
//                                .buttonStyle(.plain)
//
//                                if item != filteredCountries.last {
//                                    Divider()
//                                        .padding(.leading, 14)
//                                }
//                            }
//                        }
//                    }
//                    .frame(maxHeight: 180)
//                    .background(
//                        RoundedRectangle(cornerRadius: 18, style: .continuous)
//                            .fill(cardBackground)
//                    )
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 18, style: .continuous)
//                            .stroke(borderColor, lineWidth: 1)
//                    )
//                }
//            }
//        }
//    }
//
//    private func labelRow(title: String, icon: String) -> some View {
//        HStack(spacing: 8) {
//            Image(systemName: icon)
//                .font(.system(size: 11, weight: .semibold))
//                .foregroundColor(accent)
//
//            Text(title.uppercased())
//                .font(.system(size: 10, weight: .semibold, design: .rounded))
//                .tracking(1.5)
//                .foregroundColor(secondaryText)
//        }
//    }
//
//    private var actionButton: some View {
//        Button(action: updateProfile) {
//            HStack(spacing: 10) {
//                if isSaving {
//                    ProgressView()
//                        .tint(.white)
//                } else {
//                    Image(systemName: "checkmark.circle.fill")
//                        .font(.system(size: 15, weight: .semibold))
//                }
//
//                Text(isSaving ? "Saving changes" : "Save Changes")
//                    .font(.system(size: 16, weight: .semibold, design: .rounded))
//            }
//            .frame(maxWidth: .infinity)
//            .padding(.vertical, 16)
//            .foregroundColor(.white)
//            .background(
//                LinearGradient(
//                    colors: [accent, Color(red: 0.73, green: 0.42, blue: 0.11)],
//                    startPoint: .leading,
//                    endPoint: .trailing
//                )
//            )
//            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
//            .shadow(color: accent.opacity(0.32), radius: 14, y: 6)
//        }
//        .buttonStyle(.plain)
//        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || country.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSaving)
//        .opacity(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || country.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSaving ? 0.65 : 1)
//    }
//
//    private var statusBanner: some View {
//        HStack(spacing: 12) {
//            Image(systemName: isSuccess ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
//                .font(.system(size: 15, weight: .semibold))
//                .foregroundColor(isSuccess ? Color(red: 0.16, green: 0.58, blue: 0.34) : Color(red: 0.78, green: 0.26, blue: 0.20))
//
//            Text(message)
//                .font(.system(size: 14, design: .rounded))
//                .foregroundColor(primaryText)
//                .fixedSize(horizontal: false, vertical: true)
//
//            Spacer()
//        }
//        .padding(.horizontal, 14)
//        .padding(.vertical, 12)
//        .background(
//            RoundedRectangle(cornerRadius: 16, style: .continuous)
//                .fill(isSuccess ? Color.green.opacity(isDarkMode ? 0.16 : 0.10) : Color.red.opacity(isDarkMode ? 0.16 : 0.10))
//        )
//        .overlay(
//            RoundedRectangle(cornerRadius: 16, style: .continuous)
//                .stroke(isSuccess ? Color.green.opacity(0.22) : Color.red.opacity(0.22), lineWidth: 1)
//        )
//    }
//
//    private var tipCard: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            HStack(spacing: 10) {
//                Image(systemName: "sparkles")
//                    .font(.system(size: 12, weight: .semibold))
//                    .foregroundColor(accent)
//                Text("Quick tip")
//                    .font(.system(size: 12, weight: .semibold, design: .rounded))
//                    .foregroundColor(primaryText)
//            }
//
//            Text("Use the sidebar to switch between light and dark mode. This screen will follow that theme automatically.")
//                .font(.system(size: 13, design: .rounded))
//                .foregroundColor(secondaryText)
//                .fixedSize(horizontal: false, vertical: true)
//        }
//        .padding(18)
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .background(
//            RoundedRectangle(cornerRadius: 22, style: .continuous)
//                .fill(cardBackground)
//        )
//        .overlay(
//            RoundedRectangle(cornerRadius: 22, style: .continuous)
//                .stroke(borderColor, lineWidth: 1)
//        )
//    }
//
//    private func loadCurrentData() {
//        name = viewModel.profile?.name ?? ""
//        country = viewModel.profile?.country ?? ""
//    }
//
//    private func updateProfile() {
//        isSaving = true
//
//        viewModel.updateProfile(name: name, country: country) { success in
//            isSaving = false
//            isSuccess = success
//            showMessage = true
//
//            if success {
//                message = "Profile updated successfully"
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                    dismiss()
//                }
//            } else {
//                message = "Update failed"
//            }
//        }
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
//}
//
//
//
//import SwiftUI
//
//struct EditProfileView: View {
//
//    @ObservedObject var viewModel: AuthViewModel
//    @Environment(\.dismiss) private var dismiss
//    @EnvironmentObject private var themeManager: ThemeManager
//
//    @State private var name = ""
//    @State private var country = ""
//    @State private var filteredCountries: [String] = []
//    @State private var showDropdown = false
//    @FocusState private var isCountryFocused: Bool
//    @State private var showMessage = false
//    @State private var message = ""
//    @State private var isSuccess = false
//    @State private var isSaving = false
//
//    private var isDarkMode: Bool {
//        themeManager.currentTheme == .dark
//    }
//
//    private var pageBackground: Color {
//        isDarkMode ? Color(red: 0.08, green: 0.09, blue: 0.11) : Color(red: 0.97, green: 0.96, blue: 0.94)
//    }
//
//    private var cardBackground: Color {
//        isDarkMode ? Color.white.opacity(0.06) : Color.white.opacity(0.92)
//    }
//
//    private var borderColor: Color {
//        isDarkMode ? Color.white.opacity(0.10) : Color(red: 0.86, green: 0.82, blue: 0.76)
//    }
//
//    private var primaryText: Color {
//        isDarkMode ? Color.white : Color(red: 0.16, green: 0.14, blue: 0.13)
//    }
//
//    private var secondaryText: Color {
//        isDarkMode ? Color.white.opacity(0.66) : Color(red: 0.46, green: 0.42, blue: 0.39)
//    }
//
//    private var accent: Color {
//        Color(red: 0.18, green: 0.38, blue: 0.26)
//    }
//
//    private var accentSoft: Color {
//        accent.opacity(isDarkMode ? 0.20 : 0.12)
//    }
//
//    private var fieldBackground: Color {
//        isDarkMode ? Color.black.opacity(0.18) : Color(red: 0.99, green: 0.99, blue: 0.98)
//    }
//
//    var body: some View {
//        ZStack {
//            pageBackground
//                .ignoresSafeArea()
//
//            ScrollView(showsIndicators: false) {
//                VStack(alignment: .leading, spacing: 18) {
//                    header
//
//                    summaryCard
//
//                    formCard
//
//                    statusView
//
//                    saveButton
//
//                    footerNote
//                }
//                .padding(.horizontal, 18)
//                .padding(.top, 18)
//                .padding(.bottom, 28)
//            }
//        }
//        .navigationTitle("Edit Profile")
//        .navigationBarTitleDisplayMode(.inline)
//        .onAppear {
//            loadCurrentData()
//            filteredCountries = CountryList.countries
//        }
//    }
//
//    private var header: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text("Profile Details")
//                .font(.system(size: 28, weight: .semibold, design: .serif))
//                .foregroundColor(primaryText)
//
//            Text("Keep your reader profile accurate and consistent across the app.")
//                .font(.system(size: 14, design: .rounded))
//                .foregroundColor(secondaryText)
//                .fixedSize(horizontal: false, vertical: true)
//        }
//        .padding(.top, 4)
//    }
//
//    private var summaryCard: some View {
//        HStack(spacing: 14) {
//            ZStack {
//                Circle()
//                    .fill(accentSoft)
//                    .frame(width: 56, height: 56)
//
//                Text(initialLetter)
//                    .font(.system(size: 22, weight: .semibold, design: .serif))
//                    .foregroundColor(accent)
//            }
//
//            VStack(alignment: .leading, spacing: 4) {
//                Text(viewModel.profile?.name.isEmpty == false ? viewModel.profile?.name ?? "Reader" : "Reader")
//                    .font(.system(size: 18, weight: .semibold, design: .serif))
//                    .foregroundColor(primaryText)
//
//                Text(viewModel.user?.email ?? "No email available")
//                    .font(.system(size: 13, design: .rounded))
//                    .foregroundColor(secondaryText)
//                    .lineLimit(1)
//
//                if !country.isEmpty {
//                    HStack(spacing: 6) {
//                        Image(systemName: "location.fill")
//                            .font(.system(size: 10, weight: .semibold))
//                        Text(country)
//                            .font(.system(size: 12, design: .rounded))
//                    }
//                    .foregroundColor(secondaryText)
//                }
//            }
//
//            Spacer()
//        }
//        .padding(18)
//        .background(
//            RoundedRectangle(cornerRadius: 22, style: .continuous)
//                .fill(cardBackground)
//        )
//        .overlay(
//            RoundedRectangle(cornerRadius: 22, style: .continuous)
//                .stroke(borderColor, lineWidth: 1)
//        )
//    }
//
//    private var formCard: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            fieldSection(title: "Name", icon: "person.fill") {
//                TextField("Enter your name", text: $name)
//                    .font(.system(size: 16, design: .rounded))
//                    .foregroundColor(primaryText)
//                    .textInputAutocapitalization(.words)
//                    .autocorrectionDisabled()
//            }
//
//            fieldSection(title: "Country", icon: "location.fill") {
//                VStack(alignment: .leading, spacing: 10) {
//                    HStack(spacing: 12) {
//                        Image(systemName: "location.fill")
//                            .font(.system(size: 14, weight: .semibold))
//                            .foregroundColor(accent)
//                            .frame(width: 20)
//
//                        TextField("Search country", text: $country)
//                            .font(.system(size: 16, design: .rounded))
//                            .foregroundColor(primaryText)
//                            .focused($isCountryFocused)
//                            .textInputAutocapitalization(.words)
//                            .autocorrectionDisabled()
//                            .onChange(of: country) { newValue in
//                                filterCountries(query: newValue)
//                            }
//                            .onChange(of: isCountryFocused) { focused in
//                                if focused {
//                                    filteredCountries = CountryList.countries
//                                    showDropdown = true
//                                } else {
//                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
//                                        showDropdown = false
//                                    }
//                                }
//                            }
//
//                        Image(systemName: showDropdown ? "chevron.up" : "chevron.down")
//                            .font(.system(size: 11, weight: .semibold))
//                            .foregroundColor(secondaryText)
//                    }
//                    .padding(.horizontal, 14)
//                    .padding(.vertical, 14)
//                    .background(
//                        RoundedRectangle(cornerRadius: 14, style: .continuous)
//                            .fill(fieldBackground)
//                    )
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 14, style: .continuous)
//                            .stroke(borderColor, lineWidth: 1)
//                    )
//
//                    if showDropdown {
//                        ScrollView(showsIndicators: false) {
//                            VStack(spacing: 0) {
//                                ForEach(filteredCountries, id: \.self) { item in
//                                    Button {
//                                        country = item
//                                        showDropdown = false
//                                        isCountryFocused = false
//                                    } label: {
//                                        HStack {
//                                            Text(item)
//                                                .font(.system(size: 14, design: .rounded))
//                                                .foregroundColor(primaryText)
//                                                .lineLimit(1)
//                                            Spacer()
//                                        }
//                                        .padding(.horizontal, 14)
//                                        .padding(.vertical, 11)
//                                    }
//                                    .buttonStyle(.plain)
//
//                                    if item != filteredCountries.last {
//                                        Divider()
//                                            .padding(.leading, 14)
//                                    }
//                                }
//                            }
//                        }
//                        .frame(maxHeight: 190)
//                        .background(
//                            RoundedRectangle(cornerRadius: 14, style: .continuous)
//                                .fill(cardBackground)
//                        )
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 14, style: .continuous)
//                                .stroke(borderColor, lineWidth: 1)
//                        )
//                    }
//                }
//            }
//        }
//        .padding(18)
//        .background(
//            RoundedRectangle(cornerRadius: 22, style: .continuous)
//                .fill(cardBackground)
//        )
//        .overlay(
//            RoundedRectangle(cornerRadius: 22, style: .continuous)
//                .stroke(borderColor, lineWidth: 1)
//        )
//    }
//
//    private func fieldSection<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
//        VStack(alignment: .leading, spacing: 10) {
//            HStack(spacing: 8) {
//                Image(systemName: icon)
//                    .font(.system(size: 11, weight: .semibold))
//                    .foregroundColor(accent)
//                Text(title.uppercased())
//                    .font(.system(size: 10, weight: .semibold, design: .rounded))
//                    .tracking(1.4)
//                    .foregroundColor(secondaryText)
//            }
//
//            HStack(spacing: 12) {
//                content()
//            }
//            .padding(.horizontal, 14)
//            .padding(.vertical, 14)
//            .background(
//                RoundedRectangle(cornerRadius: 14, style: .continuous)
//                    .fill(fieldBackground)
//            )
//            .overlay(
//                RoundedRectangle(cornerRadius: 14, style: .continuous)
//                    .stroke(borderColor, lineWidth: 1)
//            )
//        }
//    }
//
//    private var statusView: some View {
//        Group {
//            if showMessage {
//                HStack(spacing: 10) {
//                    Image(systemName: isSuccess ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
//                        .foregroundColor(isSuccess ? Color(red: 0.18, green: 0.56, blue: 0.31) : Color(red: 0.78, green: 0.26, blue: 0.20))
//                    Text(message)
//                        .font(.system(size: 14, design: .rounded))
//                        .foregroundColor(primaryText)
//                    Spacer()
//                }
//                .padding(.horizontal, 14)
//                .padding(.vertical, 12)
//                .background(
//                    RoundedRectangle(cornerRadius: 16, style: .continuous)
//                        .fill((isSuccess ? Color.green : Color.red).opacity(isDarkMode ? 0.16 : 0.10))
//                )
//                .overlay(
//                    RoundedRectangle(cornerRadius: 16, style: .continuous)
//                        .stroke((isSuccess ? Color.green : Color.red).opacity(0.22), lineWidth: 1)
//                )
//            }
//        }
//    }
//
//    private var saveButton: some View {
//        Button(action: updateProfile) {
//            HStack(spacing: 10) {
//                if isSaving {
//                    ProgressView()
//                        .tint(.white)
//                } else {
//                    Image(systemName: "checkmark")
//                        .font(.system(size: 14, weight: .semibold))
//                }
//
//                Text(isSaving ? "Saving..." : "Save Changes")
//                    .font(.system(size: 16, weight: .semibold, design: .rounded))
//            }
//            .frame(maxWidth: .infinity)
//            .padding(.vertical, 15)
//            .foregroundColor(.white)
//            .background(
//                LinearGradient(
//                    colors: [accent, accent.opacity(0.88)],
//                    startPoint: .leading,
//                    endPoint: .trailing
//                )
//            )
//            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
//        }
//        .buttonStyle(.plain)
//        .disabled(isSaving || name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || country.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
//        .opacity(isSaving || name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || country.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.7 : 1)
//    }
//
//    private var footerNote: some View {
//        Text("The sidebar theme setting is applied globally, so this view follows light and dark mode automatically.")
//            .font(.system(size: 12, design: .rounded))
//            .foregroundColor(secondaryText)
//            .fixedSize(horizontal: false, vertical: true)
//            .padding(.top, 2)
//    }
//
//    private var initialLetter: String {
//        let first = name.trimmingCharacters(in: .whitespacesAndNewlines).first
//        return first.map { String($0).uppercased() } ?? "U"
//    }
//
//    private func loadCurrentData() {
//        name = viewModel.profile?.name ?? ""
//        country = viewModel.profile?.country ?? ""
//    }
//
//    private func updateProfile() {
//        isSaving = true
//
//        viewModel.updateProfile(name: name, country: country) { success in
//            isSaving = false
//            isSuccess = success
//            showMessage = true
//
//            if success {
//                message = "Profile updated successfully"
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
//                    dismiss()
//                }
//            } else {
//                message = "Update failed"
//            }
//        }
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
//}



import SwiftUI

struct EditProfileView: View {

    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager

    @State private var name = ""
    @State private var country = ""
    @State private var filteredCountries: [String] = []
    @State private var showDropdown = false
    @FocusState private var isCountryFocused: Bool
    @State private var showMessage = false
    @State private var message = ""
    @State private var isSuccess = false
    @State private var isSaving = false

    private var isDarkMode: Bool {
        themeManager.currentTheme == .dark
    }

    private var pageBackground: Color {
        isDarkMode ? Color(red: 0.08, green: 0.09, blue: 0.11) : Color(red: 0.97, green: 0.95, blue: 0.90)
    }

    private var cardBackground: Color {
        isDarkMode ? Color(red: 0.14, green: 0.15, blue: 0.18) : Color(red: 1.00, green: 0.98, blue: 0.95)
    }

    private var borderColor: Color {
        isDarkMode ? Color.white.opacity(0.10) : Color(red: 0.86, green: 0.81, blue: 0.73)
    }

    private var primaryText: Color {
        isDarkMode ? Color.white : Color(red: 0.16, green: 0.14, blue: 0.13)
    }

    private var secondaryText: Color {
        isDarkMode ? Color.white.opacity(0.66) : Color(red: 0.46, green: 0.42, blue: 0.39)
    }

    private var accent: Color {
        Color(red: 0.18, green: 0.38, blue: 0.26)
    }

    private var accentSoft: Color {
        accent.opacity(isDarkMode ? 0.20 : 0.12)
    }

    private var fieldBackground: Color {
        isDarkMode ? Color(red: 0.20, green: 0.21, blue: 0.25) : Color(red: 0.98, green: 0.96, blue: 0.91)
    }

    private var dropdownBackground: Color {
        isDarkMode ? Color(red: 0.16, green: 0.17, blue: 0.20) : Color(red: 1.00, green: 0.98, blue: 0.95)
    }

    var body: some View {
        ZStack {
            pageBackground
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    header

                    summaryCard

                    formCard

                    statusView

                    saveButton

                    footerNote
                }
                .padding(.horizontal, 18)
                .padding(.top, 18)
                .padding(.bottom, 28)
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadCurrentData()
            filteredCountries = CountryList.countries
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Profile Details")
                .font(.system(size: 28, weight: .semibold, design: .serif))
                .foregroundColor(primaryText)

            Text("Keep your reader profile accurate and consistent across the app.")
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(secondaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.top, 4)
    }

    private var summaryCard: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(accentSoft)
                    .frame(width: 56, height: 56)

                Text(initialLetter)
                    .font(.system(size: 22, weight: .semibold, design: .serif))
                    .foregroundColor(accent)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.profile?.name.isEmpty == false ? viewModel.profile?.name ?? "Reader" : "Reader")
                    .font(.system(size: 18, weight: .semibold, design: .serif))
                    .foregroundColor(primaryText)

                Text(viewModel.user?.email ?? "No email available")
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(secondaryText)
                    .lineLimit(1)

                if !country.isEmpty {
                    HStack(spacing: 6) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 10, weight: .semibold))
                        Text(country)
                            .font(.system(size: 12, design: .rounded))
                    }
                    .foregroundColor(secondaryText)
                }
            }

            Spacer()
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(borderColor, lineWidth: 1)
        )
    }

    private var formCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            fieldSection(title: "Name", icon: "person.fill") {
                TextField("Enter your name", text: $name)
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(primaryText)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
            }

            fieldSection(title: "Country", icon: "location.fill") {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 12) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(accent)
                            .frame(width: 20)

                        TextField("Search country", text: $country)
                            .font(.system(size: 16, design: .rounded))
                            .foregroundColor(primaryText)
                            .focused($isCountryFocused)
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled()
                            .onChange(of: country) { newValue in
                                filterCountries(query: newValue)
                            }
                            .onChange(of: isCountryFocused) { focused in
                                if focused {
                                    filteredCountries = CountryList.countries
                                    showDropdown = true
                                } else {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                        showDropdown = false
                                    }
                                }
                            }

                        Image(systemName: showDropdown ? "chevron.up" : "chevron.down")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(secondaryText)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(fieldBackground)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(isDarkMode ? borderColor : Color(red: 0.79, green: 0.73, blue: 0.64), lineWidth: 1)
                    )

                    if showDropdown {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 0) {
                                ForEach(filteredCountries, id: \.self) { item in
                                    Button {
                                        country = item
                                        showDropdown = false
                                        isCountryFocused = false
                                    } label: {
                                        HStack {
                                            Text(item)
                                                .font(.system(size: 14, design: .rounded))
                                                .foregroundColor(primaryText)
                                                .lineLimit(1)
                                            Spacer()
                                        }
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 11)
                                    }
                                    .buttonStyle(.plain)

                                    if item != filteredCountries.last {
                                        Divider()
                                            .padding(.leading, 14)
                                    }
                                }
                            }
                        }
                        .frame(maxHeight: 190)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(dropdownBackground)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(borderColor, lineWidth: 1)
                        )
                    }
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(borderColor, lineWidth: 1)
        )
    }

    private func fieldSection<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(accent)
                Text(title.uppercased())
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .tracking(1.4)
                    .foregroundColor(secondaryText)
            }

            HStack(spacing: 12) {
                content()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(fieldBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(isDarkMode ? borderColor : Color(red: 0.79, green: 0.73, blue: 0.64), lineWidth: 1)
            )
        }
    }

    private var statusView: some View {
        Group {
            if showMessage {
                HStack(spacing: 10) {
                    Image(systemName: isSuccess ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                        .foregroundColor(isSuccess ? Color(red: 0.18, green: 0.56, blue: 0.31) : Color(red: 0.78, green: 0.26, blue: 0.20))
                    Text(message)
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(primaryText)
                    Spacer()
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill((isSuccess ? Color.green : Color.red).opacity(isDarkMode ? 0.16 : 0.08))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke((isSuccess ? Color.green : Color.red).opacity(0.22), lineWidth: 1)
                )
            }
        }
    }

    private var saveButton: some View {
        Button(action: updateProfile) {
            HStack(spacing: 10) {
                if isSaving {
                    ProgressView()
                        .tint(.white)
                } else {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .semibold))
                }

                Text(isSaving ? "Saving..." : "Save Changes")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .foregroundColor(.white)
            .background(
                LinearGradient(
                    colors: [accent, accent.opacity(0.88)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
        .disabled(isSaving || name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || country.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        .opacity(isSaving || name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || country.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.7 : 1)
    }

    private var footerNote: some View {
        Text("The sidebar theme setting is applied globally, so this view follows light and dark mode automatically.")
            .font(.system(size: 12, design: .rounded))
            .foregroundColor(secondaryText)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, 2)
    }

    private var initialLetter: String {
        let first = name.trimmingCharacters(in: .whitespacesAndNewlines).first
        return first.map { String($0).uppercased() } ?? "U"
    }

    private func loadCurrentData() {
        name = viewModel.profile?.name ?? ""
        country = viewModel.profile?.country ?? ""
    }

    private func updateProfile() {
        isSaving = true

        viewModel.updateProfile(name: name, country: country) { success in
            isSaving = false
            isSuccess = success
            showMessage = true

            if success {
                message = "Profile updated successfully"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    dismiss()
                }
            } else {
                message = "Update failed"
            }
        }
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
