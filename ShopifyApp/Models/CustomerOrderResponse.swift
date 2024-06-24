//
//  CustomerOrderResponse.swift
//  ShopifyApp
//
//  Created by Israa Assem on 15/06/2024.
//

import Foundation
struct CustomerOrdersResponse:Codable{
    let orders:[Order]?
}
struct Order: Codable {
    let id: Int?
    let contactEmail: String?
    let createdAt: String?
    let currency: String?
    let currentTotalPrice: String?
    let email: String?
    let number: Int?
    let orderNumber: Int?
    let presentmentCurrency: String?
    let processedAt: String?
    let subtotalPrice,totalPrice: String?
    let totalWeight: Int?
    let updatedAt: String?
    let customer: Customer?
    let lineItems: [LineItem]?
    let shippingAddress: Address?
    
    enum CodingKeys: String, CodingKey {
        case id
        case contactEmail = "contact_email"
        case createdAt = "created_at"
        case currency
        case currentTotalPrice = "current_total_price"
        case email
        case number
        case orderNumber = "order_number"
        case presentmentCurrency = "presentment_currency"
        case processedAt = "processed_at"
        case subtotalPrice = "subtotal_price"
        case totalPrice = "total_price"
        case totalWeight = "total_weight"
        case updatedAt = "updated_at"
        case customer
        case lineItems = "line_items"
        case shippingAddress = "shipping_address"
    }
}
