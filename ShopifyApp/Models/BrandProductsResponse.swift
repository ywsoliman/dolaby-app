//
//  BrandProducts.swift
//  ShopifyApp
//
//  Created by Israa Assem on 9/06/2024.
//

import Foundation
struct BrandProductsResponse: Codable {
    let products: [BrandsProduct]
}

struct BrandsProduct: Codable {
    let id: Int
    let title,  vendor, productType: String
    let createdAt: String
    let handle: String
    let updatedAt, publishedAt: String
    let publishedScope, tags: String
    let image: Image
    let status, adminGraphqlAPIID: String
    let options: [Options]
    let images: [Image]

    enum CodingKeys: String, CodingKey {
        case id, title
        case vendor
        case productType = "product_type"
        case createdAt = "created_at"
        case handle
        case updatedAt = "updated_at"
        case publishedAt = "published_at"
        case publishedScope = "published_scope"
        case tags, image, status
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case options, images
    }
}

struct BrandProductImage: Codable {
    let id, productID, position: Int
    let createdAt, updatedAt: Date
    let alt: String?
    let width, height: Int
    let src: String
    let variantIDS: [String]
    let adminGraphqlAPIID: String

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case position
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case alt, width, height, src
        case variantIDS = "variant_ids"
        case adminGraphqlAPIID = "admin_graphql_api_id"
    }
}

struct Options: Codable {
    let id, productID: Int
    let name: String
    let position: Int

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case name, position
    }
}
