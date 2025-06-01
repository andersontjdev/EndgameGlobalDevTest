//
//  MockUserDetailViewModelDelegate.swift
//  EndgameGlobalChallenge
//
//  Created by Taylor Anderson on 1/6/2025.
//

import XCTest
@testable import EndgameGlobalChallenge

@MainActor
class MockUserDetailViewModelDelegate: UserDetailViewModelDelegate {
    
    var didLoadUserProfileCallCount = 0
    var didStartLoadingCallCount = 0
    var didFinishLoadingCallCount = 0
    var didReceiveErrorCallCount = 0
    var lastErrorMessage: String?
    
    var onDidLoadUserProfile: (() -> Void)?
    var onDidStartLoading: (() -> Void)?
    var onDidFinishLoading: (() -> Void)?
    var onDidReceiveError: ((String) -> Void)?
    
    func didLoadUserProfile() {
        didLoadUserProfileCallCount += 1
        onDidLoadUserProfile?()
    }
    
    func didStartLoading() {
        didStartLoadingCallCount += 1
        onDidStartLoading?()
    }
    
    func didFinishLoading() {
        didFinishLoadingCallCount += 1
        onDidFinishLoading?()
    }
    
    func didReceiveError(_ error: String) {
        didReceiveErrorCallCount += 1
        lastErrorMessage = error
        onDidReceiveError?(error)
    }
    
    func reset() {
        didLoadUserProfileCallCount = 0
        didStartLoadingCallCount = 0
        didFinishLoadingCallCount = 0
        didReceiveErrorCallCount = 0
        lastErrorMessage = nil
        onDidLoadUserProfile = nil
        onDidStartLoading = nil
        onDidFinishLoading = nil
        onDidReceiveError = nil
    }
}
