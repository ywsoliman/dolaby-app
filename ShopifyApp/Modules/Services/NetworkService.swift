//
//  NetworkService.swift
//  ShopifyApp
//
//  Created by Israa Assem on 01/06/2024.
//

import Foundation
//import Alamofire
//class NetworkService:NetworkServiceProtocol{
//    func fetchData<T:Decodable>(url:URL,completion:@escaping(Result<T,Error>)->Void){
//        AF.request(url).responseDecodable(of: T.self) { response in
//            switch response.result {
//            case .success(let data):
//                completion(.success(data))
//            case .failure(let error):
//                if let data = response.data, let jsonError = try? JSONSerialization.jsonObject(with: data, options: []) {
//                            print("JSON Error: \(jsonError)")
//                        }
//                print("Error....",error.localizedDescription)
//                completion(.failure(error))
//            }
//        }
//    }
//}
