//
//  NetworkServiceProtocol.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 02/06/2024.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    func makeRequest<T: Decodable>(
        endPoint: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders,
        completion: @escaping (Result<T, APIError>) -> Void
    )
}
