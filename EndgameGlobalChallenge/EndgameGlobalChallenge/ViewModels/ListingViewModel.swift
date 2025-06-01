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
    private(set) var hasSearched = false
    
    private let apiService = GitHubAPIService.shared
    private var searchTask: DispatchWorkItem?
    private let debounceDelay: TimeInterval = 0.5
    
    var numberOfUsers: Int {
        return users.count
    }
    
    var shouldShowEmptyState: Bool {
        return users.isEmpty && !isLoading
    }
    
    var emptyStateMessage: String {
        if !hasSearched {
            return "Search for GitHub users to get started"
        } else {
            return "No users found\nTry searching for a different username"
        }
    }
    
    var emptyStateImageName: String {
        if !hasSearched {
            return "magnifyingglass.circle"
        } else {
            return "magnifyingglass"
        }
    }
    
    init() {
        print("ListingViewModel: Initializing")
        
        delegate?.didUpdateUsers()
    }
    
    // MARK: Public Functions
    
    func searchUsers(query: String) {
        print("ListingViewModel: Search initiated with query: '\(query)'")
        
        // Cancel any previous search tasks
        searchTask?.cancel()
        
        // Handle empty queries
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            users = []
            hasSearched = false
            delegate?.didUpdateUsers()
            
            return
        }
        
        // Create a debounced search task
        let task = DispatchWorkItem { [weak self] in
            self?.performSearch(for: query)
        }
        
        searchTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + debounceDelay, execute: task)
    }
    
    func getUserAt(_ index: Int) -> User? {
        guard index >= 0 && index < users.count else { return nil }
        
        return users[index]
    }
    
    // MARK: Private Functions
    
    private func performSearch(for query: String) {
        print("ListingViewModel: Performing search for users with query: '\(query)'")
        
        isLoading = true
        errorMessage = nil
        hasSearched = true
        
        // Notify the delegate on the main thread
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.didStartLoading()
        }
        
        apiService.searchUsers(query: query) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.isLoading = false
                self.delegate?.didFinishLoading()
                
                switch result {
                case .success(let searchResponse):
                    print("ListingViewModel: Search successful, found \(searchResponse.items.count) users")
                    self.users = searchResponse.items
                    self.errorMessage = nil
                    self.delegate?.didUpdateUsers()
                    
                case .failure(let error):
                    print("ListingViewModel: Search failed - \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                    self.users = []
                    self.delegate?.didReceiveError(error.localizedDescription)
                    self.delegate?.didUpdateUsers()
                }
            }
        }
    }
}
