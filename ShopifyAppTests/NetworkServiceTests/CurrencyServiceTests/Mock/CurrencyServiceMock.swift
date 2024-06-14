//
//  CurrencyServiceMock.swift
//  ShopifyAppTests
//
//  Created by Youssef Waleed on 14/06/2024.
//

import Foundation
@testable import ShopifyApp

struct CurrencyServiceMock {
    
    var shouldFail: Bool = false
    
    private let fakeJSONCurrencies: [String: Any] = [
        "result": "success",
        "base_code": "USD",
        "conversion_rates": [
            "USD": 1,
            "AED": 3.6725,
        ]
    ]
    
    func getCurrencies(completion: @escaping (CurrencyResponse?, Error?) -> Void) {
        
        var currencyResponse: CurrencyResponse?
        
        do {
            let data = try JSONSerialization.data(withJSONObject: fakeJSONCurrencies)
            currencyResponse = try JSONDecoder().decode(CurrencyResponse.self, from: data)
        } catch {
            print("Testing fetching currencies error: \(error)")
        }
        
        shouldFail ? completion(nil, NetworkError.genericError) : completion(currencyResponse, nil)
        
    }
    
}
