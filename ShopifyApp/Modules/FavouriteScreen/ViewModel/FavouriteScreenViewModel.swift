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
          try favSerivce.fetchFavoriteItems { [weak self] items in
                        self?.favouriteItems = items
                        self?.bindToViewController()
                }
            self.succcessful = true
        }catch{
            self.succcessful = false
            errorMessage = error.localizedDescription
            print("ERror fethcing fav items")
        }
      
    }
    
    func addToFav(favItem:FavoriteItem){
        do{
            try favSerivce.addFavoriteItem(favItem:favItem )
            favouriteItems.append(favItem)
        }catch{
            print("Errror in saving fav item")
        }
    }
    func updateFavItems(){
        favouriteItems = favSerivce.favItems
    }
    func deleteFavouriteItem(itemId: Int) {
        do{
            try favSerivce.deleteFavoriteItem(itemId: itemId)
            fetchFavouriteItems()
        }catch{
            print("Deleting favorite Item Error")
        }
           
    }
    func isFavoriteItem(withId id: Int) -> Bool {
        return favSerivce.favItems.contains { $0.id == id }
    }
}
