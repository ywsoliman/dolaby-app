//
//  Currency.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 10/06/2024.
//

import Foundation

// MARK: - CurrencyResponse
struct CurrencyResponse: Codable {
    let result, baseCode: String
    let conversionRates: [String: Double]

    enum CodingKeys: String, CodingKey {
        case result
        case baseCode = "base_code"
        case conversionRates = "conversion_rates"
    }
}
