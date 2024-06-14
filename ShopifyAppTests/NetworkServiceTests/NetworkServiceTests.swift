//
//  NetworkServiceTests.swift
//  ShopifyAppTests
//
//  Created by Youssef Waleed on 14/06/2024.
//

import XCTest
@testable import ShopifyApp

final class NetworkServiceTests: XCTestCase {

    func testFetchingDiscountCodes() {
        
        let expectation = expectation(description: "Waiting for API")
        
        NetworkService.shared.makeRequest(endPoint: "/price_rules.json", method: .get) { (result: Result<PriceRulesResponse, APIError>) in
            
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
            
        }
        
        waitForExpectations(timeout: 10)
        
    }

}
