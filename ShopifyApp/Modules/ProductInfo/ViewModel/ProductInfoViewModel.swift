//
//  ProductInfoViewModel.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 11/06/2024.
//

import Foundation
final class ProductInfoViewModel{
    private let networkService:NetworkService
    var productInfo:Product = Product.empty
    var bindToViewController:((_ productInfo:Product)->()) = {_ in }
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
       func getProduct(productID:Int){
            networkService.makeRequest(
                endPoint: "/products/\(productID).json",
                method: .get
            ) {[weak self] (result: Result<ProductResponse, APIError>) in
                switch result {
                case .success(let productInfo):
                    self?.productInfo = productInfo.product
                    self?.bindToViewController(productInfo.product)
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
}
