//
//  ListingViewModel.swift
//  EndgameGlobalChallenge
//
//  Created by Taylor Anderson on 1/6/2025.
//

import Foundation

// MARK: ListingViewModelDelegate

protocol ListingViewModelDelegate: AnyObject {
    func didUpdateUsers()
    func didStartLoading()
    func didFinishLoading()
    func didReceiveError(_ error: String)
}

// MARK: ListingViewModel

class ListingViewModel {
    weak var delegate: ListingViewModelDelegate?
    
    private(set) var users: [User] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
    // Create mock data
    private let mockUsers: [User] = [
        User(id: 1, login: "mock_user_01"),
        User(id: 2, login: "mock_user_02"),
        User(id: 3, login: "mock_user_03"),
        User(id: 4, login: "mock_user_04"),
        User(id: 5, login: "mock_user_05"),
        User(id: 6, login: "mock_user_06"),
        User(id: 7, login: "mock_user_07"),
        User(id: 8, login: "mock_user_08"),
        User(id: 9, login: "mock_user_09"),
        User(id: 10, login: "mock_user_10")
    ]
    
    var numberOfUsers: Int {
        return users.count
    }
    
    init() {
        loadMockData()
    }
    
    // MARK: Public Functions
    
    func searchUsers(query: String) {
        // Simulate a loading state
        isLoading = true
        delegate?.didStartLoading()
        
        // Simulate a network request delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            
            if query.isEmpty {
                // No search term, just return all mock users for now
                self.users = self.mockUsers
            } else {
                // Filter mock users by login based on search term
                self.users = self.mockUsers.filter {
                    $0.login.localizedCaseInsensitiveContains(query)
                }
            }
            
            self.isLoading = false
            self.delegate?.didFinishLoading()
            self.delegate?.didUpdateUsers()
        }
    }
    
    func getUserAt(_ index: Int) -> User? {
        guard index >= 0 && index < users.count else { return nil }
        
        return users[index]
    }
    
    // MARK: Private Functions
    
    private func loadMockData() {
        users = mockUsers
        delegate?.didUpdateUsers()
    }
}
