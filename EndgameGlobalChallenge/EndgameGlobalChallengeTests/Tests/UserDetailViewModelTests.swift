//
//  UserDetailViewModelTests.swift
//  EndgameGlobalChallenge
//
//  Created by Taylor Anderson on 1/6/2025.
//

import XCTest
@testable import EndgameGlobalChallenge

@MainActor
final class UserDetailViewModelTests: XCTestCase {
    
    var viewModel: UserDetailViewModel!
    var mockDelegate: MockUserDetailViewModelDelegate!
    var testUser: User!
    
    override func setUp() {
        super.setUp()
        testUser = User(id: 1, login: "testuser", avatarUrl: "https://example.com/avatar.jpg", type: "User")
        viewModel = UserDetailViewModel(user: testUser)
        mockDelegate = MockUserDetailViewModelDelegate()
        viewModel.delegate = mockDelegate
    }
    
    override func tearDown() {
        viewModel = nil
        mockDelegate = nil
        testUser = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.username, "testuser")
        XCTAssertEqual(viewModel.displayName, "testuser")
        XCTAssertEqual(viewModel.avatarURL, "https://example.com/avatar.jpg")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.userProfile)
    }
    
    func testFallbackProperties() {
        XCTAssertEqual(viewModel.username, testUser.login)
        XCTAssertEqual(viewModel.displayName, testUser.login)
        XCTAssertEqual(viewModel.avatarURL, testUser.avatarUrl)
        XCTAssertEqual(viewModel.repositoryCount, 0)
        XCTAssertEqual(viewModel.followersCount, 0)
        XCTAssertEqual(viewModel.followingCount, 0)
    }
    
    func testLoadUserProfileCallsDelegateCorrectly() async {
        let expectation = XCTestExpectation(description: "Profile loading completed")
        
        mockDelegate.onDidStartLoading = {
            // Verify loading started
            XCTAssertTrue(self.viewModel.isLoading)
        }
        
        mockDelegate.onDidFinishLoading = {
            expectation.fulfill()
        }
        
        await viewModel.loadUserProfile()
        
        await fulfillment(of: [expectation], timeout: 5.0)
        XCTAssertEqual(mockDelegate.didStartLoadingCallCount, 1)
        XCTAssertEqual(mockDelegate.didFinishLoadingCallCount, 1)
        XCTAssertFalse(viewModel.isLoading)
    }
}
