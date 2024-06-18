//
//  ProductsResponse.swift
//  ShopifyApp
//
//  Created by Israa Assem on 9/06/2024.
//

import Foundation

struct ProductsResponse: Codable {
    let products: [CategoriesProduct]
}
struct CategoriesProduct: Codable {
    let id: Int
    let title:String
    let bodyHTML, vendor, productType, handle: String
    let createdAt, updatedAt, publishedAt: String
    let templateSuffix: String?
    let publishedScope: String
    let tags: String
    let status: String
    let adminGraphqlAPIID: String
    let variants: [Variant]
    let options: [ProductOption]
    let images: [ProductImage]
    let image: ProductImage?

    enum CodingKeys: String, CodingKey {
        case  title
     
        case id
        case bodyHTML = "body_html"
        case vendor
        case productType = "product_type"
        case handle
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case publishedAt = "published_at"
        case templateSuffix = "template_suffix"
        case publishedScope = "published_scope"
        case tags, status, options, images
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case variants, image
    }
}
//
//struct Variant: Codable {
//    let id: Int64
//    let productID: Int64
//    let title, price, sku: String
//    let position: Int
//    let inventoryPolicy: String
//    let compareAtPrice: String?
//    let fulfillmentService, inventoryManagement: String
//    let option1, option2, option3: String?
//    let createdAt, updatedAt: String
//    let taxable: Bool
//    let barcode: String?
//    let grams: Int
//    let weight: Double
//    let weightUnit: String
//    let inventoryItemID: Int64
//    let inventoryQuantity, oldInventoryQuantity: Int
//    let requiresShipping: Bool
//    let adminGraphqlAPIID: String
//    let imageID: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case productID = "product_id"
//        case title, price,sku
//        case  position
//        case inventoryPolicy = "inventory_policy"
//        case compareAtPrice = "compare_at_price"
//        case fulfillmentService = "fulfillment_service"
//        case inventoryManagement = "inventory_management"
//        case option1, option2, option3
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case taxable, barcode, grams, weight
//        case weightUnit = "weight_unit"
//        case inventoryItemID = "inventory_item_id"
//        case inventoryQuantity = "inventory_quantity"
//        case oldInventoryQuantity = "old_inventory_quantity"
//        case requiresShipping = "requires_shipping"
//        case adminGraphqlAPIID = "admin_graphql_api_id"
//        case imageID = "image_id"
//    }
//}

struct ProductOption: Codable {
    let id: Int64
    let productID: Int64
    let name: String
    let position: Int
    let values: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case name, position, values
    }
}


struct ProductImage: Codable {
    let id: Int64
    let alt: String?
    let position: Int
    let productID: Int64
    let createdAt, updatedAt: String
    let adminGraphqlAPIID: String
    let width, height: Int
    let src: String
    let variantIDs: [Int64]

    enum CodingKeys: String, CodingKey {
        case id, alt, position
        case productID = "product_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case width, height, src
        case variantIDs = "variant_ids"
    }
}




