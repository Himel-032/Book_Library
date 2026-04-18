//
//  StatsViewModel.swift
//  BookLibrary
//
//  Created by [Your Name] on [Date].
//

import Foundation
import Combine

class StatsViewModel: ObservableObject {
    
    @Published var finishedCount: Int = 0
    @Published var readingCount: Int = 0
    @Published var streakCount: Int = 0
    @Published var isLoading = false
    
    private let coreDataManager = CoreDataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Listen for Core Data changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dataChanged),
            name: NSNotification.Name("CoreDataDataChanged"),
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func dataChanged() {
        loadStats()
    }
    
    func loadStats() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            // Get stats from CoreDataManager - returns (Int, Int, Int)
            let stats = self?.coreDataManager.getAllStats() ?? (0, 0, 0)
            
            DispatchQueue.main.async {
                // FIXED: Access tuple elements by position
                self?.finishedCount = stats.0
                self?.readingCount = stats.1
                self?.streakCount = stats.2
                self?.isLoading = false
                
                print("📊 Stats updated - Finished: \(stats.0), Reading: \(stats.1), Streak: \(stats.2)")
            }
        }
    }
    
    // Alternative: Using named tuple for better readability
    func loadStatsWithNamedTuple() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            // Destructure the tuple into named variables
            let (finished, reading, streak) = self?.coreDataManager.getAllStats() ?? (0, 0, 0)
            
            DispatchQueue.main.async {
                self?.finishedCount = finished
                self?.readingCount = reading
                self?.streakCount = streak
                self?.isLoading = false
            }
        }
    }
    
    // Force refresh stats
    func refreshStats() {
        loadStats()
    }
}
