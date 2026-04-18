//
//  ReadingStatsView.swift
//  BookLibrary
//
//  Created by [Your Name] on [Date].
//

import SwiftUI

struct ReadingStatsView: View {
    
    @StateObject private var viewModel = StatsViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    if viewModel.isLoading {
                        ProgressView("Loading stats...")
                            .padding()
                    } else {
                        // Header Stats
                        headerStatsSection
                        
                        Divider()
                        
                        // Detailed Stats
                        detailedStatsSection
                        
                        Divider()
                        
                        // Reading Streak
                        streakSection
                    }
                }
                .padding()
            }
            .navigationTitle("Reading Stats")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadStats()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("CoreDataDataChanged"))) { _ in
            viewModel.loadStats()
        }
    }
    
    // MARK: - Header Stats Section
    private var headerStatsSection: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            StatsCardView(
                title: "Finished Books",
                value: "\(viewModel.finishedCount)",
                icon: "checkmark.circle.fill",
                color: .green
            )
            
            StatsCardView(
                title: "Currently Reading",
                value: "\(viewModel.readingCount)",
                icon: "book.fill",
                color: .blue
            )
        }
    }
    
    // MARK: - Detailed Stats Section
    private var detailedStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Reading Progress")
                .font(.headline)
            
            HStack {
                StatItem(
                    title: "Finished",
                    value: viewModel.finishedCount,
                    icon: "checkmark.circle.fill",
                    color: .green
                )
                
                Divider()
                    .frame(height: 50)
                
                StatItem(
                    title: "Reading",
                    value: viewModel.readingCount,
                    icon: "book.fill",
                    color: .blue
                )
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - Streak Section
    private var streakSection: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 8) {
                Image(systemName: "flame.fill")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
                
                Text("\(viewModel.streakCount)")
                    .font(.system(size: 40, weight: .bold))
                
                Text("Day Streak")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Stat Item Component
struct StatItem: View {
    let title: String
    let value: Int
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text("\(value)")
                .font(.title)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Stats Card View Component
struct StatsCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
                
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
