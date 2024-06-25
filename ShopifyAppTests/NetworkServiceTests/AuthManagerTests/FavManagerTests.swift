//
//  FavManagerTests.swift
//  ShopifyAppTests
//
//  Created by Samuel Adel on 22/06/2024.
//

import XCTest
@testable import ShopifyApp
import FirebaseDatabase
import FirebaseCore

final class FavManagerTests: XCTestCase {

    var favManager: FavoritesManager!
        var databaseRef: DatabaseReference!
    override func setUp() {
        super.setUp()
        // if the simulateor didn't start uncomment the following line
        //FirebaseApp.configure()
        
        favManager = FavoritesManager.shared
     
    }
        func testFetchFavoriteItems() throws {
            let expectation = self.expectation(description: "Fetch favorite items expectation")
            // Act
            try favManager.fetchFavoriteItems(userID: 111111) { fetchedItems in
                // Assert
                XCTAssertEqual(fetchedItems.count, 1)
                expectation.fulfill()
            }

            // Wait for the expectation to be fulfilled
            waitForExpectations(timeout: 10, handler: nil)
        }

        func testAddFavoriteItem() throws {
            // Arrange
            let favItem = FavoriteItem(id: 1, itemName: "Test Item", imageURL: "https://example.com/image.jpg")
            let expectation = self.expectation(description: "Add favorite item expectation")

            // Act
            do{
                try favManager.addFavoriteItem(userID:111111,favItem: favItem)
                expectation.fulfill()
            }catch{
                XCTFail(error.localizedDescription)
                expectation.fulfill()
            }
            // Wait for the expectation to be fulfilled
            waitForExpectations(timeout: 10, handler: nil)
        }

        func testDeleteFavoriteItem() throws {
            // Arrange
            let itemIdToDelete = 1
            let expectation = self.expectation(description: "Delete favorite item expectation")

            // Add a dummy item for deletion
            let dummyItem = FavoriteItem(id: itemIdToDelete, itemName: "Dummy Item", imageURL: "https://example.com/dummy.jpg")
            do{
                try favManager.addFavoriteItem(userID:111111,favItem: dummyItem)
                expectation.fulfill()
            }catch{
                XCTFail(error.localizedDescription)
                expectation.fulfill()
            }
            waitForExpectations(timeout: 10, handler: nil)
        }

}
