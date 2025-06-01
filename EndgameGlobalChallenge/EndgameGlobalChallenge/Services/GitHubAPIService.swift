//
//  GitHubAPIService.swift
//  EndgameGlobalChallenge
//
//  Created by Taylor Anderson on 1/6/2025.
//

import Foundation

class GitHubAPIService {
    
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
    
    func searchUsers(query: String, completion: @escaping (Result<GitHubSearchResponse, APIError>) -> Void) {
        guard !query.isEmpty else {
            completion(.success(GitHubSearchResponse(totalCount: 0, incompleteResults: false, items: [])))
            
            return
        }
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseUrl)/search/users?q=\(encodedQuery)") else {
            completion(.failure(.invalidUrl))
            
            return
        }
        
        print("GitHubAPIService: Making network request to \(url)")
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("GitHubAPIService: Network Error - \(error)")
                completion(.failure(.networkError(error)))
                
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("GitHubAPIService: Invalid response type")
                completion(.failure(.invalidResponse))
                
                return
            }
            
            print("GitHubAPIService: Response status code: \(httpResponse.statusCode)")
            
            // Handle rate limiting
            if httpResponse.statusCode == 403 {
                completion(.failure(.rateLimitExceeded))
                
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                
                return
            }
            
            guard let data = data else {
                print("GitHubAPIService: No data received from the server")
                completion(.failure(.noData))
                
                return
            }
            
            do {
                let searchResponse = try JSONDecoder().decode(GitHubSearchResponse.self, from: data)
                print("GitHubAPIService: Successfully decoded \(searchResponse.items.count) users")
                completion(.success(searchResponse))
            } catch {
                print("GitHubAPIService: Decoding error - \(error)")
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
    
    func fetchUserProfile(username: String, completion: @escaping (Result<UserProfile, APIError>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/users/\(username)") else {
            completion(.failure(.invalidUrl))
            
            return
        }
        
        print("GitHubAPIService: Fetching profile data for \(username)")
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("GitHubAPIService: Profile fetch error - \(error)")
                completion(.failure(.networkError(error)))
                
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("GitHubAPIService: Invalid response type")
                completion(.failure(.invalidResponse))
                
                return
            }
            
            print("GitHubAPITService: Profile response status code: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode == 403 {
                completion(.failure(.rateLimitExceeded))
                
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                
                return
            }
            
            guard let data = data else {
                print("GitHubAPIService: No profile data received from the server")
                completion(.failure(.noData))
                
                return
            }
            
            do {
                let userProfile = try JSONDecoder().decode(UserProfile.self, from: data)
                print("GitHubAPIService: Successfully decoded profile for \(userProfile.login)")
                completion(.success(userProfile))
            } catch {
                print("GitHubAPIService: Profile decoding error - \(error)")
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
}
