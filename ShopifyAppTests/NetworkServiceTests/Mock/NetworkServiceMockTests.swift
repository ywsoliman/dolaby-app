//
//  NetworkServiceMockTests.swift
//  ShopifyAppTests
//
//  Created by Youssef Waleed on 14/06/2024.
//

import XCTest

final class NetworkServiceMockTests: XCTestCase {
    
    private var networkServiceMock: NetworkServiceMock!

    override func setUpWithError() throws {
        networkServiceMock = NetworkServiceMock()
    }

    override func tearDownWithError() throws {
        networkServiceMock = nil
    }

    func testFetchingDiscountCodesSuccess() {
        networkServiceMock.shouldFail = false
        networkServiceMock.getDiscountCodes { response, error in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
        }
    }
    
    func testFetchingDiscountCodesFailure() {
        networkServiceMock.shouldFail = true
        networkServiceMock.getDiscountCodes { response, error in
            XCTAssertNotNil(error)
            XCTAssertNil(response)
        }
        
    }

}
