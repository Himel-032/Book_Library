//
//  ThemeSettingsView.swift
//  BookLibrary
//
//  Created by [Your Name] on [Date].
//

import SwiftUI

struct ThemeSettingsView: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(AppTheme.allCases, id: \.self) { theme in
                        Button(action: {
                            themeManager.currentTheme = theme
                        }) {
                            HStack {
                                // Theme icon
                                Image(systemName: theme.icon)
                                    .foregroundColor(theme == .dark ? .purple : .orange)
                                    .frame(width: 30)
                                
                                Text(theme.displayName)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if themeManager.currentTheme == theme {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                } header: {
                    Text("Choose Theme")
                } footer: {
                    Text("Default theme is light mode")
                }
            }
            .navigationTitle("App Theme")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
