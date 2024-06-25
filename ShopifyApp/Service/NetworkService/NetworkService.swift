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
    private let queue = DispatchQueue.global(qos: .utility)
    
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
        
        var encoding: ParameterEncoding = URLEncoding.default
        if method == .post || method == .put {
            encoding = JSONEncoding.default
        }
        
        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .validate()
            .cacheResponse(using: .cache)
            .responseData() { response in
                
                switch response.result {
                case .success(let data):
                    
                    do {
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
    
    func getCart(withId id: String, completion: @escaping (Result<DraftOrderResponse, APIError>) -> Void) {
        
        makeRequest(
            endPoint: "/draft_orders/\(id).json",
            method: .get,
            completion: completion
        )
        
    }
    
}
