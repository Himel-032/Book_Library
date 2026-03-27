//
//  SideMenuView.swift
//  BookLibrary
//
//  Created by macos on 24/2/26.
//

import SwiftUI

struct SideMenuView: View {
    
    @ObservedObject var viewModel: AuthViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingTheme = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    // Profile Section
                    profileSection
                    Divider()

                    // Main Menu
                    mainMenuSection
                    
                    Divider()
                    
                    // Settings Section
                    settingsSection
                    
                    Spacer(minLength: 20)
                    logoutButton.padding(.bottom, 20)
                }
                .padding(.horizontal, 20)
            }
        }
        .sheet(isPresented: $showingTheme) {
            ThemeSettingsView()
                .environmentObject(themeManager)
        }
    }
    
    // MARK: - Profile Section
    private var profileSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 50, height: 50)
                    
                    Text(viewModel.profile?.name.prefix(1).uppercased() ?? "U")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(viewModel.profile?.name ?? "User Name")
                        .font(.headline)
                    Text(viewModel.user?.email ?? "email@example.com")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            if let country = viewModel.profile?.country {
                HStack {
                    Image(systemName: "location.fill")
                        .font(.caption2)
                    Text(country)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Main Menu
    private var mainMenuSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            menuHeader("MAIN MENU")
            
            menuButton(icon: "books.vertical", title: "My Library", tab: 0)
            menuButton(icon: "heart", title: "Favorites", tab: 1)
            menuButton(icon: "person", title: "Profile", tab: 2)
        }
    }
    
    // MARK: - Settings Section
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            menuHeader("SETTINGS")
            
            // Edit Profile
            NavigationLink {
                EditProfileView(viewModel: viewModel)
                    .onAppear { homeViewModel.showMenu = false }
            } label: {
                HStack {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                        .frame(width: 24)
                    
                    Text("Edit Profile")
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 8)
            }
            
            // Theme Settings
            Button(action: {
                showingTheme = true
                homeViewModel.showMenu = false
            }) {
                HStack {
                    Image(systemName: "paintpalette")
                        .foregroundColor(.purple)
                        .frame(width: 24)
                    
                    Text("App Theme")
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(themeManager.currentTheme.displayName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 8)
            }
            
            // Dark Mode Toggle (Quick access)
            HStack {
                Image(systemName: themeManager.currentTheme == .dark ? "moon.fill" : "sun.max.fill")
                    .foregroundColor(themeManager.currentTheme == .dark ? .purple : .orange)
                    .frame(width: 24)
                
                Text("Dark Mode")
                    .foregroundColor(.primary)
                
                Spacer()
                
                Toggle("", isOn: Binding(
                    get: { themeManager.currentTheme == .dark },
                    set: { isDark in
                        themeManager.currentTheme = isDark ? .dark : .default
                    }
                ))
                .labelsHidden()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 8)
            
            // Help & Support
            NavigationLink {
                Text("Help & Support")
                    .navigationTitle("Help")
                    .onAppear { homeViewModel.showMenu = false }
            } label: {
                HStack {
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(.blue)
                        .frame(width: 24)
                    
                    Text("Help & Support")
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 8)
            }
        }
    }
    
    // MARK: - Logout Button
    private var logoutButton: some View {
        Button(action: {
            viewModel.logout()
        }) {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text("Logout")
                Spacer()
            }
            .foregroundColor(.red)
            .padding()
            .background(Color.red.opacity(0.1))
            .cornerRadius(10)
        }
    }
    
    // MARK: - Helper Functions
    private func menuHeader(_ title: String) -> some View {
        Text(title)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.secondary)
            .padding(.leading, 8)
            .padding(.top, 4)
    }
    
    private func menuButton(icon: String, title: String, tab: Int) -> some View {
        Button(action: {
            withAnimation {
                homeViewModel.selectedTab = tab
                homeViewModel.showMenu = false
            }
        }) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                Text(title)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if homeViewModel.selectedTab == tab {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 8)
            .background(homeViewModel.selectedTab == tab ? Color.blue.opacity(0.1) : Color.clear)
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
