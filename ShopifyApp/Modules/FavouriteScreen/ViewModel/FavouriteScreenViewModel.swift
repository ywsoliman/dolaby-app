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
    init(favSerivce: FavoritesManager) {
        self.favSerivce = favSerivce
    }
    func fetchFavouriteItems() {
        do{
          try favSerivce.fetchFavoriteItems { [weak self] items in
                        self?.favouriteItems = items
                        self?.bindToViewController()
                }
        }catch{
            print("ERror fethcing fav items")
        }
      
        }
    
    func addToFav(favItem:FavoriteItem){
        do{
            try favSerivce.addFavoriteItem(favItem:favItem )
        }catch{
            print("Errror in saving fav item")
        }
    }
        func deleteFavouriteItem(itemId: Int) {
            do{
               try favSerivce.deleteFavoriteItem(itemId: itemId)
                fetchFavouriteItems()
            }catch{
                print("Deleting favorite Item Error")
            }
           
        }
}
