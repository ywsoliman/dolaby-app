//
//  Customer.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 02/06/2024.
//

import Foundation

struct Customer: Codable {
    let id: Int?
    let email, firstName, lastName: String?
    let ordersCount: Int?
    let totalSpent: String?
    let lastOrderID: String?
    let verifiedEmail, taxExempt: Bool?
    let lastOrderName: String?
    let currency, phone: String?
    let addresses: [CustomerAddress]?
    let defaultAddress: CustomerAddress?
    
    enum CodingKeys: String, CodingKey {
        case id, email
        case firstName = "first_name"
        case lastName = "last_name"
        case ordersCount = "orders_count"
        case totalSpent = "total_spent"
        case lastOrderID = "last_order_id"
        case verifiedEmail = "verified_email"
        case taxExempt = "tax_exempt"
        case lastOrderName = "last_order_name"
        case currency, phone, addresses
        case defaultAddress = "default_address"
    }
}

struct CustomerAddress: Codable {
    
    let id, customerID: Int?
    let firstName, lastName, address1, city: String?
    let country, phone, name, countryCode: String?
    let countryName: String?
    let addressDefault: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case address1, city, country, phone, name
        case countryCode = "country_code"
        case countryName = "country_name"
        case addressDefault = "default"
    }
    
    
}
