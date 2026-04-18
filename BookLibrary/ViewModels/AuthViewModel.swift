//
//  AuthViewModel.swift
//  BookLibrary
//
//  Created by macos on 24/2/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    
    @Published var user: User?
    @Published var errorMessage: String?
    @Published var isAuthenticated = false
    @Published var profile: UserModel?
    
    init() {
        self.user = AuthService.shared.currentUser
        self.isAuthenticated = user != nil

        if let uid = user?.uid {
            // Set user in CoreData when app starts with logged in user
            CoreDataManager.shared.setCurrentUser(userId: uid)
            print("🔐 CoreData user set on init: \(uid)")
            fetchProfile(uid: uid)
        }
    }
    
    func signUp(email: String, password: String, name: String, country: String) {
        AuthService.shared.signUp(email: email, password: password, name: name, country: country) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.user = user
                    self.isAuthenticated = true
                    self.errorMessage = nil
                    
                    // Set user in CoreData on signup
                    CoreDataManager.shared.setCurrentUser(userId: user.uid)
                    print("🔐 CoreData user set on signup: \(user.uid)")
                    
                    self.fetchProfile(uid: user.uid)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func login(email: String, password: String) {
        AuthService.shared.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.user = user
                    self.isAuthenticated = true
                    self.errorMessage = nil
                    
                    // Set user in CoreData on login
                    CoreDataManager.shared.setCurrentUser(userId: user.uid)
                    print("🔐 CoreData user set on login: \(user.uid)")
                    
                    self.fetchProfile(uid: user.uid)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func resetPassword(email: String) {
        AuthService.shared.resetPassword(email: email) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.errorMessage = "Reset email sent!"
                    // Reset error message after 3 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.errorMessage = nil
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func logout() {
        do {
            try AuthService.shared.logout()
            
            // Clear user from CoreData on logout
            CoreDataManager.shared.clearCurrentUser()
            print("🔐 CoreData user cleared on logout")
            
            self.user = nil
            self.isAuthenticated = false
            self.profile = nil
            self.errorMessage = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func updateProfile(name: String, country: String, completion: @escaping (Bool) -> Void) {
        
        guard let uid = user?.uid else {
            completion(false)
            return
        }
        
        Firestore.firestore()
            .collection("users")
            .document(uid)
            .updateData([
                "name": name,
                "country": country
            ]) { error in
                
                DispatchQueue.main.async {
                    if let error = error {
                        print("Update error:", error.localizedDescription)
                        self.errorMessage = error.localizedDescription
                        completion(false)
                    } else {
                        // Update local profile
                        self.profile?.name = name
                        self.profile?.country = country
                        
                        // Show success message
                        self.errorMessage = "Profile updated successfully!"
                        
                        // Clear success message after 2 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            if self.errorMessage == "Profile updated successfully!" {
                                self.errorMessage = nil
                            }
                        }
                        
                        completion(true)
                    }
                }
            }
    }
    
    func fetchProfile(uid: String) {
        Firestore.firestore()
            .collection("users")
            .document(uid)
            .getDocument { snapshot, error in
                
                if let error = error {
                    print("Error fetching profile: \(error.localizedDescription)")
                    return
                }

                if let data = snapshot?.data() {
                    let name = data["name"] as? String ?? ""
                    let country = data["country"] as? String ?? ""
                    let email = data["email"] as? String ?? ""

                    let profile = UserModel(
                        uid: uid,
                        email: email,
                        name: name,
                        country: country,
                        created_at: Date()
                    )

                    DispatchQueue.main.async {
                        self.profile = profile
                        print("👤 Profile loaded for user: \(name)")
                    }
                }
            }
    }
    
    // MARK: - Helper Methods
    
    var currentUserId: String {
        return user?.uid ?? ""
    }
    
    var isLoggedIn: Bool {
        return user != nil
    }
}
