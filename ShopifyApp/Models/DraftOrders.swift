//
//  DraftOrder.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 02/06/2024.
//

import Foundation

struct DraftOrderResponse: Codable {
    let draftOrder: DraftOrder

    enum CodingKeys: String, CodingKey {
        case draftOrder = "draft_order"
    }
}

struct DraftOrder: Codable {
    let id: Int
    let email: String
    let currency: String
    let completedAt: String?
    let name, status: String
    var lineItems: [LineItem]
    let shippingAddress, billingAddress: Address
    let orderID: Int?
    let appliedDiscount: AppliedDiscount?
    let totalPrice, subtotalPrice: String
    let customer: Customer

    enum CodingKeys: String, CodingKey {
        case id, email
        case currency
        case completedAt = "completed_at"
        case name, status
        case lineItems = "line_items"
        case shippingAddress = "shipping_address"
        case billingAddress = "billing_address"
        case appliedDiscount = "applied_discount"
        case orderID = "order_id"
        case totalPrice = "total_price"
        case subtotalPrice = "subtotal_price"
        case customer
    }
}

struct AppliedDiscount: Codable {
    let description, value, title, amount: String
    let valueType: String

    enum CodingKeys: String, CodingKey {
        case description, value, title, amount
        case valueType = "value_type"
    }
}

// MARK: - LineItem
struct LineItem: Codable {
    let id, variantID, productID: Int
    let title, variantTitle, sku, vendor: String
    let quantity: Int
    let appliedDiscount: AppliedDiscount?
    let name: String
    let price: String

    enum CodingKeys: String, CodingKey {
        case id
        case variantID = "variant_id"
        case productID = "product_id"
        case title
        case variantTitle = "variant_title"
        case sku, vendor, quantity
        case appliedDiscount = "applied_discount"
        case name, price
    }
    
}
