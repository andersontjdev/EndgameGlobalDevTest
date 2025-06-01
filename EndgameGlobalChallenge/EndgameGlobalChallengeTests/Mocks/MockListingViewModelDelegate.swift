//
//  MockListingViewModelDelegate.swift
//  EndgameGlobalChallenge
//
//  Created by Taylor Anderson on 1/6/2025.
//

import Foundation
@testable import EndgameGlobalChallenge

@MainActor
class MockListingViewModelDelegate: ListingViewModelDelegate {
    
    var didUpdateUsersCallCount = 0
    var didStartLoadingCallCount = 0
    var didFinishLoadingCallCount = 0
    var didReceiveErrorCallCount = 0
    var lastErrorMessage: String?
    
    var onDidUpdateUsers: (() -> Void)?
    var onDidStartLoading: (() -> Void)?
    var onDidFinishLoading: (() -> Void)?
    var onDidReceiveError: ((String) -> Void)?
    
    func didUpdateUsers() {
        didUpdateUsersCallCount += 1
        onDidUpdateUsers?()
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
        didUpdateUsersCallCount = 0
        didStartLoadingCallCount = 0
        didFinishLoadingCallCount = 0
        didReceiveErrorCallCount = 0
        lastErrorMessage = nil
        onDidUpdateUsers = nil
        onDidStartLoading = nil
        onDidFinishLoading = nil
        onDidReceiveError = nil
    }
}
