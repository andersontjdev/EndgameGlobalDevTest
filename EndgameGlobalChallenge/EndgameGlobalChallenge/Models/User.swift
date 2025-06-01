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
