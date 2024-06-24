//
//  CategoriesServiceMock.swift
//  ShopifyAppTests
//
//  Created by Israa Assem on 23/06/2024.
//

import Foundation
@testable import ShopifyApp
struct CategoriesServiceMock {
    var shouldFail: Bool = false
    private let fakeCategoriesProducts:[String:Any]=[
        "products": [
            "id": 632910392,
            "title": "IPod Nano - 8GB",
            "body_html": "",
            "vendor": "Apple",
            "product_type": "Cult Products",
            "created_at": "2024-04-01T13:52:26-04:00",
            "handle": "ipod-nano",
            "updated_at": "2024-04-01T13:52:26-04:00",
            "published_at": "2007-12-31T19:00:00-05:00",
            "template_suffix":NSNull(),
            "published_scope": "web",
            "tags": "Emotive, Flash Memory, MP3, Music",
            "status": "active",
            "admin_graphql_api_id": "gid://shopify/Product/632910392",
            "variants": [],
            "options":[],
            "images":[],
            "image":NSNull()
            ]
    ]
//
//                [
//                    "id": 808950810,
//                    "product_id": 632910392,
//                    "title": "Pink",
//                    "price": "199.00",
//                    "sku": "IPOD2008PINK",
//                    "position": 1,
//                    "inventory_policy": "continue",
//                    "compare_at_price": nil,
//                    "fulfillment_service": "manual",
//                    "inventory_management": "shopify",
//                    "option1": "Pink",
//                    "option2": nil,
//                    "option3": nil,
//                    "created_at": "2024-04-01T13:52:26-04:00",
//                    "updated_at": "2024-04-01T13:52:26-04:00",
//                    "taxable": "true",
//                    "barcode": "1234_pink",
//                    "grams": 567,
//                    "weight": 1.25,
//                    "weight_unit": "lb",
//                    "inventory_item_id": 808950810,
//                    "inventory_quantity": 10,
//                    "old_inventory_quantity": 10,
//                    "presentment_prices": [
//                        [
//                            "price": [
//                                "amount": "199.00",
//                                "currency_code": "USD"
//                            ],
//                            "compare_at_price": nil
//                        ]
//                    ],
//                    "requires_shipping": true,
//                    "admin_graphql_api_id": "gid://shopify/ProductVariant/808950810",
//                    "image_id": 562641783
//                ]
//            ],
//            "options": [
//                
//                [
//                    "id": 594680422,
//                    "product_id": 632910392,
//                    "name": "Color",
//                    "position": 1,
//                    "values": [
//                        "Pink",
//                        "Red",
//                        "Green",
//                        "Black"
//                    ]
//                ]
//            ],
//            "images": [
//                [
//                    "id": 850703190,
//                    "alt": nil,
//                    "position": 1,
//                    "product_id": 632910392,
//                    "created_at": "2024-04-01T13:52:26-04:00",
//                    "updated_at": "2024-04-01T13:52:26-04:00",
//                    "admin_graphql_api_id": "gid://shopify/ProductImage/850703190",
//                    "width": 123,
//                    "height": 456,
//                    "src": "https://cdn.shopify.com/s/files/1/0005/4838/0009/products/ipod-nano.png?v=1711993946",
//                    "variant_ids": []
//                ]
//            ],
//            "image": [
//                "id": 850703190,
//                "alt": nil,
//                "position": 1,
//                "product_id": 632910392,
//                "created_at": "2024-04-01T13:52:26-04:00",
//                "updated_at": "2024-04-01T13:52:26-04:00",
//                "admin_graphql_api_id": "gid://shopify/ProductImage/850703190",
//                "width": 123,
//                "height": 456,
//                "src": "https://cdn.shopify.com/s/files/1/0005/4838/0009/products/ipod-nano.png?v=1711993946",
//                "variant_ids": []
//            ]
//        ]
//    ]
    
    func getCategoriesProducts(completion: @escaping (ProductsResponse?, Error?) -> Void) {
        
        var productsResponse: ProductsResponse?
        
        do {
            let data = try JSONSerialization.data(withJSONObject: fakeCategoriesProducts)
            productsResponse = try JSONDecoder().decode(ProductsResponse.self, from: data)
        } catch {
            print("Mock CategoriesProducts error \(error)")
        }
        
        //shouldFail ? completion(nil, NetworkError.genericError) : completion(productsResponse, nil)
        
    }
}

