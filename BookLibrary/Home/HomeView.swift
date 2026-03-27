//
//  HomeView.swift
//  BookLibrary
//
//  Created by macos on 24/2/26.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel: AuthViewModel
    @StateObject private var homeViewModel = HomeViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Main Content
                VStack(spacing: 0) {
                    // Custom Header
                    customHeader
                    
                    // Tab Content
                    TabView(selection: $homeViewModel.selectedTab) {
                        // Library Tab
                        BookListView()
                            .tag(0)
                        
                        // Favorites Tab
                        FavoritesView()
                            .tag(1)
                        
                        // Profile Tab
                        ProfileView(viewModel: viewModel)
                            .tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
                
                // Side Menu
                if homeViewModel.showMenu {
                    sideMenuOverlay
                }
            }
        }
        .preferredColorScheme(themeManager.currentTheme.colorScheme)
    }
    
    // MARK: - Custom Header
    private var customHeader: some View {
        HStack {
            // Menu Button
            Button {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    homeViewModel.showMenu.toggle()
                }
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.title2)
                    .foregroundColor(.primary)
                    .frame(width: 44, height: 44)
                    .background(Color(.systemBackground))
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
            }
            
            Spacer()
            
            // Title
            Text(titleForTab(homeViewModel.selectedTab))
                .font(.headline)
                .fontWeight(.semibold)
            
            Spacer()
            
            // Search Button (only in Library tab)
            if homeViewModel.selectedTab == 0 {
                Button {
                    // Focus search in BookListView
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                        .background(Color(.systemBackground))
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                }
            } else {
                Color.clear.frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .padding(.bottom, 4)
        .background(Color(.systemBackground))
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
    }
    
    // MARK: - Side Menu Overlay
    private var sideMenuOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        homeViewModel.showMenu = false
                    }
                }
            
            HStack(spacing: 0) {
                SideMenuView(
                    viewModel: viewModel,
                    homeViewModel: homeViewModel
                )
                .frame(width: UIScreen.main.bounds.width * 0.75)
                .transition(.move(edge: .leading))
                
                Spacer(minLength: 0)
            }
        }
    }
    
    private func titleForTab(_ tab: Int) -> String {
        switch tab {
        case 0: return "My Library"
        case 1: return "Favorites"
        case 2: return "Profile"
        default: return "Book Library"
        }
    }
}

// MARK: - Profile View
struct ProfileView: View {
    @ObservedObject var viewModel: AuthViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingLogoutAlert = false
    @State private var showingStats = false
    @State private var showingTheme = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Header
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 80, height: 80)
                        
                        Text(viewModel.profile?.name.prefix(1).uppercased() ?? "U")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    
                    VStack(spacing: 4) {
                        Text(viewModel.profile?.name ?? "User Name")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(viewModel.user?.email ?? "email@example.com")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        if let country = viewModel.profile?.country {
                            HStack {
                                Image(systemName: "location.fill")
                                    .font(.caption)
                                Text(country)
                                    .font(.subheadline)
                            }
                            .foregroundColor(.secondary)
                        }
                    }
                    
                    NavigationLink(destination: EditProfileView(viewModel: viewModel)) {
                        Text("Edit Profile")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
                .cornerRadius(16)
                
                // Reading Stats Button
                Button(action: { showingStats = true }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Reading Statistics")
                                .font(.headline)
                            
                            Text("View your reading progress")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chart.bar.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
                
                // Stats Preview Cards
                StatsPreviewCards()
                
                // Settings Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("SETTINGS")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .padding(.leading, 8)
                    
                    VStack(spacing: 0) {
                        // Edit Profile
                        NavigationLink(destination: EditProfileView(viewModel: viewModel)) {
                            HStack {
                                Image(systemName: "pencil")
                                    .foregroundColor(.blue)
                                    .frame(width: 30)
                                Text("Edit Profile")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                        }
                        
                        Divider().padding(.leading, 50)
                        
                        // Theme Settings Button
                        Button(action: { showingTheme = true }) {
                            HStack {
                                Image(systemName: "paintpalette")
                                    .foregroundColor(.purple)
                                    .frame(width: 30)
                                Text("App Theme")
                                Spacer()
                                Text(themeManager.currentTheme.displayName)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                        }
                        
                        Divider().padding(.leading, 50)
                        
                        // Dark Mode Toggle (Quick access)
                        HStack {
                            Image(systemName: themeManager.currentTheme == .dark ? "moon.fill" : "sun.max.fill")
                                .foregroundColor(themeManager.currentTheme == .dark ? .purple : .orange)
                                .frame(width: 30)
                            Text("Dark Mode")
                            Spacer()
                            Toggle("", isOn: Binding(
                                get: { themeManager.currentTheme == .dark },
                                set: { isDark in
                                    themeManager.currentTheme = isDark ? .dark : .default
                                }
                            ))
                            .labelsHidden()
                        }
                        .padding()
                        
                        Divider().padding(.leading, 50)
                        
                        // Help & Support
                        NavigationLink(destination: Text("Help & Support").navigationTitle("Help")) {
                            HStack {
                                Image(systemName: "questionmark.circle")
                                    .foregroundColor(.blue)
                                    .frame(width: 30)
                                Text("Help & Support")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                        }
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                }
                
                // Logout
                Button {
                    showingLogoutAlert = true
                } label: {
                    Text("Logout")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .sheet(isPresented: $showingStats) {
            ReadingStatsView()
        }
        .sheet(isPresented: $showingTheme) {
            ThemeSettingsView()
                .environmentObject(themeManager)
        }
        .alert("Logout", isPresented: $showingLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Logout", role: .destructive) {
                viewModel.logout()
            }
        } message: {
            Text("Are you sure you want to logout?")
        }
    }
}

// MARK: - Stats Preview Cards
struct StatsPreviewCards: View {
    @StateObject private var statsVM = StatsViewModel()
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
            StatCard(
                value: "\(statsVM.finishedCount)",
                title: "Finished",
                icon: "checkmark.circle.fill",
                color: .green
            )
            
            StatCard(
                value: "\(statsVM.readingCount)",
                title: "Reading",
                icon: "book.fill",
                color: .blue
            )
            
            StatCard(
                value: "\(statsVM.streakCount)",
                title: "Streak",
                icon: "flame.fill",
                color: .orange
            )
        }
        .onAppear {
            statsVM.loadStats()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("CoreDataDataChanged"))) { _ in
            statsVM.loadStats()
        }
    }
}
// MARK: - Stat Card
struct StatCard: View {
    let value: String
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}
