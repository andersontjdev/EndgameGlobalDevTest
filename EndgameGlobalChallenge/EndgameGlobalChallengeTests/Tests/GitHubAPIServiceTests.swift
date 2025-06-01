//
//  GitHubAPIServiceTests.swift
//  EndgameGlobalChallenge
//
//  Created by Taylor Anderson on 1/6/2025.
//

import XCTest
@testable import EndgameGlobalChallenge

final class GitHubAPIServiceTests: XCTestCase {
    
    var apiService: GitHubAPIService!
    
    override func setUp() {
        super.setUp()
        apiService = GitHubAPIService.shared
    }
    
    override func tearDown() {
        apiService = nil
        super.tearDown()
    }
    
    func testSearchUsersWithValidQuery() async throws {
        let query = "test"
        
        let result = try await apiService.searchUsers(query: query)
        
        XCTAssertNotNil(result)
        XCTAssertGreaterThanOrEqual(result.totalCount, 0)
        XCTAssertNotNil(result.items)
    }
    
    func testFetchUserProfileWithValidUsername() async throws {
        let username = "andersontjdev"
        
        let profile = try await apiService.fetchUserProfile(username: username)
        
        XCTAssertEqual(profile.login, username)
        XCTAssertNotNil(profile.id)
        XCTAssertNotNil(profile.avatarURL)
    }
    
    func testFetchUserProfileWithInvalidUsername() async {
        let username = "qpwoeirutyghfjdksla"
        
        do {
            _ = try await apiService.fetchUserProfile(username: username)
            XCTFail("This is expected to fail")
        } catch {
            XCTAssertTrue(error is APIError)
        }
    }
}
