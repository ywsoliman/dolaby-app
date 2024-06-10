//
//  CurrencyService.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 10/06/2024.
//

import Foundation
import Alamofire

struct CurrencyService {
    
    static let shared = CurrencyService()
    
    private init() {}
    
    func makeRequest() {
        
        let url = "https://api.currencyapi.com/v3/latest?apikey=\(CURRENCY_KEY)&currencies=EGP"
        AF.request(url).responseDecodable(of: CurrencyResponse.self) { response in
            
            switch response.result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print("Currency error: \(error)")
            }
            
        }
        
    }
    
}
