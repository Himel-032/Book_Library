//
//  User.swift
//  BookLibrary
//
//  Created by macos on 24/2/26.
//

import Foundation

struct UserModel: Codable {
    let uid: String
    let email: String
    var name: String
    var country: String
    let created_at: Date
}
