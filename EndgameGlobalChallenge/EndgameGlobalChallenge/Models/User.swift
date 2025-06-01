//
//  User.swift
//  EndgameGlobalChallenge
//
//  Created by Taylor Anderson on 1/6/2025.
//

import Foundation

struct User: Codable, Hashable, Sendable {
    let id: Int
    let login: String
    let avatarUrl: String?
    let htmlUrl: String?
    let type: String?
    
    // Mock data init
    init(id: Int,
         login: String,
         avatarUrl: String? = nil,
         htmlUrl: String? = nil,
         type: String? = nil
    ) {
        self.id = id
        self.login = login
        self.avatarUrl = avatarUrl
        self.htmlUrl = htmlUrl
        self.type = type
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
        case type
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
