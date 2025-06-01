//
//  ListingViewModel.swift
//  EndgameGlobalChallenge
//
//  Created by Taylor Anderson on 1/6/2025.
//

import Foundation

// MARK: ListingViewModelDelegate

@MainActor
protocol ListingViewModelDelegate: AnyObject {
    func didUpdateUsers()
    func didStartLoading()
    func didFinishLoading()
    func didReceiveError(_ error: String)
}

// MARK: ListingViewModel

@MainActor
class ListingViewModel {
    weak var delegate: ListingViewModelDelegate?
    
    private(set) var users: [User] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var hasSearched = false
    
    private var searchTask: Task<Void, Never>?
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
        searchTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(debounceDelay * 1_000_000_000))
            
            guard !Task.isCancelled else { return }
            
            await performSearch(for: query)
        }
    }
    
    func getUserAt(_ index: Int) -> User? {
        guard index >= 0 && index < users.count else { return nil }
        
        return users[index]
    }
    
    // MARK: Private Functions
    
    private func performSearch(for query: String) async {
        print("ListingViewModel: Performing search for users with query: '\(query)'")
        
        isLoading = true
        errorMessage = nil
        hasSearched = true
        delegate?.didStartLoading()
        
        do {
            let searchResponse = try await GitHubAPIService.shared.searchUsers(query: query)
            
            guard !Task.isCancelled else { return }
            
            print("ListingViewModel: Search successful, found \(searchResponse.items.count) users")
            users = searchResponse.items
            errorMessage = nil
            isLoading = false
            delegate?.didFinishLoading()
            delegate?.didUpdateUsers()
            
        } catch {
            guard !Task.isCancelled else { return }
            
            print("ListingViewModel: Search failed - \(error.localizedDescription)")
            errorMessage = error.localizedDescription
            users = []
            isLoading = false
            delegate?.didReceiveError(error.localizedDescription)
            delegate?.didFinishLoading()
            delegate?.didUpdateUsers()
        }
    }
}
