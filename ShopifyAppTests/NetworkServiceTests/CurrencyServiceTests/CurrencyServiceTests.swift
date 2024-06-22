//
//  CurrencyServiceTests.swift
//  ShopifyAppTests
//
//  Created by Youssef Waleed on 14/06/2024.
//

import XCTest
@testable import ShopifyApp

final class CurrencyServiceTests: XCTestCase {
    

    func testFetchingCurrencies() {
        
        let expectation = expectation(description: "Waiting for API")
        
        CurrencyService.shared.fetchCurrencies { (result: Result<CurrencyResponse, any Error>) in
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
