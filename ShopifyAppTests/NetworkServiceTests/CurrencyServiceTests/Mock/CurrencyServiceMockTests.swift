//
//  CurrencyServiceMockTests.swift
//  ShopifyAppTests
//
//  Created by Youssef Waleed on 14/06/2024.
//

import XCTest

final class CurrencyServiceMockTests: XCTestCase {
    
    private var currencyServiceMock: CurrencyServiceMock!

    override func setUpWithError() throws {
        currencyServiceMock = CurrencyServiceMock()
    }

    override func tearDownWithError() throws {
        currencyServiceMock = nil
    }

    func testFetchingCurrenciesSuccess() {
        currencyServiceMock.shouldFail = false
        currencyServiceMock.getCurrencies { response, error in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
        }
    }
    
    func testFetchingCurrenciesFailure() {
        currencyServiceMock.shouldFail = true
        currencyServiceMock.getCurrencies { response, error in
            XCTAssertNotNil(error)
            XCTAssertNil(response)
        }
    }

}
