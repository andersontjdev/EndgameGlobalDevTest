//
//  Enums.swift
//  EndgameGlobalChallenge
//
//  Created by Taylor Anderson on 1/6/2025.
//

import Foundation

// MARK: APIError

enum APIError: Error, LocalizedError {
    case invalidUrl
    case noData
    case decodingError
    case networkError(Error)
    case rateLimitExceeded
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "Invalid URL"
            
        case .noData:
            return "No data received"
            
        case .decodingError:
            return "Failed to parse the response"
            
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
            
        case .rateLimitExceeded:
            return "Rate limit exceeded. Please try again later"
            
        case .invalidResponse:
            return "Invalid response from the server"
        }
    }
}
