//
//  BrandsServiceMock.swift
//  ShopifyAppTests
//
//  Created by Israa Assem on 23/06/2024.
//

import Foundation
@testable import ShopifyApp
struct BrandsServiceMock {
    var shouldFail: Bool = false
    private let fakeBrands:[String:Any]=[
        "smart_collections": [
          [
            "id": 1063001380,
            "handle": "ipods-1",
            "title": "IPods",
            "updated_at": "2024-05-14T21:24:58-04:00",
            "body_html": nil,
            "published_at": "2024-05-14T21:24:58-04:00",
            "sort_order": "best-selling",
            "template_suffix": nil,
            "disjunctive": false,
            "rules": [
              [
                "column": "title",
                "relation": "starts_with",
                "condition": "iPod"
              ]
            ],
            "published_scope": "web",
            "admin_graphql_api_id": "gid://shopify/Collection/1063001380"
          ]
        ]
      ]
    func getBrands(completion: @escaping (BrandsResponse?, Error?) -> Void) {
        
        var brandsResponse: BrandsResponse?
        
        do {
            let data = try JSONSerialization.data(withJSONObject: fakeBrands)
            brandsResponse = try JSONDecoder().decode(BrandsResponse.self, from: data)
        } catch {
            print("Mock brands error \(error)")
        }
        
        shouldFail ? completion(nil, NetworkError.genericError) : completion(brandsResponse, nil)
        
    }
}
