//
//  ThemedViewModifier.swift
//  BookLibrary
//
//  Created by [Your Name] on [Date].
//

import SwiftUI

struct ThemedViewModifier: ViewModifier {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    func body(content: Content) -> some View {
        content
            .background(Color(.systemBackground))
            .foregroundColor(Color(.label))
    }
}

extension View {
    func applyTheme() -> some View {
        self.modifier(ThemedViewModifier())
    }
}
