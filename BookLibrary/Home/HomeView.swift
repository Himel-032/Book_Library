//
//
//import SwiftUI
//
//struct HomeView: View {
//    
//    @ObservedObject var viewModel: AuthViewModel
//    @StateObject private var homeViewModel = HomeViewModel()
//    @EnvironmentObject var themeManager: ThemeManager
//    
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                // Main Content
//                VStack(spacing: 0) {
//                    // Custom Header
//                    customHeader
//                    
//                    // Tab Content
//                    TabView(selection: $homeViewModel.selectedTab) {
//                        // Library Tab
//                        BookListView()
//                            .tag(0)
//                        
//                        // Favorites Tab
//                        FavoritesView()
//                            .tag(1)
//                        
//                        // Profile Tab
//                        ProfileView(viewModel: viewModel)
//                            .tag(2)
//                    }
//                    .tabViewStyle(.page(indexDisplayMode: .never))
//                }
//                
//                // Side Menu
//                if homeViewModel.showMenu {
//                    sideMenuOverlay
//                }
//            }
//        }
//        .preferredColorScheme(themeManager.currentTheme.colorScheme)
//    }
//    
//    // MARK: - Custom Header
//    private var customHeader: some View {
//        HStack {
//            // Menu Button
//            Button {
//                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
//                    homeViewModel.showMenu.toggle()
//                }
//            } label: {
//                Image(systemName: "line.3.horizontal")
//                    .font(.title2)
//                    .foregroundColor(.primary)
//                    .frame(width: 44, height: 44)
//                    .background(Color(.systemBackground))
//                    .clipShape(Circle())
//                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
//            }
//            
//            Spacer()
//            
//            // Title
//            Text(titleForTab(homeViewModel.selectedTab))
//                .font(.headline)
//                .fontWeight(.semibold)
//            
//            Spacer()
//            
//            // Search Button (only in Library tab)
//            if homeViewModel.selectedTab == 0 {
//                Button {
//                    // Focus search in BookListView
//                } label: {
//                    Image(systemName: "magnifyingglass")
//                        .font(.title2)
//                        .foregroundColor(.primary)
//                        .frame(width: 44, height: 44)
//                        .background(Color(.systemBackground))
//                        .clipShape(Circle())
//                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
//                }
//            } else {
//                Color.clear.frame(width: 44, height: 44)
//            }
//        }
//        .padding(.horizontal)
//        .padding(.top, 8)
//        .padding(.bottom, 4)
//        .background(Color(.systemBackground))
//        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
//    }
//    
//    // MARK: - Side Menu Overlay
//    private var sideMenuOverlay: some View {
//        ZStack {
//            Color.black.opacity(0.3)
//                .ignoresSafeArea()
//                .onTapGesture {
//                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
//                        homeViewModel.showMenu = false
//                    }
//                }
//            
//            HStack(spacing: 0) {
//                SideMenuView(
//                    viewModel: viewModel,
//                    homeViewModel: homeViewModel
//                )
//                .frame(width: UIScreen.main.bounds.width * 0.75)
//                .transition(.move(edge: .leading))
//                
//                Spacer(minLength: 0)
//            }
//        }
//    }
//    
//    private func titleForTab(_ tab: Int) -> String {
//        switch tab {
//        case 0: return "My Library"
//        case 1: return "Favorites"
//        case 2: return "Profile"
//        default: return "Book Library"
//        }
//    }
//}
//
//// MARK: - Profile View
//struct ProfileView: View {
//    @ObservedObject var viewModel: AuthViewModel
//    @EnvironmentObject var themeManager: ThemeManager
//    @State private var showingLogoutAlert = false
//    @State private var showingStats = false
//    @State private var showingTheme = false
//    
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//                // Profile Header
//                VStack(spacing: 16) {
//                    ZStack {
//                        Circle()
//                            .fill(Color.blue)
//                            .frame(width: 80, height: 80)
//                        
//                        Text(viewModel.profile?.name.prefix(1).uppercased() ?? "U")
//                            .font(.title)
//                            .fontWeight(.semibold)
//                            .foregroundColor(.white)
//                    }
//                    
//                    VStack(spacing: 4) {
//                        Text(viewModel.profile?.name ?? "User Name")
//                            .font(.title2)
//                            .fontWeight(.bold)
//                        
//                        Text(viewModel.user?.email ?? "email@example.com")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                        
//                        if let country = viewModel.profile?.country {
//                            HStack {
//                                Image(systemName: "location.fill")
//                                    .font(.caption)
//                                Text(country)
//                                    .font(.subheadline)
//                            }
//                            .foregroundColor(.secondary)
//                        }
//                    }
//                    
//                    NavigationLink(destination: EditProfileView(viewModel: viewModel)) {
//                        Text("Edit Profile")
//                            .font(.subheadline)
//                            .fontWeight(.semibold)
//                            .foregroundColor(.blue)
//                            .padding(.horizontal, 20)
//                            .padding(.vertical, 8)
//                            .background(
//                                Capsule()
//                                    .stroke(Color.blue, lineWidth: 1)
//                            )
//                    }
//                }
//                .padding()
//                .frame(maxWidth: .infinity)
//                .background(Color(.systemBackground))
//                .cornerRadius(16)
//                
//                // Reading Stats Button
//                Button(action: { showingStats = true }) {
//                    HStack {
//                        VStack(alignment: .leading, spacing: 4) {
//                            Text("Reading Statistics")
//                                .font(.headline)
//                            
//                            Text("View your reading progress")
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//                        }
//                        
//                        Spacer()
//                        
//                        Image(systemName: "chart.bar.fill")
//                            .font(.title2)
//                            .foregroundColor(.blue)
//                        
//                        Image(systemName: "chevron.right")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                    }
//                    .padding()
//                    .background(Color(.systemBackground))
//                    .cornerRadius(12)
//                }
//                .buttonStyle(PlainButtonStyle())
//                
//                // Stats Preview Cards
//                StatsPreviewCards()
//                
//                // Settings Section
//                VStack(alignment: .leading, spacing: 8) {
//                    Text("SETTINGS")
//                        .font(.caption)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.secondary)
//                        .padding(.leading, 8)
//                    
//                    VStack(spacing: 0) {
//                        // Edit Profile
//                        NavigationLink(destination: EditProfileView(viewModel: viewModel)) {
//                            HStack {
//                                Image(systemName: "pencil")
//                                    .foregroundColor(.blue)
//                                    .frame(width: 30)
//                                Text("Edit Profile")
//                                Spacer()
//                                Image(systemName: "chevron.right")
//                                    .font(.caption)
//                                    .foregroundColor(.gray)
//                            }
//                            .padding()
//                        }
//                        
//                        Divider().padding(.leading, 50)
//                        
//                        // Theme Settings Button
//                        Button(action: { showingTheme = true }) {
//                            HStack {
//                                Image(systemName: "paintpalette")
//                                    .foregroundColor(.purple)
//                                    .frame(width: 30)
//                                Text("App Theme")
//                                Spacer()
//                                Text(themeManager.currentTheme.displayName)
//                                    .font(.caption)
//                                    .foregroundColor(.secondary)
//                                Image(systemName: "chevron.right")
//                                    .font(.caption)
//                                    .foregroundColor(.gray)
//                            }
//                            .padding()
//                        }
//                        
//                        Divider().padding(.leading, 50)
//                        
//                        // Dark Mode Toggle (Quick access)
//                        HStack {
//                            Image(systemName: themeManager.currentTheme == .dark ? "moon.fill" : "sun.max.fill")
//                                .foregroundColor(themeManager.currentTheme == .dark ? .purple : .orange)
//                                .frame(width: 30)
//                            Text("Dark Mode")
//                            Spacer()
//                            Toggle("", isOn: Binding(
//                                get: { themeManager.currentTheme == .dark },
//                                set: { isDark in
//                                    themeManager.currentTheme = isDark ? .dark : .default
//                                }
//                            ))
//                            .labelsHidden()
//                        }
//                        .padding()
//                        
//                        Divider().padding(.leading, 50)
//                        
//                        // Help & Support
//                        NavigationLink(destination: Text("Help & Support").navigationTitle("Help")) {
//                            HStack {
//                                Image(systemName: "questionmark.circle")
//                                    .foregroundColor(.blue)
//                                    .frame(width: 30)
//                                Text("Help & Support")
//                                Spacer()
//                                Image(systemName: "chevron.right")
//                                    .font(.caption)
//                                    .foregroundColor(.gray)
//                            }
//                            .padding()
//                        }
//                    }
//                    .background(Color(.systemBackground))
//                    .cornerRadius(12)
//                }
//                
//                // Logout
//                Button {
//                    showingLogoutAlert = true
//                } label: {
//                    Text("Logout")
//                        .fontWeight(.semibold)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.red)
//                        .foregroundColor(.white)
//                        .cornerRadius(12)
//                }
//                .padding(.top, 8)
//            }
//            .padding()
//        }
//        .background(Color(.systemGroupedBackground))
//        .sheet(isPresented: $showingStats) {
//            ReadingStatsView()
//        }
//        .sheet(isPresented: $showingTheme) {
//            ThemeSettingsView()
//                .environmentObject(themeManager)
//        }
//        .alert("Logout", isPresented: $showingLogoutAlert) {
//            Button("Cancel", role: .cancel) { }
//            Button("Logout", role: .destructive) {
//                viewModel.logout()
//            }
//        } message: {
//            Text("Are you sure you want to logout?")
//        }
//    }
//}
//
//// MARK: - Stats Preview Cards
//struct StatsPreviewCards: View {
//    @StateObject private var statsVM = StatsViewModel()
//    
//    var body: some View {
//        LazyVGrid(columns: [
//            GridItem(.flexible()),
//            GridItem(.flexible()),
//            GridItem(.flexible())
//        ], spacing: 12) {
//            StatCard(
//                value: "\(statsVM.finishedCount)",
//                title: "Finished",
//                icon: "checkmark.circle.fill",
//                color: .green
//            )
//            
//            StatCard(
//                value: "\(statsVM.readingCount)",
//                title: "Reading",
//                icon: "book.fill",
//                color: .blue
//            )
//            
//            StatCard(
//                value: "\(statsVM.streakCount)",
//                title: "Streak",
//                icon: "flame.fill",
//                color: .orange
//            )
//        }
//        .onAppear {
//            statsVM.loadStats()
//        }
//        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("CoreDataDataChanged"))) { _ in
//            statsVM.loadStats()
//        }
//    }
//}
//// MARK: - Stat Card
//struct StatCard: View {
//    let value: String
//    let title: String
//    let icon: String
//    let color: Color
//    
//    var body: some View {
//        VStack(spacing: 8) {
//            Image(systemName: icon)
//                .foregroundColor(color)
//            
//            Text(value)
//                .font(.title2)
//                .fontWeight(.bold)
//            
//            Text(title)
//                .font(.caption)
//                .foregroundColor(.secondary)
//        }
//        .frame(maxWidth: .infinity)
//        .padding()
//        .background(Color(.systemBackground))
//        .cornerRadius(12)
//    }
//}


