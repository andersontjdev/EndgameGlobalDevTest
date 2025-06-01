//
//  GitHubAPIService.swift
//  EndgameGlobalChallenge
//
//  Created by Taylor Anderson on 1/6/2025.
//

import Foundation

actor GitHubAPIService {
    
    static let shared = GitHubAPIService()
    
    private let baseUrl = "https://api.github.com"
    private let session: URLSession
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 20
        
        self.session = URLSession(configuration: configuration)
    }
    
    // MARK: Public Functions
    
    func searchUsers(query: String) async throws -> GitHubSearchResponse {
        guard !query.isEmpty else {
            return GitHubSearchResponse(totalCount: 0, incompleteResults: false, items: [])
        }
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseUrl)/search/users?q=\(encodedQuery)") else {
            throw APIError.invalidUrl
        }
        
        print("GitHubAPIService: Making network request to \(url)")
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("GitHubAPIService: Invalid response type")
                throw APIError.invalidResponse
            }
            
            print("GitHubAPIService: Response status code: \(httpResponse.statusCode)")
            
            // Handle rate limiting
            if httpResponse.statusCode == 403 {
                throw APIError.rateLimitExceeded
            }
            
            guard httpResponse.statusCode == 200 else {
                throw APIError.invalidResponse
            }
            
            let searchResponse = try JSONDecoder().decode(GitHubSearchResponse.self, from: data)
            print("GitHubAPIService: Successfully decoded \(searchResponse.items.count) users")
            
            return searchResponse
            
        } catch let error as APIError {
            print("GitHubAPIService: API error - \(error)")
            throw error
        } catch {
            print("GitHubAPIService: Network Error - \(error)")
            throw APIError.networkError(error)
        }
    }
    
    func fetchUserProfile(username: String) async throws -> UserProfile {
        guard let url = URL(string: "\(baseUrl)/users/\(username)") else {
            throw APIError.invalidUrl
        }
        
        print("GitHubAPIService: Fetching profile data for \(username)")
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("GitHubAPIService: Invalid response type")
                throw APIError.invalidResponse
            }
            
            print("GitHubAPITService: Profile response status code: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode == 403 {
                throw APIError.rateLimitExceeded
            }
            
            guard httpResponse.statusCode == 200 else {
                throw APIError.invalidResponse
            }
            
            let userProfile = try JSONDecoder().decode(UserProfile.self, from: data)
            print("GitHubAPIService: Successfully decoded profile for \(userProfile.login)")
            
            return userProfile
        } catch let error as APIError {
            throw error
        } catch {
            print("GitHubAPIService: Profile fetch error - \(error)")
            throw APIError.networkError(error)
        }
    }
}
