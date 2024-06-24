//
//  CategoriesServiceTests.swift
//  ShopifyAppTests
//
//  Created by Israa Assem on 23/06/2024.
//

import XCTest
@testable import ShopifyApp
final class CategoriesServiceTests: XCTestCase {

        override func setUpWithError() throws {
            super.setUp()
        }

        override func tearDownWithError() throws {
            super.tearDown()
        }

        func testFetchingProducts() {
            
            let expectation = expectation(description: "Waiting for API")
            
            NetworkService.shared.makeRequest(endPoint: "/products.json", method: .get) { (result: Result<ProductsResponse, APIError>) in
                switch result {
                case .success(let response):
                    XCTAssertNotNil(response)
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Request failed with error: \(error)")
                    expectation.fulfill()
                }
                
            }
            
            waitForExpectations(timeout: 5)
            
        }
        func testNumberOfFetchedProducts() {
            
            let expectation = expectation(description: "Waiting for API")
            
            NetworkService.shared.makeRequest(endPoint: "/products.json", method: .get) { (result: Result<ProductsResponse, APIError>) in
                
                switch result {
                case .success(let response):
                    XCTAssertEqual(response.products.count,30)
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Request failed with error: \(error)")
                    expectation.fulfill()
                }
                
            }
            
            waitForExpectations(timeout: 5)
            
        }
        func testFirstProductType() {
            
            let expectation = expectation(description: "Waiting for API")
            
            NetworkService.shared.makeRequest(endPoint: "/products.json", method: .get) { (result: Result<ProductsResponse, APIError>) in                
                switch result {
                case .success(let response):
                    XCTAssertEqual(response.products.first?.productType,"ACCESSORIES")
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Request failed with error: \(error)")
                    expectation.fulfill()
                }
                
            }
            
            waitForExpectations(timeout: 5)
            
        }
    }
