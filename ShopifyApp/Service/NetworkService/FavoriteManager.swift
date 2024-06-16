//
//  FavoriteManager.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 15/06/2024.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class FavoritesManager {
    static let shared = FavoritesManager()
    var favItems:[FavoriteItem] = []
    private let databaseRef = Database.database(url: "https://e-commerce-c640e-default-rtdb.firebaseio.com/").reference()
    
    func addFavoriteItem(favItem:FavoriteItem) throws {
        let userID = try LocalDataSource.shared.retrieveCustomerId()
        var throwError = false
        let itemRef = databaseRef.child("users").child(String(userID)).child("favorites").child(String(favItem.id))
        itemRef.setValue(["itemName": favItem.itemName, "imageURL": favItem.imageURL]){ error, _ in
            if let _ = error {
                throwError = true
            } else {
                self.favItems.append(favItem)
                }
                
            }
        if throwError {
            throw NSError(domain: "com.yourapp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Couldn't add to favorites"])
        }
    }
    
    func fetchFavoriteItems(completion: @escaping ([FavoriteItem]) -> Void) throws{
        let userID = try LocalDataSource.shared.retrieveCustomerId()
        databaseRef.child("users").child(String(userID)).child("favorites").observeSingleEvent(of: .value, with: { snapshot in
            var items: [FavoriteItem] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let value = snapshot.value as? [String: Any],
                   let itemName = value["itemName"] as? String,
                   let imageURL = value["imageURL"] as? String {
                    let item = FavoriteItem(id: Int(snapshot.key) ?? 0, itemName: itemName, imageURL: imageURL)
                    items.append(item)
                }
            }
            self.favItems = items
            completion(items)
        })
    }
    func deleteFavoriteItem(itemId: Int)throws {
        let userID = try LocalDataSource.shared.retrieveCustomerId()
        var throwError = false
        databaseRef.child("users").child(String(userID)).child("favorites").child(String(itemId)).removeValue { error, _ in
            if let _ = error {
                throwError = true
            } else {
                if let index = self.favItems.firstIndex(where: { $0.id == itemId }) {
                    self.favItems.remove(at: index)
                }
                
            }
        }
        if throwError {
            throw NSError(domain: "com.yourapp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Couldn't remove from favorites"])
        }
    }
    
}
