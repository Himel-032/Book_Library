//
//  ThemeManager.swift
//  BookLibrary
//
//  Created by [Your Name] on [Date].
//

import SwiftUI

enum AppTheme: String, CaseIterable {
    case `default` = "Default"  // Light mode
    case dark = "Dark"
    
    var displayName: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .default: return "sun.max.fill"
        case .dark: return "moon.fill"
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .default: return .light
        case .dark: return .dark
        }
    }
}

class ThemeManager: ObservableObject {
    @Published var currentTheme: AppTheme {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: "appTheme")
            applyTheme()
        }
    }
    
    init() {
        // Try to load saved theme, default to .default (light) if none exists
        let savedTheme = UserDefaults.standard.string(forKey: "appTheme")
        self.currentTheme = AppTheme(rawValue: savedTheme ?? "") ?? .default
        applyTheme()
    }
    
    private func applyTheme() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = currentTheme.colorScheme == .dark ? .dark : .light
            }
        }
    }
}
