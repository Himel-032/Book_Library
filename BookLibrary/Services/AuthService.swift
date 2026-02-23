//
//  AuthService.swift
//  BookLibrary
//
//  Created by Himel on 23/2/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    
    static let shared = AuthService()
    
    private init() {}
    
    // Signup
    func signUp(email: String, password: String, name: String, country: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user else { return }
            let userModel = UserModel(
                        uid: user.uid,
                        email: email,
                        name: name,
                        country: country,
                        created_at: Date()
                )
            // Firestore data
                  let data: [String: Any] = [
                      "uid": userModel.uid,
                      "email": userModel.email,
                      "name": userModel.name,
                      "country": userModel.country,
                      "created_at": Timestamp(date: userModel.created_at)
                  ]
            Firestore.firestore()
                       .collection("users")
                       .document(user.uid)
                       .setData(data) { error in
                           if let error = error {
                               completion(.failure(error))
                           } else {
                               completion(.success(user))
                           }
                       }
            
        }
    }
    
    // Login
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let user = result?.user {
                completion(.success(user))
            }
        }
    }
    
    // Reset Password
    func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // Logout
    func logout() throws {
        try Auth.auth().signOut()
    }
    
    // Check if user logged in
    var currentUser: User? {
        Auth.auth().currentUser
    }
}
