//
//  ProductInfoTest.swift
//  ShopifyAppTests
//
//  Created by Samuel Adel on 22/06/2024.
//

import XCTest
@testable import ShopifyApp

final class ProductInfoTest: XCTestCase {

    func testFetchProductFromRemote(){
        let productId = 9365474771244
        let expectation = expectation(description: "wait for api response ...")
        NetworkService.shared.makeRequest(
            endPoint: "/products/\(productId).json",
            method: .get
        ) {(result: Result<ProductResponse, APIError>) in
            switch result {
            case .success(let productInfo):
                XCTAssertEqual(productId, productInfo.product.id)

            case .failure(let error):
                XCTFail(error.localizedDescription)
                
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }

}
