//
//  NetworkServiceTests.swift
//  ShopifyAppTests
//
//  Created by Youssef Waleed on 14/06/2024.
//

import XCTest
@testable import ShopifyApp

final class NetworkServiceTests: XCTestCase {
    
    private var addressIDToDelete: Int?
    
    override func setUp() {
        super.setUp()
        addressIDToDelete = nil
    }
    
    override func tearDown() {
        if let id = addressIDToDelete {
            deleteAddress(withId: id)
        }
        super.tearDown()
    }
    
    func testFetchingDiscountCodes() {
        
        let expectation = self.expectation(description: "Waiting for API")
        
        NetworkService.shared.makeRequest(endPoint: "/price_rules.json", method: .get) { (result: Result<PriceRulesResponse, APIError>) in
            
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Request failed with error: \(error)")
            }
            
        }
        
        waitForExpectations(timeout: 10)
        
    }
    
    func testFetchingAddresses() {
        
        let expectation = self.expectation(description: "Waiting for API")
        
        NetworkService.shared.makeRequest(endPoint: "/customers/\(TEST_CUSTOMER_ID)/addresses.json", method: .get) { (result: Result<CustomerAddresses, APIError>) in
            
            switch result {
            case .success(let addresses):
                XCTAssertGreaterThan(addresses.addresses.count, 0)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Request failed with error: \(error)")
            }
            
        }
        
        waitForExpectations(timeout: 10)
        
    }
    
    func testAddingAddress() {
        
        let expectation = self.expectation(description: "Waiting for API")
        
        let address = AddedAddress(address1: "1 Rue des Carrieres", city: "Montreal", country: "Canada")
        
        let addressParams: [String: Any] = ["address": [
            "address1": address.address1,
            "city": address.city,
            "country": address.country
        ]]
        
        NetworkService.shared.makeRequest(endPoint: "/customers/\(TEST_CUSTOMER_ID)/addresses.json", method: .post, parameters: addressParams) { (result: Result<CustomerAddress, APIError>) in
            
            switch result {
            case .success(let response):
                XCTAssertEqual(response.customerAddress.address1, address.address1)
                XCTAssertEqual(response.customerAddress.city, address.city)
                XCTAssertEqual(response.customerAddress.country, address.country)
                self.addressIDToDelete = response.customerAddress.id
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Request failed with error: \(error)")
            }
            
        }
        
        waitForExpectations(timeout: 10)
        
    }
    
    private func deleteAddress(withId id: Int) {
        
        let expectation = self.expectation(description: "Waiting for API")
        
        NetworkService.shared.makeRequest(endPoint: "/customers/\(TEST_CUSTOMER_ID)/addresses/\(id).json", method: .delete) { (result: Result<EmptyResponse, APIError>) in
            
            switch result {
            case .success:
                XCTAssertTrue(true)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Request failed with error: \(error)")
            }
            
        }
        
        waitForExpectations(timeout: 10)
        
    }
    
    
    
}
