//
//  MockGitHubAPIService.swift
//  EndgameGlobalChallenge
//
//  Created by Taylor Anderson on 1/6/2025.
//

import Foundation
@testable import EndgameGlobalChallenge

actor MockGitHubAPIService {
    
    var shouldThrowError = false
    var mockSearchResponse: GitHubSearchResponse?
    var mockUserProfile: UserProfile?
    var searchUsersCallCount = 0
    var fetchUserProfileCallCount = 0
    var lastSearchQuery: String?
    var lastUsername: String?
    
    // MARK: Mock Functions
    
    func searchUsers(query: String) async throws -> GitHubSearchResponse {
        searchUsersCallCount += 1
        lastSearchQuery = query
        
        if shouldThrowError {
            throw APIError.networkError(NSError(domain: "TestError", code: 1))
        }
        
        return mockSearchResponse ?? GitHubSearchResponse(totalCount: 0, incompleteResults: false, items: [])
    }
    
    func fetchUserProfile(username: String) async throws -> UserProfile {
        fetchUserProfileCallCount += 1
        lastUsername = username
        
        if shouldThrowError {
            throw APIError.networkError(NSError(domain: "TestError", code: 1))
        }
        
        guard let profile = mockUserProfile else {
            throw APIError.noData
        }
        
        return profile
    }
    
    func reset() {
        shouldThrowError = false
        mockSearchResponse = nil
        mockUserProfile = nil
        searchUsersCallCount = 0
        fetchUserProfileCallCount = 0
        lastSearchQuery = nil
        lastUsername = nil
    }
}
