//
//  Brand.swift
//  ShopifyApp
//
//  Created by Israa Assem on 01/06/2024.
//

import Foundation

struct BrandsResponse: Codable {
    let brands: [Brand]

    enum CodingKeys: String, CodingKey {
        case brands = "smart_collections"
    }
}

struct Brand: Codable {
    let id: Int?
    let handle, title: String?
//    let updatedAt: Date?
//    let bodyHTML: String?
//    let publishedAt: Date?
//    let sortOrder: SortOrder?
//    let disjunctive: Bool?
//    let adminGraphqlAPIID: String?
    let image: Image?

    enum CodingKeys: String, CodingKey {
        case id, handle, title
//        case updatedAt = "updated_at"
//        case bodyHTML = "body_html"
//        case publishedAt = "published_at"
//        case sortOrder = "sort_order"
//        case disjunctive
//        case adminGraphqlAPIID = "admin_graphql_api_id"
        case image
    }
}
struct Image: Codable {
//    let createdAt: Date?
//    let alt: String?
//    let width, height: Int?
    let src: String?

    enum CodingKeys: String, CodingKey {
       // case createdAt = "created_at"
        //case alt, width, height, src
        case src
    }
}

