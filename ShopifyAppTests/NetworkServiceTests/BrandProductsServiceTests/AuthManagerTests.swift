//
//  AuthenticatoinManagerTests.swift
//  ShopifyAppTests
//
//  Created by Samuel Adel on 22/06/2024.
//

import XCTest
@testable import ShopifyApp
import FirebaseAuth
import FirebaseFirestore
final class AuthenticatoinManagerTests: XCTestCase {

    var authManager: AuthenticationManager!

        override func setUpWithError() throws {
            try super.setUpWithError()
            // Initialize AuthenticationManager instance
            authManager = AuthenticationManager.shared
        }

        override func tearDownWithError() throws {
            authManager = nil
            try super.tearDownWithError()
        }

    func testCreateCustomer() async throws {
            // Arrange
            let customerData = CustomerData(id: 1, userId: "", firstName: "John", lastName: "Doe", phone: "1234567890", email: "john.doe@example.com", password: "password123")
            let expectation = self.expectation(description: "Create customer expectation")
            // Act
            do {
                try await authManager.createCustomer(customer: customerData)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to create customer: \(error.localizedDescription)")
                expectation.fulfill()
            }

        await waitForExpectations(timeout: 10, handler: nil)
        }

    func testLogin() async throws {
            // Arrange
            let customerCredentials = CustomerCredentials(email: "samueladel1001@gmail.com", password: "newpass123")

            let expectation = self.expectation(description: "Login expectation")

            // Act
            do {
              let custData = try await authManager.login(customer: customerCredentials)
                XCTAssertEqual(customerCredentials.email, custData.email)
                expectation.fulfill()
            } catch {
                XCTFail("Failed to login: \(error.localizedDescription)")
                expectation.fulfill()
            }

        await waitForExpectations(timeout: 10, handler: nil)
        }
}
