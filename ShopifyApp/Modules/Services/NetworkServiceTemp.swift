//
//  NetworkService.swift
//  ShopifyApp
//
//  Created by Israa Assem on 01/06/2024.
//

import Foundation
class NetworkServiceTest:NetworkServiceProtocolTemp{
    func fetchData<T:Decodable>(url:URL,completion : @escaping (Result<T,Error>) -> Void){
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            guard let data = data else {
                print("Error: No data received.")
                completion(.failure(ResponseError.noRetrievedData))
                return
            }
            do {
                let brandResponse = try JSONDecoder().decode(BrandsResponse.self, from: data)
                
                completion(.success(brandResponse as! T))
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }

    enum ResponseError:Error{
        case noRetrievedData
    }
}
