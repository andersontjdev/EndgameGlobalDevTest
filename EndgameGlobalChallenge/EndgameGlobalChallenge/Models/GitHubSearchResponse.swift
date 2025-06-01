//
//  GitHubSearchResponse.swift
//  EndgameGlobalChallenge
//
//  Created by Taylor Anderson on 1/6/2025.
//

import Foundation

struct GitHubSearchResponse: Codable, Sendable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [User]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}
