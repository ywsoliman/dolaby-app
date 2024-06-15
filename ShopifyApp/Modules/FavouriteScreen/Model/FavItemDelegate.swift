//
//  FavItemDelegate.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 15/06/2024.
//

import Foundation
protocol FavItemDelegate{
    func saveFavItem(itemIndex:Int)
    func deleteFavItem(itemIndex:Int)
}
