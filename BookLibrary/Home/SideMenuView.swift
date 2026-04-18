//
//  SideMenuView.swift
//  BookLibrary
//
//  Created by macos on 24/2/26.
//

//
//import SwiftUI
//
//struct SideMenuView: View {
//
//    @ObservedObject var viewModel: AuthViewModel
//    @ObservedObject var homeViewModel: HomeViewModel
//    @EnvironmentObject var themeManager: ThemeManager
//    @State private var showingTheme = false
//
//    // ── Light-Mode Palette ──
//    let parchment   = Color(red: 0.97, green: 0.95, blue: 0.90)
//    let paper       = Color(red: 1.00, green: 0.98, blue: 0.95)
//    let forest      = Color(red: 0.18, green: 0.38, blue: 0.26)
//    let amber       = Color(red: 0.73, green: 0.42, blue: 0.11)
//    let amberLight  = Color(red: 0.98, green: 0.91, blue: 0.78)
//    let ink         = Color(red: 0.16, green: 0.14, blue: 0.12)
//    let inkMuted    = Color(red: 0.45, green: 0.41, blue: 0.36)
//    let border      = Color(red: 0.86, green: 0.81, blue: 0.73)
//    let dustyRose   = Color(red: 0.82, green: 0.35, blue: 0.35)
//
//    var body: some View {
//        ZStack {
//            parchment.ignoresSafeArea()
//
//            VStack(spacing: 0) {
//                LinearGradient(
//                    colors: [amberLight.opacity(0.55), parchment.opacity(0)],
//                    startPoint: .top,
//                    endPoint: .bottom
//                )
//                .frame(height: 220)
//                Spacer()
//            }
//            .ignoresSafeArea()
//
//            ScrollView(showsIndicators: false) {
//                VStack(alignment: .leading, spacing: 0) {
//                    Spacer().frame(height: 54)
//                    appBrand
//                    Spacer().frame(height: 26)
//                    profileCard
//                    Spacer().frame(height: 28)
//                    sectionHeader("Navigation")
//                    Spacer().frame(height: 10)
//                    navItem(icon: "books.vertical.fill", title: "My Library", tab: 0)
//                    navItem(icon: "heart.fill",          title: "Favourites", tab: 1)
//                    navItem(icon: "person.fill",         title: "Profile",    tab: 2)
//                    Spacer().frame(height: 28)
//                    sectionHeader("Settings")
//                    Spacer().frame(height: 10)
//                    settingsBlock
//                    Spacer().frame(height: 28)
//                    logoutButton
//                    Spacer().frame(height: 44)
//                }
//                .padding(.horizontal, 20)
//            }
//        }
//        .sheet(isPresented: $showingTheme) {
//            ThemeSettingsView().environmentObject(themeManager)
//        }
//    }
//
//    // MARK: - Brand
//    private var appBrand: some View {
//        HStack(spacing: 12) {
//            ZStack {
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(forest)
//                    .frame(width: 42, height: 42)
//                    .shadow(color: forest.opacity(0.3), radius: 6, y: 3)
//                Image(systemName: "books.vertical.fill")
//                    .font(.system(size: 18))
//                    .foregroundColor(.white)
//            }
//            VStack(alignment: .leading, spacing: 2) {
//                Text("BookLibrary")
//                    .font(.system(size: 17, weight: .semibold, design: .serif))
//                    .foregroundColor(ink)
//                Text("Your reading companion")
//                    .font(.system(size: 10, design: .rounded))
//                    .foregroundColor(inkMuted)
//            }
//        }
//    }
//
//    // MARK: - Profile Card
//    private var profileCard: some View {
//        VStack(alignment: .leading, spacing: 14) {
//            HStack(spacing: 14) {
//                ZStack {
//                    Circle()
//                        .fill(forest.opacity(0.10))
//                        .frame(width: 52, height: 52)
//                    Circle()
//                        .stroke(forest.opacity(0.28), lineWidth: 1.5)
//                        .frame(width: 52, height: 52)
//                    Text(viewModel.profile?.name.prefix(1).uppercased() ?? "U")
//                        .font(.system(size: 22, weight: .semibold, design: .serif))
//                        .foregroundColor(forest)
//                }
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(viewModel.profile?.name ?? "Reader")
//                        .font(.system(size: 15, weight: .semibold, design: .serif))
//                        .foregroundColor(ink)
//                    Text(viewModel.user?.email ?? "email@example.com")
//                        .font(.system(size: 11, design: .rounded))
//                        .foregroundColor(inkMuted)
//                        .lineLimit(1)
//                }
//                Spacer()
//            }
//            if let country = viewModel.profile?.country {
//                HStack(spacing: 5) {
//                    Image(systemName: "location.fill")
//                        .font(.system(size: 9))
//                        .foregroundColor(amber)
//                    Text(country)
//                        .font(.system(size: 11, design: .rounded))
//                        .foregroundColor(inkMuted)
//                }
//            }
//            Rectangle()
//                .fill(LinearGradient(colors: [amber.opacity(0.5), .clear], startPoint: .leading, endPoint: .trailing))
//                .frame(height: 1.5).cornerRadius(1)
//        }
//        .padding(16)
//        .background(RoundedRectangle(cornerRadius: 18).fill(paper).shadow(color: .black.opacity(0.07), radius: 8, y: 3))
//        .overlay(RoundedRectangle(cornerRadius: 18).stroke(border, lineWidth: 1))
//    }
//
//    // MARK: - Nav Item
//    private func navItem(icon: String, title: String, tab: Int) -> some View {
//        let active = homeViewModel.selectedTab == tab
//        return Button(action: {
//            withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
//                homeViewModel.selectedTab = tab
//                homeViewModel.showMenu = false
//            }
//        }) {
//            HStack(spacing: 13) {
//                ZStack {
//                    RoundedRectangle(cornerRadius: 10)
//                        .fill(active ? forest : Color.black.opacity(0.05))
//                        .frame(width: 36, height: 36)
//                        .shadow(color: active ? forest.opacity(0.28) : .clear, radius: 5, y: 2)
//                    Image(systemName: icon)
//                        .font(.system(size: 15))
//                        .foregroundColor(active ? .white : inkMuted)
//                }
//                Text(title)
//                    .font(.system(size: 15, weight: active ? .semibold : .regular, design: .serif))
//                    .foregroundColor(active ? forest : inkMuted)
//                Spacer()
//                if active {
//                    RoundedRectangle(cornerRadius: 2).fill(amber).frame(width: 4, height: 22)
//                }
//            }
//            .padding(.horizontal, 12).padding(.vertical, 10)
//            .background(
//                RoundedRectangle(cornerRadius: 14)
//                    .fill(active ? forest.opacity(0.07) : .clear)
//                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(active ? forest.opacity(0.16) : .clear, lineWidth: 1))
//            )
//        }
//        .buttonStyle(.plain)
//        .padding(.bottom, 4)
//    }
//
//    // MARK: - Settings Block
//    private var settingsBlock: some View {
//        VStack(spacing: 0) {
//            NavigationLink {
//                EditProfileView(viewModel: viewModel).onAppear { homeViewModel.showMenu = false }
//            } label: {
//                settingsRow(icon: "pencil", bg: forest.opacity(0.10), fg: forest, title: "Edit Profile") { chevron }
//            }.buttonStyle(.plain)
//
//            Divider().padding(.leading, 54)
//
//            settingsRow(icon: themeManager.currentTheme == .dark ? "moon.fill" : "sun.max.fill", bg: amber.opacity(0.13), fg: amber, title: "Dark Mode") {
//                Toggle("", isOn: Binding(
//                    get: { themeManager.currentTheme == .dark },
//                    set: { themeManager.currentTheme = $0 ? .dark : .default }
//                ))
//                .labelsHidden().tint(forest).scaleEffect(0.85)
//            }
//
//            Divider().padding(.leading, 54)
//
//            NavigationLink {
//                RateAppView(authViewModel: viewModel).onAppear { homeViewModel.showMenu = false }
//            } label: {
//                settingsRow(icon: "star.fill", bg: amber.opacity(0.14), fg: amber, title: "Rate My App") { chevron }
//            }.buttonStyle(.plain)
//        }
//        .background(RoundedRectangle(cornerRadius: 18).fill(paper).shadow(color: .black.opacity(0.06), radius: 8, y: 3))
//        .overlay(RoundedRectangle(cornerRadius: 18).stroke(border, lineWidth: 1))
//    }
//
//    @ViewBuilder
//    private func settingsRow<T: View>(icon: String, bg: Color, fg: Color, title: String, @ViewBuilder trailing: () -> T) -> some View {
//        HStack(spacing: 13) {
//            ZStack {
//                RoundedRectangle(cornerRadius: 8).fill(bg).frame(width: 32, height: 32)
//                Image(systemName: icon).font(.system(size: 14)).foregroundColor(fg)
//            }
//            Text(title).font(.system(size: 14, design: .rounded)).foregroundColor(ink)
//            Spacer()
//            trailing()
//        }
//        .padding(.horizontal, 14).padding(.vertical, 13)
//    }
//
//    private var chevron: some View {
//        Image(systemName: "chevron.right")
//            .font(.system(size: 10, weight: .semibold))
//            .foregroundColor(inkMuted.opacity(0.5))
//    }
//
//    // MARK: - Logout
//    private var logoutButton: some View {
//        Button(action: { viewModel.logout() }) {
//            HStack(spacing: 13) {
//                ZStack {
//                    RoundedRectangle(cornerRadius: 8).fill(dustyRose.opacity(0.10)).frame(width: 32, height: 32)
//                    Image(systemName: "rectangle.portrait.and.arrow.right").font(.system(size: 14)).foregroundColor(dustyRose)
//                }
//                Text("Sign Out").font(.system(size: 14, weight: .semibold, design: .rounded)).foregroundColor(dustyRose)
//                Spacer()
//            }
//            .padding(.horizontal, 14).padding(.vertical, 13)
//            .background(RoundedRectangle(cornerRadius: 16).fill(dustyRose.opacity(0.07)).overlay(RoundedRectangle(cornerRadius: 16).stroke(dustyRose.opacity(0.2), lineWidth: 1)))
//        }
//        .buttonStyle(.plain)
//    }
//
//    // MARK: - Section Header
//    private func sectionHeader(_ title: String) -> some View {
//        HStack(spacing: 7) {
//            Rectangle().fill(amber).frame(width: 3, height: 11).cornerRadius(2)
//            Text(title.uppercased())
//                .font(.system(size: 9, weight: .semibold, design: .rounded))
//                .foregroundColor(inkMuted)
//                .tracking(1.8)
//        }
//        .padding(.leading, 2)
//    }
//}




