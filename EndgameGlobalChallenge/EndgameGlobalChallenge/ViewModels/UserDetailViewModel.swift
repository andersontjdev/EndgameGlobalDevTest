//
//  UserDetailViewModel.swift
//  EndgameGlobalChallenge
//
//  Created by Taylor Anderson on 1/6/2025.
//

import Foundation

@MainActor
protocol UserDetailViewModelDelegate: AnyObject {
    func didLoadUserProfile()
    func didStartLoading()
    func didFinishLoading()
    func didReceiveError(_ error: String)
}

@MainActor
class UserDetailViewModel {
    weak var delegate: UserDetailViewModelDelegate?
    
    private(set) var userProfile: UserProfile?
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    var displayName: String {
        return userProfile?.name ?? user.login
    }
    
    var username: String {
        return userProfile?.login ?? user.login
    }
    
    var avatarURL: String? {
        return userProfile?.avatarURL ?? user.avatarUrl
    }
    
    var profileURL: String? {
        return userProfile?.htmlURL ?? user.htmlUrl
    }
    
    var repositoryCount: Int {
        return userProfile?.publicRepos ?? 0
    }
    
    var followersCount: Int {
        return userProfile?.followers ?? 0
    }
    
    var followingCount: Int {
        return userProfile?.following ?? 0
    }
    
    var bio: String? {
        return userProfile?.bio
    }
    
    var location: String? {
        return userProfile?.location
    }
    
    var company: String? {
        return userProfile?.company
    }
    
    // MARK: Public Functions
    
    func loadUserProfile() async {
        print("UserDetailViewModel: Loading user profile for \(user.login)")
        
        isLoading = true
        errorMessage = nil
        delegate?.didStartLoading()
        
        do {
            let profile = try await GitHubAPIService.shared.fetchUserProfile(username: user.login)
            
            print("UserDetailViewModel: User profile loaded successfully")
            userProfile = profile
            isLoading = false
            delegate?.didFinishLoading()
            delegate?.didLoadUserProfile()
            
        } catch {
            print("UserDetailViewModel: User profile loading failed - \(error)")
            errorMessage = error.localizedDescription
            isLoading = false
            delegate?.didReceiveError(error.localizedDescription)
            delegate?.didFinishLoading()
        }
    }
}