//
//  HomeView.swift
//  BookLibrary
//
//  Created by macos on 24/2/26.
//

//
//  HomeView.swift
//  BookLibrary
//
//  Created by macos on 24/2/26.
//
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

    private var isDarkMode: Bool {
        themeManager.currentTheme == .dark
    }

    private var pageBackground: Color {
        isDarkMode ? Color(red: 0.08, green: 0.09, blue: 0.11) : Color(red: 0.97, green: 0.95, blue: 0.90)
    }

    private var surfaceColor: Color {
        isDarkMode ? Color(red: 0.14, green: 0.15, blue: 0.18) : Color(red: 1.00, green: 0.98, blue: 0.95)
    }

    private var fieldColor: Color {
        isDarkMode ? Color(red: 0.20, green: 0.21, blue: 0.25) : Color(red: 0.98, green: 0.96, blue: 0.91)
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
        accent.opacity(isDarkMode ? 0.18 : 0.12)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                pageBackground
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    customHeader

                    TabView(selection: $homeViewModel.selectedTab) {
                        BookListView()
                            .tag(0)

                        FavoritesView()
                            .tag(1)

                        ProfileView(viewModel: viewModel)
                            .tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }

                if homeViewModel.showMenu {
                    sideMenuOverlay
                }
            }
        }
        .preferredColorScheme(themeManager.currentTheme.colorScheme)
    }
    
    // MARK: - Custom Header
    private var customHeader: some View {
        HStack(spacing: 14) {
            Button {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    homeViewModel.showMenu.toggle()
                }
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(primaryText)
                    .frame(width: 44, height: 44)
                    .background(fieldColor)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(borderColor, lineWidth: 1))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(titleForTab(homeViewModel.selectedTab))
                    .font(.system(size: 18, weight: .semibold, design: .serif))
                    .foregroundColor(primaryText)
                Text("BookLibrary")
                    .font(.system(size: 11, design: .rounded))
                    .foregroundColor(secondaryText)
            }

            Spacer()

            Color.clear.frame(width: 44, height: 44)
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .padding(.bottom, 4)
        .background(surfaceColor)
        .overlay(
            Divider()
                .background(borderColor),
            alignment: .bottom
        )
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
        accent.opacity(isDarkMode ? 0.18 : 0.12)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                profileHero

                quickActionCard

                StatsPreviewCards()

                settingsCard

                logoutButton
            }
            .padding()
        }
        .background(pageBackground.ignoresSafeArea())
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

    private var profileHero: some View {
        VStack(spacing: 16) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(accentSoft)
                        .frame(width: 76, height: 76)

                    Text(viewModel.profile?.name.prefix(1).uppercased() ?? "U")
                        .font(.system(size: 30, weight: .semibold, design: .serif))
                        .foregroundColor(accent)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.profile?.name ?? "User Name")
                        .font(.system(size: 22, weight: .semibold, design: .serif))
                        .foregroundColor(primaryText)

                    Text(viewModel.user?.email ?? "email@example.com")
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(secondaryText)
                        .lineLimit(1)

                    if let country = viewModel.profile?.country {
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

            NavigationLink(destination: EditProfileView(viewModel: viewModel)) {
                HStack(spacing: 8) {
                    Image(systemName: "pencil")
                        .font(.system(size: 12, weight: .semibold))
                    Text("Edit Profile")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                }
                .foregroundColor(accent)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Capsule().stroke(accent, lineWidth: 1))
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .background(cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(borderColor, lineWidth: 1)
        )
        .cornerRadius(16)
    }

    private var quickActionCard: some View {
        Button(action: { showingStats = true }) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Reading Statistics")
                        .font(.system(size: 16, weight: .semibold, design: .serif))
                        .foregroundColor(primaryText)

                    Text("View your reading progress")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(secondaryText)
                }

                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(accentSoft)
                        .frame(width: 38, height: 38)
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 16))
                        .foregroundColor(accent)
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(secondaryText)
            }
            .padding(16)
            .background(fieldBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(borderColor, lineWidth: 1)
            )
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }

    private var settingsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("SETTINGS")
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundColor(secondaryText)
                .tracking(1.1)
                .padding(.leading, 6)

            VStack(spacing: 0) {
                NavigationLink(destination: EditProfileView(viewModel: viewModel)) {
                    settingsRow(icon: "pencil", title: "Edit Profile") {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(secondaryText)
                    }
                }

              

                Divider().padding(.leading, 52)

                settingsRow(icon: themeManager.currentTheme == .dark ? "moon.fill" : "sun.max.fill", title: "Dark Mode") {
                    Toggle("", isOn: Binding(
                        get: { themeManager.currentTheme == .dark },
                        set: { isDark in
                            themeManager.currentTheme = isDark ? .dark : .default
                        }
                    ))
                    .labelsHidden()
                    .tint(accent)
                }

                Divider().padding(.leading, 52)

                NavigationLink(destination: RateAppView(authViewModel: viewModel)) {
                    settingsRow(icon: "star.fill", title: "Rate My App") {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(secondaryText)
                    }
                }
            }
            .background(cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(borderColor, lineWidth: 1)
            )
            .cornerRadius(12)
        }
    }

    @ViewBuilder
    private func settingsRow<T: View>(icon: String, title: String, @ViewBuilder trailing: () -> T) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(accentSoft)
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(accent)
            }

            Text(title)
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(primaryText)

            Spacer()

            trailing()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 13)
    }

    private var logoutButton: some View {
        Button {
            showingLogoutAlert = true
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 14, weight: .semibold))
                Text("Logout")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color(red: 0.82, green: 0.35, blue: 0.35))
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Stats Preview Cards
struct StatsPreviewCards: View {
    @StateObject private var statsVM = StatsViewModel()
    @EnvironmentObject var themeManager: ThemeManager

    private var isDarkMode: Bool {
        themeManager.currentTheme == .dark
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("READING SNAPSHOT")
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundColor(secondaryText)
                .tracking(1.1)
                .padding(.leading, 6)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                StatCard(
                    value: "\(statsVM.finishedCount)",
                    title: "Finished",
                    icon: "checkmark.circle.fill",
                    color: Color(red: 0.18, green: 0.56, blue: 0.31)
                )

                StatCard(
                    value: "\(statsVM.readingCount)",
                    title: "Reading",
                    icon: "book.fill",
                    color: Color(red: 0.18, green: 0.38, blue: 0.26)
                )

                StatCard(
                    value: "\(statsVM.streakCount)",
                    title: "Streak",
                    icon: "flame.fill",
                    color: Color(red: 0.73, green: 0.42, blue: 0.11)
                )
            }
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

    @EnvironmentObject var themeManager: ThemeManager

    private var isDarkMode: Bool {
        themeManager.currentTheme == .dark
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
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(primaryText)
            
            Text(title)
                .font(.caption)
                .foregroundColor(secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(borderColor, lineWidth: 1)
        )
        .cornerRadius(12)
    }
}
