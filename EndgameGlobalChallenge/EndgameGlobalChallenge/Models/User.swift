//
//  User.swift
//  EndgameGlobalChallenge
//
//  Created by Taylor Anderson on 1/6/2025.
//

import Foundation

struct User {
    let id: Int
    let login: String
    let avatarUrl: String?
    let htmlUrl: String?
    
    // Mock data init
    init(id: Int,
         login: String,
         avatarUrl: String? = nil,
         htmlUrl: String? = nil
    ) {
        self.id = id
        self.login = login
        self.avatarUrl = avatarUrl
        self.htmlUrl = htmlUrl
    }
}

// MARK: Codable extension for API

extension User: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
    }
}

// MARK: Hashable extension for removing duplicate data

extension User: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
