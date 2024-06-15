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
    private let databaseRef = Database.database(url: "https://e-commerce-c640e-default-rtdb.firebaseio.com/").reference()
    
    func addFavoriteItem(favItem:FavoriteItem) throws {
        let userID = try LocalDataSource.shared.retrieveCustomerId()
        let itemRef = databaseRef.child("users").child(String(userID)).child("favorites").child(String(favItem.id))
        itemRef.setValue(["itemName": favItem.itemName, "imageURL": favItem.imageURL])
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
                completion(items)
            })
        }


    func deleteFavoriteItem(itemId: Int)throws {
        let userID = try LocalDataSource.shared.retrieveCustomerId()
        databaseRef.child("users").child(String(userID)).child("favorites").child(String(itemId)).removeValue()
    }
}
