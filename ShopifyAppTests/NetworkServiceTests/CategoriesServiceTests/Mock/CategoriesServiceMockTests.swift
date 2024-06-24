//
//  CategoriesServiceMockTests.swift
//  ShopifyAppTests
//
//  Created by Israa Assem on 23/06/2024.
//

import XCTest
@testable import ShopifyApp
final class CategoriesServiceMockTests: XCTestCase {

  
    private var categoriesServiceMock: CategoriesServiceMock!
    
    override func setUpWithError() throws {
        categoriesServiceMock = CategoriesServiceMock()
    }
    
    override func tearDownWithError() throws {
        categoriesServiceMock = nil
    }

    
    func testFetchingCategoriesProductsSuccess() {
        categoriesServiceMock.shouldFail = false
        categoriesServiceMock.getCategoriesProducts { response, error in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
        }
    }
    
    func testFetchingCategoriesProductsFailure() {
        categoriesServiceMock.shouldFail = true
        categoriesServiceMock.getCategoriesProducts { response, error in
            XCTAssertNotNil(error)
            XCTAssertNil(response)
        }
        
    }
    
    func testFetchingCategoriesProductsSuccess_ContainsIPodProduct() {
        categoriesServiceMock.getCategoriesProducts { response, error in
        XCTAssertNil(error)
        XCTAssertNotNil(response)
          guard let products = response?.products else {
          XCTFail("Missing products in response")
          return
        }
        let firstProduct = products.first!
        XCTAssertEqual(firstProduct.id, 632910392)
        XCTAssertEqual(firstProduct.title, "IPod Nano - 8GB")
      }
    }
    func testFetchingCategoriesProductsSuccess_NumberOfProducts() {
        categoriesServiceMock.getCategoriesProducts { response, error in
        XCTAssertNil(error)
        XCTAssertNotNil(response)
          guard let productsCount = response?.products.count else {
          XCTFail("Error in products count in response")
          return
        }
        XCTAssertEqual(productsCount, 12)
      }
    }
}
