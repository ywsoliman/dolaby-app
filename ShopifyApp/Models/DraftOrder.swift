//
//  DraftOrder.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 02/06/2024.
//

import Foundation

struct DraftOrder: Codable {
    let draftOrders: [SingleDraftOrder]

    enum CodingKeys: String, CodingKey {
        case draftOrders = "draft_orders"
    }
}

struct SingleDraftOrder: Codable {
    let id: Int
    let email, currency: String
    let taxExempt: Bool
    let completedAt: String?
    var lineItems: [LineItem]
    let shippingAddress: CustomerAddress
    let appliedDiscount, orderID, shippingLine: String??
    let totalPrice, subtotalPrice: String
    let paymentTerms: String?
    let customer: Customer

    enum CodingKeys: String, CodingKey {
        case id, email, currency
        case taxExempt = "tax_exempt"
        case completedAt = "completed_at"
        case lineItems = "line_items"
        case shippingAddress = "shipping_address"
        case appliedDiscount = "applied_discount"
        case orderID = "order_id"
        case shippingLine = "shipping_line"
        case totalPrice = "total_price"
        case subtotalPrice = "subtotal_price"
        case paymentTerms = "payment_terms"
        case customer
    }
}

struct LineItem: Codable {
    let id, variantID, productID: Int
    let title, variantTitle, sku, vendor: String
    let quantity: Int
    let appliedDiscount: String?
    let name, price: String

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
