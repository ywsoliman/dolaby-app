//
//  OrderResponse.swift
//  ShopifyApp
//
//  Created by Israa Assem on 15/06/2024.
//

import Foundation
struct OrderResponse: Codable {
  let order: OrderDetails?
}
struct OrderDetails: Codable {
  let id:Int?
  let created_at: String?
  let currency: String?
  let email: String?
  let total_price: String?
  let customer: CustomerModel?
  let line_items: [LineItemModel]?
}
