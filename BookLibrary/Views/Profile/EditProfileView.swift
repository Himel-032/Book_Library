//
//  EditProfileView.swift
//  BookLibrary
//
//  Created by Himel on 23/2/26.
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


struct EditProfileView: View {
    
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var country = ""
    
    @State private var filteredCountries: [String] = []
    @State private var showDropdown = false
    @FocusState private var isCountryFocused: Bool
    
    @State private var showMessage = false
    @State private var message = ""
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Edit Profile")
                .font(.largeTitle)
                .bold()
            
            // Name
            TextField("Name", text: $name)
                .textFieldStyle(.roundedBorder)
            
            // Country with dropdown
            VStack(alignment: .leading) {
                
                TextField("Country", text: $country)
                    .textFieldStyle(.roundedBorder)
                    .focused($isCountryFocused)
                    .onChange(of: country) { newValue in
                        filterCountries(query: newValue)
                    }
                    .onChange(of: isCountryFocused) { focused in
                        if focused {
                            filteredCountries = CountryList.countries
                            showDropdown = true
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                showDropdown = false
                            }
                        }
                    }
                
                if showDropdown {
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(filteredCountries, id: \.self) { item in
                                Button {
                                    country = item
                                    showDropdown = false
                                } label: {
                                    Text(item)
                                        .padding(.vertical, 6)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 150)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
            }
            
            // Save button
            Button("Save Changes") {
                updateProfile()
            }
            .buttonStyle(.borderedProminent)
            .disabled(name.isEmpty || country.isEmpty)
            
            if showMessage {
                Text(message)
                    .foregroundColor(.green)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            loadCurrentData()
        }
    }
    
    private func loadCurrentData() {
        name = viewModel.profile?.name ?? ""
        country = viewModel.profile?.country ?? ""
    }
    
    private func updateProfile() {
        viewModel.updateProfile(name: name, country: country) { success in
            if success {
                message = "Profile updated successfully"
                showMessage = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    dismiss()
                }
            } else {
                message = "Update failed"
                showMessage = true
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
