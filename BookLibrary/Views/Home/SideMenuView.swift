//
//  SideMenuView.swift
//  BookLibrary
//
//  Created by Himel on 23/2/26.
//

//import SwiftUI
//
//struct SideMenuView: View {
//    
//    @ObservedObject var viewModel: AuthViewModel
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 20) {
//
//            VStack(alignment: .leading) {
//                Image(systemName: "person.circle")
//                    .resizable()
//                    .frame(width: 60, height: 60)
//
//                Text(viewModel.user?.email ?? "User")
//                    .font(.headline)
//
//                Text(viewModel.profile?.name ?? "No Name")
//                    .font(.subheadline)
//
//                Text(viewModel.profile?.country ?? "No Country")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//            .padding(.top, 40)
//
//            Divider()
//
//            // Edit Profile
//            NavigationLink(destination: EditProfileView(viewModel: viewModel)) {
//                HStack {
//                    Image(systemName: "pencil")
//                    Text("Edit Profile")
//                }
//            }
//
//            Spacer()
//
//            // Logout
//            Button(action: {
//                viewModel.logout()
//            }) {
//                HStack {
//                    Image(systemName: "arrow.backward.circle")
//                    Text("Logout")
//                }
//                .foregroundColor(.red)
//            }
//            .padding(.bottom, 30)
//        }
//        .padding()
//        .frame(maxWidth: .infinity, alignment: .leading)
//    }
//}

import SwiftUI

struct SideMenuView: View {
    
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // Profile Card
            VStack(alignment: .leading, spacing: 10) {
                
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.blue)
                
                Text(viewModel.user?.email ?? "User")
                    .font(.headline)
                
                Text(viewModel.profile?.name ?? "No Name")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(viewModel.profile?.country ?? "No Country")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
            )
            
            Divider()
                .padding(.vertical, 10)
            
            // Menu Items
            VStack(alignment: .leading, spacing: 18) {
                
                NavigationLink(destination: EditProfileView(viewModel: viewModel)) {
                    menuItem(icon: "pencil", title: "Edit Profile")
                }
                
                NavigationLink(destination: HomeView()) {
                    menuItem(icon: "book.closed", title: "Library Home")
                }
                
//                NavigationLink(destination: FavoritesView()) {
//                    menuItem(icon: "heart", title: "Favorites")
//                }
//                
//                NavigationLink(destination: SettingsView()) {
//                    menuItem(icon: "gearshape", title: "Settings")
//                }
            }
            
            Spacer()
            
            // Logout Button
            Button(action: {
                viewModel.logout()
            }) {
                HStack {
                    Image(systemName: "arrow.backward.circle")
                    Text("Logout")
                }
                .foregroundColor(.red)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.red.opacity(0.1))
                )
            }
            .padding(.bottom, 20)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // Menu Item Style
    private func menuItem(icon: String, title: String) -> some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24)
            Text(title)
        }
        .padding(.vertical, 6)
    }
}
