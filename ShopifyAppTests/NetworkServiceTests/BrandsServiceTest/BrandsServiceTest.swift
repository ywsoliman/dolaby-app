//
//  BrandsServiceTest.swift
//  ShopifyAppTests
//
//  Created by Israa Assem on 23/06/2024.
//

import XCTest
@testable import ShopifyApp
final class BrandsServiceTest: XCTestCase {

    override func setUpWithError() throws {
        super.setUp()
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }

    func testFetchingBrands() {
        
        let expectation = expectation(description: "Waiting for API")
        
        NetworkService.shared.makeRequest(endPoint: "/smart_collections.json", method: .get) { (result: Result<BrandsResponse, APIError>) in
            
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
    func testNumberOfFetchedBrands() {
        
        let expectation = expectation(description: "Waiting for API")
        
        NetworkService.shared.makeRequest(endPoint: "/smart_collections.json", method: .get) { (result: Result<BrandsResponse, APIError>) in
            
            switch result {
            case .success(let response):
                XCTAssertEqual(response.brands.count,12)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Request failed with error: \(error)")
                expectation.fulfill()
            }
            
        }
        
        waitForExpectations(timeout: 5)
        
    }
    func testFirstBrandId() {
        
        let expectation = expectation(description: "Waiting for API")
        
        NetworkService.shared.makeRequest(endPoint: "/smart_collections.json", method: .get) { (result: Result<BrandsResponse, APIError>) in
            
            switch result {
            case .success(let response):
                XCTAssertEqual(response.brands.first?.id,475723497772)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Request failed with error: \(error)")
                expectation.fulfill()
            }
            
        }
        
        waitForExpectations(timeout: 5)
        
    }
}
