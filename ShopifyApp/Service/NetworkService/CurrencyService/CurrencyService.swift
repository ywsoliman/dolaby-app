//
//  CurrencyService.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 10/06/2024.
//

import Foundation
import Alamofire

protocol CurrencyServiceProtocol {
    func fetchCurrencies(completion: @escaping (Result<CurrencyResponse, Error>) -> Void)
}

struct CurrencyService: CurrencyServiceProtocol {
    
    static let shared = CurrencyService()
    
    private init() {}
    
    func fetchCurrencies(completion: @escaping (Result<CurrencyResponse, Error>) -> Void) {
        
        let url = "https://v6.exchangerate-api.com/v6/\(CURRENCY_KEY)/latest/USD"
        AF.request(url).responseDecodable(of: CurrencyResponse.self) { response in
            
            switch response.result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                print("Currency error: \(error)")
                completion(.failure(error))
            }
            
        }
        
    }
    
}
