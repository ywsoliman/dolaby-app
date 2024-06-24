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
    let image: Image?

    enum CodingKeys: String, CodingKey {
        case id, handle, title
        case image
    }
}
struct Image: Codable {
    let src: String?
    enum CodingKeys: String, CodingKey {
        case src
    }
}

