//
//  PriceRule.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 08/06/2024.
//

import Foundation

// MARK: - PriceRulesResponse
struct PriceRulesResponse: Codable {
    let priceRules: [PriceRule]

    enum CodingKeys: String, CodingKey {
        case priceRules = "price_rules"
    }
}

// MARK: - PriceRule
struct PriceRule: Codable {
    let id: Int
    let valueType, value, title: String

    enum CodingKeys: String, CodingKey {
        case id
        case valueType = "value_type"
        case value, title
    }
}
