//
//  NetworkServiceMockTests.swift
//  ShopifyAppTests
//
//  Created by Youssef Waleed on 14/06/2024.
//

import XCTest
@testable import ShopifyApp

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
    
    func testFetchingCustomerAddressesSuccess() {
        networkServiceMock.shouldFail = false
        networkServiceMock.getCustomerAddresses { response, error in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
        }
    }
    
    func testFetchingCustomerAddressesFailure() {
        networkServiceMock.shouldFail = true
        networkServiceMock.getCustomerAddresses { response, error in
            XCTAssertNotNil(error)
            XCTAssertNil(response)
        }
        
    }
    
    func testAddingCustomerAddressSuccess() {
        networkServiceMock.shouldFail = false
        networkServiceMock.addCustomerAddress { response, error in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
        }
    }
    
    func testAddingCustomerAddressFailure() {
        networkServiceMock.shouldFail = true
        networkServiceMock.addCustomerAddress { response, error in
            XCTAssertNil(response)
            XCTAssertNotNil(error)
        }
    }
    
    func testFetchingDraftOrderSuccess() {
        networkServiceMock.shouldFail = false
        networkServiceMock.getDraftOrder { response, error in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
        }
    }
    
    func testFetchingDraftOrderFailure() {
        networkServiceMock.shouldFail = true
        networkServiceMock.getDraftOrder { response, error in
            XCTAssertNil(response)
            XCTAssertNotNil(error)
        }
    }
    
    func testCreateDraftOrderWithProductSuccess() {
        networkServiceMock.shouldFail = false
        networkServiceMock.createDraftOrderWithProduct { response, error in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
        }
    }
    
    func testCreateDraftOrderWithProductFailure() {
        networkServiceMock.shouldFail = true
        networkServiceMock.createDraftOrderWithProduct { response, error in
            XCTAssertNil(response)
            XCTAssertNotNil(error)
        }
    }
    
    func testUpdateCartByAddingAProductSuccess() {
        networkServiceMock.shouldFail = false
        networkServiceMock.updateCartByAddingAProduct { response, error in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertGreaterThan(response!.draftOrder.lineItems.count, 1)
        }
    }
    
    func testUpdateCartByAddingAProductFailure() {
        networkServiceMock.shouldFail = true
        networkServiceMock.updateCartByAddingAProduct { response, error in
            XCTAssertNil(response)
            XCTAssertNotNil(error)
        }
    }
    
    func testAddDiscountToDraftOrderSuccess() {
        networkServiceMock.shouldFail = false
        networkServiceMock.addDiscountToDraftOrder { response, error in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertNotNil(response!.draftOrder.appliedDiscount)
        }
    }
    
    func testAddDiscountToDraftOrderFailure() {
        networkServiceMock.shouldFail = true
        networkServiceMock.addDiscountToDraftOrder { response, error in
            XCTAssertNil(response)
            XCTAssertNotNil(error)
        }
    }
    
}
