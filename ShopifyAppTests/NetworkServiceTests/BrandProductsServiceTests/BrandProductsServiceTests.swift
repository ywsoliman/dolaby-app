//
//  BrandProductsServiceTests.swift
//  ShopifyAppTests
//
//  Created by Israa Assem on 24/06/2024.
//

import XCTest
@testable import ShopifyApp
final class BrandProductsServiceTests: XCTestCase {
    override func setUpWithError() throws {
        super.setUp()
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }

    func testFetchingBrandProducts() {
        
        let expectation = expectation(description: "Waiting for API")
        
        NetworkService.shared.makeRequest(endPoint: "/collections/\(475723497772)/products.json", method: .get) { (result: Result<BrandProductsResponse, APIError>) in
            
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
    func testNumberOfFetchedBrandProducts() {
        
        let expectation = expectation(description: "Waiting for API")
        
        NetworkService.shared.makeRequest(endPoint: "/collections/\(475723497772)/products.json", method: .get) { (result: Result<BrandProductsResponse, APIError>) in
            
            switch result {
            case .success(let response):
                XCTAssertEqual(response.products.count,4)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Request failed with error: \(error)")
                expectation.fulfill()
            }
            
        }
        
        waitForExpectations(timeout: 5)
        
    }
    
    func testFirstBrandProductVendor() {
        
        let expectation = expectation(description: "Waiting for API")
        
        NetworkService.shared.makeRequest(endPoint: "/collections/\(475723497772)/products.json", method: .get) { (result: Result<BrandProductsResponse, APIError>) in
            
            switch result {
            case .success(let response):
                XCTAssertEqual(response.products.first?.vendor,"ADIDAS")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Request failed with error: \(error)")
                expectation.fulfill()
            }
            
        }
        
        waitForExpectations(timeout: 5)
        
    }
    
}
