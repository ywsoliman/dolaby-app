//
//  BrandsServiceMockTests.swift
//  ShopifyAppTests
//
//  Created by Israa Assem on 23/06/2024.
//

import XCTest
@testable import ShopifyApp
final class BrandsServiceMockTests: XCTestCase {

    private var brandsServiceMock: BrandsServiceMock!
    
    override func setUpWithError() throws {
        brandsServiceMock = BrandsServiceMock()
    }
    
    override func tearDownWithError() throws {
        brandsServiceMock = nil
    }

    func testFetchingBrandsSuccess() {
        brandsServiceMock.shouldFail = false
        brandsServiceMock.getBrands { response, error in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
        }
    }
    
    func testFetchingBrandsFailure() {
        brandsServiceMock.shouldFail = true
        brandsServiceMock.getBrands { response, error in
            XCTAssertNotNil(error)
            XCTAssertNil(response)
        }
        
    }
    func testFetchingBrandsSuccess_ContainsIPodsCollection() {
      brandsServiceMock.getBrands { response, error in
        XCTAssertNil(error)
        XCTAssertNotNil(response)
          guard let collections = response?.brands else {
          XCTFail("Missing smart_collections in response")
          return
        }
        let ipodCollection = collections.first!
        XCTAssertEqual(ipodCollection.id, 1063001380)
        XCTAssertEqual(ipodCollection.title, "IPods")
      }
    }
    func testFetchingBrandsSuccess_NumberOfBrands() {
      brandsServiceMock.getBrands { response, error in
        XCTAssertNil(error)
        XCTAssertNotNil(response)
          guard let brandsCount = response?.brands.count else {
          XCTFail("Error in brands count in response")
          return
        }
        XCTAssertEqual(brandsCount, 1)
      }
    }
    func testDecodingError() {
      let invalidData = Data("Invalid JSON".utf8)
      do {
        _ = try JSONDecoder().decode(BrandsResponse.self, from: invalidData)
        XCTFail("Expected decoding error")
      } catch {
          XCTAssertTrue(error is DecodingError)
      }
    }
    
    func testFirstBrandId(){
        brandsServiceMock.getBrands { response, error in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
              guard let brands = response?.brands.first else {
              XCTFail("Error in retrieving first brand")
              return
            }
            XCTAssertEqual(brands.id, 1063001380)
        }
    }
}
