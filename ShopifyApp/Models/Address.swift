//
//  Address.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 07/06/2024.
//

import Foundation

// MARK: - Address
struct Address: Codable {
    let firstName, address1: String
    let phone: String?
    let city: String
    let zip, province: String?
    let country, lastName: String
    let address2, company: String?
    let latitude, longitude: Double?
    let name, countryCode: String
    let provinceCode: String?
    let id, customerID: Int?
    let countryName: String?
    let addressDefault: Bool?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case address1, phone, city, zip, province, country
        case lastName = "last_name"
        case address2, company, latitude, longitude, name
        case countryCode = "country_code"
        case provinceCode = "province_code"
        case id
        case customerID = "customer_id"
        case countryName = "country_name"
        case addressDefault = "default"
    }
}
