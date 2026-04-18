//
//  HomeViewModel.swift
//  BookLibrary
//
//  Created by macos on 26/2/26.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var selectedTab = 0
    @Published var showMenu = false
}
