//
//  Customer.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 02/06/2024.
//

import Foundation

// MARK: - Customer
struct Customer: Codable {
    let id: Int
    let email: String
    let firstName, lastName: String
    let ordersCount: Int
    let state, totalSpent: String
    let lastOrderID: Int?
    var cartID: Int?
    let verifiedEmail: Bool
    let multipassIdentifier: String?
    let taxExempt: Bool
    let tags: String
    let lastOrderName: String?
    let currency, phone: String
    let completedOrders: [DraftOrder]?
    let defaultAddress: Address?
    var addresses: [Address]?

    enum CodingKeys: String, CodingKey {
        case id, email
        case firstName = "first_name"
        case lastName = "last_name"
        case ordersCount = "orders_count"
        case state
        case totalSpent = "total_spent"
        case lastOrderID = "last_order_id"
        case cartID = "note"
        case verifiedEmail = "verified_email"
        case multipassIdentifier = "multipass_identifier"
        case taxExempt = "tax_exempt"
        case tags
        case lastOrderName = "last_order_name"
        case currency, phone
        case completedOrders = "tax_exemptions"
        case defaultAddress = "default_address"
        case addresses
    }
}

struct CustomerAddresses: Codable {
    let addresses: [Address]
}

struct CustomerAddress: Codable {
    let customerAddress: Address
    
    enum CodingKeys: String, CodingKey {
        case customerAddress = "customer_address"
    }
}
struct CustomerResponse:Codable{
    let customer:Customer
}
