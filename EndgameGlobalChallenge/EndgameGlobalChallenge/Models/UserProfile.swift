//
//  UserProfile.swift
//  EndgameGlobalChallenge
//
//  Created by Taylor Anderson on 1/6/2025.
//

import Foundation

struct UserProfile: Codable, Sendable {
    let id: Int
    let login: String
    let name: String?
    let avatarURL: String?
    let htmlURL: String?
    let type: String?
    let bio: String?
    let publicRepos: Int
    let followers: Int
    let following: Int
    let location: String?
    let company: String?
    let blog: String?
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case name
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
        case type
        case bio
        case publicRepos = "public_repos"
        case followers
        case following
        case location
        case company
        case blog
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
