//
//  FavouriteScreenViewModel.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 15/06/2024.
//

import Foundation

final class FavouriteViewModel{
    private var favSerivce:FavoritesManager
    var favouriteItems: [FavoriteItem] = []
    var bindToViewController:(()->())={}
    @Published var succcessful:Bool = false
    @Published var errorMessage:String = ""
    init(favSerivce: FavoritesManager) {
        self.favSerivce = favSerivce
    }
    func fetchFavouriteItems() {
        do{
            let userID = try LocalDataSource.shared.retrieveCustomerId()
            try favSerivce.fetchFavoriteItems(userID:userID) { [weak self] items in
                        self?.favouriteItems = items
                        self?.bindToViewController()
                }
            self.succcessful = true
        }catch{
            self.succcessful = false
            self.favouriteItems = []
            self.favSerivce.favItems = []
            errorMessage = error.localizedDescription
            print("ERror fethcing fav items")
        }
      
    }
    
    func addToFav(favItem:FavoriteItem){
        do{
            let userID = try LocalDataSource.shared.retrieveCustomerId() 
            try favSerivce.addFavoriteItem(userID:userID,favItem:favItem )
            updateFavItems()
        }catch{
            print("Errror in saving fav item")
        }
    }
    func updateFavItems(){
        favouriteItems = favSerivce.favItems
    }
    func deleteFavouriteItem(itemId: Int) {
        do{
            let userID = try LocalDataSource.shared.retrieveCustomerId()
            try favSerivce.deleteFavoriteItem(userID:userID,itemId: itemId)
            fetchFavouriteItems()
        }catch{
            print("Deleting favorite Item Error")
        }
           
    }
    func isFavoriteItem(withId id: Int) -> Bool {
        return favSerivce.favItems.contains { $0.id == id }
    }
}
