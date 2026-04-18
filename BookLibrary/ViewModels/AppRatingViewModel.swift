//
//  AppRatingViewModel.swift
//  BookLibrary
//
//  Created by Himel on 13/4/26.
//
import Foundation
import FirebaseFirestore

final class AppRatingViewModel: ObservableObject {

    @Published var averageRating: Double = 0
    @Published var totalRatings: Int = 0
    @Published var userRating: Int = 0
    @Published var isSubmitting = false
    @Published var message: String?

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    deinit {
        listener?.remove()
    }

    func startListening(currentUserId: String) {
        listener?.remove()

        listener = db.collection("app_ratings")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self else { return }

                if let error {
                    DispatchQueue.main.async {
                        self.message = "Failed to load ratings: \(error.localizedDescription)"
                    }
                    return
                }

                guard let documents = snapshot?.documents else {
                    DispatchQueue.main.async {
                        self.averageRating = 0
                        self.totalRatings = 0
                        self.userRating = 0
                    }
                    return
                }

                var sum = 0
                var count = 0
                var currentUserValue = 0

                for doc in documents {
                    let value = doc.data()["rating"] as? Int ?? 0
                    guard (1...5).contains(value) else { continue }

                    sum += value
                    count += 1

                    if doc.documentID == currentUserId {
                        currentUserValue = value
                    }
                }

                let avg = count == 0 ? 0 : Double(sum) / Double(count)

                DispatchQueue.main.async {
                    self.averageRating = avg
                    self.totalRatings = count
                    self.userRating = currentUserValue
                }
            }
    }

    func submitRating(_ rating: Int, userId: String, completion: ((Bool) -> Void)? = nil) {
        guard (1...5).contains(rating) else {
            message = "Please select a rating between 1 and 5."
            completion?(false)
            return
        }

        isSubmitting = true
        message = nil

        let payload: [String: Any] = [
            "rating": rating,
            "updatedAt": FieldValue.serverTimestamp()
        ]

        db.collection("app_ratings")
            .document(userId)
            .setData(payload, merge: true) { [weak self] error in
                guard let self else { return }

                DispatchQueue.main.async {
                    self.isSubmitting = false
                    if let error {
                        self.message = "Rating failed: \(error.localizedDescription)"
                        completion?(false)
                    } else {
                        self.message = "Thanks for rating the app!"
                        completion?(true)
                    }
                }
            }
    }
}
