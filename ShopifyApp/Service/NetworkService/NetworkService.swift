//
//  NetworkService.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 02/06/2024.
//

import Foundation
import Alamofire

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case decodingFailed(Error)
}

struct NetworkService: NetworkServiceProtocol {
    
    static let shared = NetworkService()
    private let BASE_URL = "https://mad44-sv-ios3.myshopify.com/admin/api/2024-04"
    
    private init() {}
    
    func makeRequest<T: Decodable>(
        endPoint: String,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        headers: HTTPHeaders = ["X-Shopify-Access-Token": APIKey],
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        
        let urlWithEndPoint = BASE_URL + endPoint
        guard let url = URL(string: urlWithEndPoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        AF.request(url, method: method, parameters: parameters, headers: headers)
            .validate()
            .responseData { response in
                
                switch response.result {
                case .success(let data):
                    
                    do {
                        #if DEBUG
                        if let jsonString = String(data: data, encoding: .utf8) {
                                                    print("Returned JSON: \(jsonString)")
                        }
                        #endif
                        let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedResponse))
                    } catch let decodingError {
                        completion(.failure(.decodingFailed(decodingError)))
                    }
                case .failure(let error):
                    completion(.failure(.requestFailed(error)))
                    
                }
            }
        
    }
    
    func getCart(completion: @escaping (Result<DraftOrderResponse, APIError>) -> Void) {
        
        guard let cartId = CurrentUser.user?.cartID else { return }
        makeRequest(
            endPoint: "/draft_orders/\(cartId).json",
            method: .get,
            completion: completion
        )
        
    }
    
}