import SwiftUI

struct SideMenuView: View {

    @ObservedObject var viewModel: AuthViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingTheme = false
    @StateObject private var recommendationViewModel = RecommendationViewModel()

    // ── Light-Mode Palette ──
    let parchment   = Color(red: 0.97, green: 0.95, blue: 0.90)
    let paper       = Color(red: 1.00, green: 0.98, blue: 0.95)
    let forest      = Color(red: 0.18, green: 0.38, blue: 0.26)
    let amber       = Color(red: 0.73, green: 0.42, blue: 0.11)
    let amberLight  = Color(red: 0.98, green: 0.91, blue: 0.78)
    let ink         = Color(red: 0.16, green: 0.14, blue: 0.12)
    let inkMuted    = Color(red: 0.45, green: 0.41, blue: 0.36)
    let border      = Color(red: 0.86, green: 0.81, blue: 0.73)
    let dustyRose   = Color(red: 0.82, green: 0.35, blue: 0.35)

    var body: some View {
        ZStack {
            parchment.ignoresSafeArea()

            VStack(spacing: 0) {
                LinearGradient(
                    colors: [amberLight.opacity(0.55), parchment.opacity(0)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 220)
                Spacer()
            }
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Spacer().frame(height: 54)
                    appBrand
                    Spacer().frame(height: 26)
                    profileCard
                    Spacer().frame(height: 28)
                    sectionHeader("Navigation")
                    Spacer().frame(height: 10)
                    navItem(icon: "books.vertical.fill", title: "My Library", tab: 0)
                    navItem(icon: "heart.fill",          title: "Favourites", tab: 1)
                    navItem(icon: "person.fill",         title: "Profile",    tab: 2)
                    recommendationsMenuItem
                    Spacer().frame(height: 28)
                    sectionHeader("Settings")
                    Spacer().frame(height: 10)
                    settingsBlock
                    Spacer().frame(height: 28)
                    logoutButton
                    Spacer().frame(height: 44)
                }
                .padding(.horizontal, 20)
            }
        }
        .sheet(isPresented: $showingTheme) {
            ThemeSettingsView().environmentObject(themeManager)
        }
        .onAppear {
            recommendationViewModel.loadRecommendations(for: viewModel.currentUserId)
        }
    }

    // MARK: - Brand
    private var appBrand: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(forest)
                    .frame(width: 42, height: 42)
                    .shadow(color: forest.opacity(0.3), radius: 6, y: 3)
                Image(systemName: "books.vertical.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("BookLibrary")
                    .font(.system(size: 17, weight: .semibold, design: .serif))
                    .foregroundColor(ink)
                Text("Your reading companion")
                    .font(.system(size: 10, design: .rounded))
                    .foregroundColor(inkMuted)
            }
        }
    }

    // MARK: - Profile Card
    private var profileCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(forest.opacity(0.10))
                        .frame(width: 52, height: 52)
                    Circle()
                        .stroke(forest.opacity(0.28), lineWidth: 1.5)
                        .frame(width: 52, height: 52)
                    Text(viewModel.profile?.name.prefix(1).uppercased() ?? "U")
                        .font(.system(size: 22, weight: .semibold, design: .serif))
                        .foregroundColor(forest)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.profile?.name ?? "Reader")
                        .font(.system(size: 15, weight: .semibold, design: .serif))
                        .foregroundColor(ink)
                    Text(viewModel.user?.email ?? "email@example.com")
                        .font(.system(size: 11, design: .rounded))
                        .foregroundColor(inkMuted)
                        .lineLimit(1)
                }
                Spacer()
            }
            if let country = viewModel.profile?.country {
                HStack(spacing: 5) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 9))
                        .foregroundColor(amber)
                    Text(country)
                        .font(.system(size: 11, design: .rounded))
                        .foregroundColor(inkMuted)
                }
            }
            Rectangle()
                .fill(LinearGradient(colors: [amber.opacity(0.5), .clear], startPoint: .leading, endPoint: .trailing))
                .frame(height: 1.5).cornerRadius(1)
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 18).fill(paper).shadow(color: .black.opacity(0.07), radius: 8, y: 3))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(border, lineWidth: 1))
    }

    // MARK: - Nav Item
    private func navItem(icon: String, title: String, tab: Int) -> some View {
        let active = homeViewModel.selectedTab == tab
        return Button(action: {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                homeViewModel.selectedTab = tab
                homeViewModel.showMenu = false
            }
        }) {
            HStack(spacing: 13) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(active ? forest : Color.black.opacity(0.05))
                        .frame(width: 36, height: 36)
                        .shadow(color: active ? forest.opacity(0.28) : .clear, radius: 5, y: 2)
                    Image(systemName: icon)
                        .font(.system(size: 15))
                        .foregroundColor(active ? .white : inkMuted)
                }
                Text(title)
                    .font(.system(size: 15, weight: active ? .semibold : .regular, design: .serif))
                    .foregroundColor(active ? forest : inkMuted)
                Spacer()
                if active {
                    RoundedRectangle(cornerRadius: 2).fill(amber).frame(width: 4, height: 22)
                }
            }
            .padding(.horizontal, 12).padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(active ? forest.opacity(0.07) : .clear)
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(active ? forest.opacity(0.16) : .clear, lineWidth: 1))
            )
        }
        .buttonStyle(.plain)
        .padding(.bottom, 4)
    }

    // MARK: - Settings Block
    private var settingsBlock: some View {
        VStack(spacing: 0) {
            NavigationLink {
                EditProfileView(viewModel: viewModel).onAppear { homeViewModel.showMenu = false }
            } label: {
                settingsRow(icon: "pencil", bg: forest.opacity(0.10), fg: forest, title: "Edit Profile") { chevron }
            }.buttonStyle(.plain)

            Divider().padding(.leading, 54)

            settingsRow(icon: themeManager.currentTheme == .dark ? "moon.fill" : "sun.max.fill", bg: amber.opacity(0.13), fg: amber, title: "Dark Mode") {
                Toggle("", isOn: Binding(
                    get: { themeManager.currentTheme == .dark },
                    set: { themeManager.currentTheme = $0 ? .dark : .default }
                ))
                .labelsHidden().tint(forest).scaleEffect(0.85)
            }

            Divider().padding(.leading, 54)

            NavigationLink {
                RateAppView(authViewModel: viewModel).onAppear { homeViewModel.showMenu = false }
            } label: {
                settingsRow(icon: "star.fill", bg: amber.opacity(0.14), fg: amber, title: "Rate My App") { chevron }
            }.buttonStyle(.plain)
        }
        .background(RoundedRectangle(cornerRadius: 18).fill(paper).shadow(color: .black.opacity(0.06), radius: 8, y: 3))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(border, lineWidth: 1))
    }

    private var recommendationsMenuItem: some View {
        NavigationLink {
            RecommendationsView(authViewModel: viewModel)
                .environmentObject(themeManager)
                .onAppear { homeViewModel.showMenu = false }
        } label: {
            HStack(spacing: 13) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.black.opacity(0.05))
                        .frame(width: 36, height: 36)
                    Image(systemName: "sparkles")
                        .font(.system(size: 15))
                        .foregroundColor(inkMuted)
                }

                Text("Recommendations")
                    .font(.system(size: 15, design: .serif))
                    .foregroundColor(inkMuted)

                Spacer()

                if recommendationViewModel.newRecommendationCount > 0 {
                    Text("\(recommendationViewModel.newRecommendationCount)")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 4)
                        .background(forest)
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.clear)
            )
        }
        .buttonStyle(.plain)
        .padding(.bottom, 4)
    }

    @ViewBuilder
    private func settingsRow<T: View>(icon: String, bg: Color, fg: Color, title: String, @ViewBuilder trailing: () -> T) -> some View {
        HStack(spacing: 13) {
            ZStack {
                RoundedRectangle(cornerRadius: 8).fill(bg).frame(width: 32, height: 32)
                Image(systemName: icon).font(.system(size: 14)).foregroundColor(fg)
            }
            Text(title).font(.system(size: 14, design: .rounded)).foregroundColor(ink)
            Spacer()
            trailing()
        }
        .padding(.horizontal, 14).padding(.vertical, 13)
    }

    private var chevron: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 10, weight: .semibold))
            .foregroundColor(inkMuted.opacity(0.5))
    }

    // MARK: - Logout
    private var logoutButton: some View {
        Button(action: { viewModel.logout() }) {
            HStack(spacing: 13) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8).fill(dustyRose.opacity(0.10)).frame(width: 32, height: 32)
                    Image(systemName: "rectangle.portrait.and.arrow.right").font(.system(size: 14)).foregroundColor(dustyRose)
                }
                Text("Sign Out").font(.system(size: 14, weight: .semibold, design: .rounded)).foregroundColor(dustyRose)
                Spacer()
            }
            .padding(.horizontal, 14).padding(.vertical, 13)
            .background(RoundedRectangle(cornerRadius: 16).fill(dustyRose.opacity(0.07)).overlay(RoundedRectangle(cornerRadius: 16).stroke(dustyRose.opacity(0.2), lineWidth: 1)))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Section Header
    private func sectionHeader(_ title: String) -> some View {
        HStack(spacing: 7) {
            Rectangle().fill(amber).frame(width: 3, height: 11).cornerRadius(2)
            Text(title.uppercased())
                .font(.system(size: 9, weight: .semibold, design: .rounded))
                .foregroundColor(inkMuted)
                .tracking(1.8)
        }
        .padding(.leading, 2)
    }
}
