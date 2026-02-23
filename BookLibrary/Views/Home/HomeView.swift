//
//  HomeView.swift
//  BookLibrary
//
//  Created by Himel on 23/2/26.
//

//import SwiftUI
//
//struct HomeView: View {
//    
//    @StateObject var viewModel = AuthViewModel()
//    @State private var showMenu = false
//    
//    var body: some View {
//        ZStack {
//            
//            // Main Content
//            NavigationView {
//                VStack {
//                    Text("Home Screen")
//                        .font(.title)
//                    
//                    Spacer()
//                }
//                .navigationTitle("Home")
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button(action: {
//                            withAnimation {
//                                showMenu.toggle()
//                            }
//                        }) {
//                            Image(systemName: "line.3.horizontal")
//                        }
//                    }
//                }
//            }
//            
//            // Side Menu Overlay
//            if showMenu {
//                HStack {
//                    SideMenuView(viewModel: viewModel)
//                        .frame(width: 250)
//                        .background(Color(.systemGray6))
//                        .transition(.move(edge: .leading))
//                    
//                    Spacer()
//                }
//                .background(
//                    Color.black.opacity(0.3)
//                        .onTapGesture {
//                            withAnimation {
//                                showMenu = false
//                            }
//                        }
//                )
//            }
//        }
//    }
//}
import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel = AuthViewModel()
    @State private var showMenu = false
    
    var body: some View {
        
        NavigationView {   // 👈 MOVE HERE
            
            ZStack {
                
                // Main Content
                VStack {
                    Text("Home Screen")
                        .font(.title)
                    
                    Spacer()
                }
                .navigationTitle("Home")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            withAnimation {
                                showMenu.toggle()
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal")
                        }
                    }
                }
                
                // Side Menu
                if showMenu {
                    HStack {
                        SideMenuView(viewModel: viewModel)
                            .frame(width: 250)
                            .background(Color(.systemGray6))
                            .transition(.move(edge: .leading))
                        
                        Spacer()
                    }
                    .background(
                        Color.black.opacity(0.3)
                            .onTapGesture {
                                withAnimation {
                                    showMenu = false
                                }
                            }
                    )
                }
            }
        }
    }
}
