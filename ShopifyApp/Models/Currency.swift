//
//  Currency.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 10/06/2024.
//

import Foundation

// MARK: - CurrencyResponse
struct CurrencyResponse: Codable {
    let data: Currencies
}

// MARK: - Currencies
struct Currencies: Codable {
    let egp: EGP

    enum CodingKeys: String, CodingKey {
        case egp = "EGP"
    }
}

// MARK: - EGP
struct EGP: Codable {
    let code: String
    let value: Double
}
