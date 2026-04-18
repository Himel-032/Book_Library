//
//  ReadingStats.swift
//  BookLibrary
//
//  Created by [Your Name] on [Date].
//

import Foundation
import SwiftUI

struct ReadingStats {
    let totalBooksRead: Int      // Finished books
    let totalPagesRead: Int      // Pages from finished books
    let favoriteAuthor: String
    let favoriteCategory: String
    let readingStreak: Int
    let booksByMonth: [MonthData]
    let categoryBreakdown: [CategoryCount]
    let startDate: Date
    let dailyAverage: Double
    let currentlyReading: Int    // Favorites not finished
    
    struct MonthData: Identifiable {
        let id = UUID()
        let month: String
        let count: Int
    }
    
    struct CategoryCount: Identifiable {
        let id = UUID()
        let category: String
        let count: Int
        let color: String
    }
    
    // Empty stats for preview
    static var empty: ReadingStats {
        ReadingStats(
            totalBooksRead: 0,
            totalPagesRead: 0,
            favoriteAuthor: "None yet",
            favoriteCategory: "None yet",
            readingStreak: 0,
            booksByMonth: [],
            categoryBreakdown: [],
            startDate: Date(),
            dailyAverage: 0,
            currentlyReading: 0
        )
    }
}
