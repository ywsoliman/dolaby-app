//
//  OrdersServiceTests.swift
//  ShopifyAppTests
//
//  Created by Israa Assem on 23/06/2024.
//

import XCTest
@testable import ShopifyApp
final class OrdersServiceTests: XCTestCase {
    private var orderIDToDelete: Int?
    override func setUp() {
        super.setUp()
        orderIDToDelete = nil
    }
    override func tearDown() {
        if let id = orderIDToDelete {
            deleteOrder(withId: id)
        }
        super.tearDown()
    }
    
    func testFetchingOrders() {
        
        let expectation = expectation(description: "Waiting for API")
        
        NetworkService.shared.makeRequest(endPoint: "/customers/\(TEST_CUSTOMER_ID)/orders.json", method: .get) { (result: Result<CustomerOrdersResponse, APIError>) in
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
    func testFetchingSingleOrder() {
        
        let expectation = expectation(description: "Waiting for API")
        
        NetworkService.shared.makeRequest(endPoint: "/orders/\(TEST_ORDER_ID).json", method: .get){ (result: Result<CustomerOrdersResponse, APIError>) in
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

    
    private func deleteOrder(withId id: Int) {
        
        let expectation = expectation(description: "Waiting for API")
        
        NetworkService.shared.makeRequest(endPoint: "/orders/\(id).json", method: .delete) { (result: Result<EmptyResponse, APIError>) in
            
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
    func testCreatingOrder() {
        
        let expectation = expectation(description: "Waiting for API")

        let order:[String : Any]=[
            "order": [
               
                "currency": "AED",
                "email": "israaassem20@gmail.com",
                "total_price": 50,
                "customer":
                    ["id":
                       8143611298092
                    ],
                "line_items":
                          [
                            [
                               "title": "CONVERSE | TODDLER CHUCK TAYLOR ALL STAR AXEL MID",
                               "price": 70,
                               "quantity":1,
                               "variant_title":"5 / black",
                               "variant_id": 48945465819436,
                               "product_id": 9365475852588
                            ]
                          ]
            ]
]
        
        NetworkService.shared.makeRequest(endPoint: "/orders.json", method: .post, parameters: order) { (result: Result<OrderResponse, APIError>) in
            
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
                self.orderIDToDelete = response.order?.id
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
            
        }
        
        waitForExpectations(timeout: 15)
        
    }
}
