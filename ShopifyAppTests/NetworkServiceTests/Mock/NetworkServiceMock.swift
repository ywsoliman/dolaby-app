//
//  NetworkServiceMock.swift
//  ShopifyAppTests
//
//  Created by Youssef Waleed on 14/06/2024.
//

import Foundation
@testable import ShopifyApp

enum NetworkError: Error {
    case genericError
}

struct NetworkServiceMock {
    
    var shouldFail: Bool = false
    
    private let fakeDiscountCodes: [String: Any] = [
        "price_rules": [
            [
                "id": 1436614164780,
                "value_type": "percentage",
                "value": "-50.0",
                "title": "RBQ484Y5MAQM"
            ]
        ]
    ]
    
    func getDiscountCodes(completion: @escaping (PriceRulesResponse?, Error?) -> Void) {
        
        var priceRuleResponse: PriceRulesResponse?

        do {
            let data = try JSONSerialization.data(withJSONObject: fakeDiscountCodes)
            priceRuleResponse = try JSONDecoder().decode(PriceRulesResponse.self, from: data)
        } catch {
            print("Mock error \(error)")
        }
        
        shouldFail ? completion(nil, NetworkError.genericError) : completion(priceRuleResponse, nil)
        
    }
    
}
