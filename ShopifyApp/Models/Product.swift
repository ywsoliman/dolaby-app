//
//  Product.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 02/06/2024.
//

import Foundation

// MARK: - Product
struct Product: Codable {
    let id: Int
    let title, bodyHTML, vendor, productType: String
    let createdAt: Date
    let handle: String
    let updatedAt, publishedAt: Date
    let publishedScope, tags, status, adminGraphqlAPIID: String
    let variants: [Variant]
    let options: [Option]
    let images: [Image]
    let image: Image

    enum CodingKeys: String, CodingKey {
        case id, title
        case bodyHTML = "body_html"
        case vendor
        case productType = "product_type"
        case createdAt = "created_at"
        case handle
        case updatedAt = "updated_at"
        case publishedAt = "published_at"
        case publishedScope = "published_scope"
        case tags, status
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case variants, options, images, image
    }
}

// MARK: - Image
//struct Image: Codable {
//    let id, position, productID: Int?
//    let src: String
//    let variantIDS: [String]?
//
//    enum CodingKeys: String, CodingKey {
//        case id, position
//        case productID = "product_id"
//        case src
//        case variantIDS = "variant_ids"
//    }
//}

// MARK: - Option
struct Option: Codable {
    let id, productID: Int
    let name: String
    let position: Int
    let values: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case name, position, values
    }
}

// MARK: - Variant
struct Variant: Codable {
    let id, productID: Int
    let title, price, sku: String
    let position: Int
    let inventoryPolicy, option1, option2: String
    let option3: String?
    let createdAt, updatedAt: Date
    let taxable: Bool
    let inventoryItemID, inventoryQuantity, oldInventoryQuantity: Int
    let imageID: String?

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case title, price, sku, position
        case inventoryPolicy = "inventory_policy"
        case option1, option2, option3
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case taxable
        case inventoryItemID = "inventory_item_id"
        case inventoryQuantity = "inventory_quantity"
        case oldInventoryQuantity = "old_inventory_quantity"
        case imageID = "image_id"
    }
}

struct ProductImages: Codable {
    let images: [Image]
}
