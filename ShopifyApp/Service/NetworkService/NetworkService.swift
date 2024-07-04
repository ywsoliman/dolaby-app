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
    case apiError(String)
    case validationError([String: [String]])
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .requestFailed(let error):
            return "The request failed: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return "Failed to decode the response: \(error.localizedDescription)"
        case .apiError(let message):
            return message
        case .validationError(let errors):
            return errors.map { "\($0.key): \($0.value.joined(separator: ", "))" }.joined(separator: "\n")
        }
    }
    
}

struct NetworkService: NetworkServiceProtocol {
    
    static let shared = NetworkService()
    private let BASE_URL = "https://mad44-sv-ios3.myshopify.com/admin/api/2024-04"
    private let queue = DispatchQueue.global(qos: .utility)
    
    private init() {}
    
    private func parseErrorResponse(data: Data) -> APIError {
        do {
            if let apiErrorResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let errors = apiErrorResponse["errors"] as? [String: [String]] {
                    return .validationError(errors)
                } else if let message = apiErrorResponse["message"] as? String {
                    return .apiError(message)
                } else {
                    return .apiError("An unknown error occurred.")
                }
            } else {
                return .apiError("Invalid error response format.")
            }
        } catch {
            return .requestFailed(error)
        }
    }
    
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
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedResponse))
                    } catch let decodingError {
                        completion(.failure(.decodingFailed(decodingError)))
                    }
                case .failure:
                    if let data = response.data {
                        let apiError = parseErrorResponse(data: data)
                        completion(.failure(apiError))
                    } else {
                        completion(.failure(.requestFailed(response.error!)))
                    }
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
