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
    let createdAt: String
    let handle: String
    let updatedAt, publishedAt: String
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
    static let empty = Product(
            id: 0,
            title: "",
            bodyHTML: "",
            vendor: "",
            productType: "",
            createdAt: "",
            handle: "",
            updatedAt: "",
            publishedAt: "",
            publishedScope: "",
            tags: "",
            status: "",
            adminGraphqlAPIID: "",
            variants: [],
            options: [],
            images: [],
            image: Image(src: "")
        )
}

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

struct VariantResponse: Codable {
    let variant: Variant
}

// MARK: - Variant
struct Variant: Codable {
    let id, productID: Int
    let title, price, sku: String
    let position: Int
    let inventoryPolicy, option1, option2: String
    let option3: String?
    let createdAt, updatedAt: String
    let taxable: Bool
    let inventoryItemID, inventoryQuantity, oldInventoryQuantity: Int

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
    }
}

struct ProductImages: Codable {
    let images: [Image]
}
struct ProductResponse :Codable{
    let product:Product
}
extension Product {
    func getSizeOptions() -> [String] {
        return options.first { $0.name.lowercased() == "size" }?.values ?? []
    }
    func getColorOptions()->[String]{
        return options.first { $0.name.lowercased() == "color" }?.values ?? []
    }
    func getVariantID(option1:String,option2:String)->Int{
        return variants.first { $0.option1.lowercased() == option1.lowercased() && $0.option2.lowercased() == option2.lowercased()}?.id ?? 0
    }
    func getVariantQuantity(option1:String,option2:String)->Int{
        return variants.first { $0.option1.lowercased() == option1.lowercased() && $0.option2.lowercased() == option2.lowercased()}?.inventoryQuantity ?? 0
    }
    func getVariantPrice(option1:String,option2:String)->String{
        return variants.first { $0.option1.lowercased() == option1.lowercased() && $0.option2.lowercased() == option2.lowercased()}?.price ?? "0.0$"
    }
}
