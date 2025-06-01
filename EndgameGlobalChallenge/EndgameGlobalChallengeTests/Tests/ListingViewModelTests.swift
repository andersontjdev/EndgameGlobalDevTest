//
//  ListingViewModelTests.swift
//  EndgameGlobalChallenge
//
//  Created by Taylor Anderson on 1/6/2025.
//

import XCTest
@testable import EndgameGlobalChallenge

@MainActor
final class ListingViewModelTests: XCTestCase {
    
    var viewModel: ListingViewModel!
    var mockDelegate: MockListingViewModelDelegate!
    var mockApiService: MockGitHubAPIService!
    
    override func setUp() async throws {
        try await super.setUp()
        viewModel = ListingViewModel()
        mockDelegate = MockListingViewModelDelegate()
        mockApiService = MockGitHubAPIService()
        viewModel.delegate = mockDelegate
    }
    
    override func tearDown() async throws {
        viewModel = nil
        mockDelegate = nil
        await mockApiService.reset()
        mockApiService = nil
        try await super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.numberOfUsers, 0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.shouldShowEmptyState)
        XCTAssertEqual(viewModel.emptyStateMessage, "Search for GitHub users to get started")
    }
    
    func testSearchWithEmptyQuery() {
        let query = ""
        
        viewModel.searchUsers(query: query)
        
        XCTAssertEqual(viewModel.numberOfUsers, 0)
        XCTAssertFalse(viewModel.hasSearched)
        XCTAssertTrue(viewModel.shouldShowEmptyState)
        XCTAssertEqual(mockDelegate.didUpdateUsersCallCount, 1)
    }
    
    func testSearchWithValidQuery() async {
        let query = "test"
        let expectation = XCTestExpectation(description: "Search completed")
        
        mockDelegate.onDidUpdateUsers = {
            expectation.fulfill()
        }
        
        viewModel.searchUsers(query: query)
        
        await fulfillment(of: [expectation], timeout: 2.0)
        XCTAssertTrue(viewModel.hasSearched)
        XCTAssertGreaterThan(mockDelegate.didStartLoadingCallCount, 0)
        XCTAssertGreaterThan(mockDelegate.didFinishLoadingCallCount, 0)
    }
    
    func testGetUserAtInvalidIndex() {
        let user = viewModel.getUserAt(0)
        
        XCTAssertNil(user)
    }
}
