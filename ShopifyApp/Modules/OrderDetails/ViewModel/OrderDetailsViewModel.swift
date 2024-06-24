//
//  OrderDetailsViewModel.swift
//  ShopifyApp
//
//  Created by Israa Assem on 17/06/2024.
//

import Foundation
protocol OrderDetailsViewModelProtocol{
    func getOrder()->OrderDetails?
    func fetchOrder(orderId:Int)->Void
    var bindOrderToViewController:()->Void{get set}
    func getProductImage(productId:Int, completion:@escaping (String?)->())

}
class OrderDetailsViewModel:OrderDetailsViewModelProtocol{

    var networkService:NetworkService?=nil
    init(network:NetworkService){
        self.networkService=network
    }
    var order:OrderDetails?=nil
    var images:[Image]?=nil
    var bindOrderToViewController:()->Void={}
    func fetchOrder(orderId:Int){
        networkService?.makeRequest(endPoint: "/orders/\(orderId).json", method: .get) {[weak self] (result: Result<OrderResponse, APIError>) in
            switch result {
            case .success(let response):
                self?.order=response.order
                self?.bindOrderToViewController()
            case .failure(let error):
                print("Error in retrieving order: \(error)")
            }
        }
    }
    func getOrder() -> OrderDetails? {
        return order
    }
    
    func getProductImage(productId: Int, completion: @escaping (String?) -> ())  {
        networkService?.makeRequest(endPoint: "/products/\(productId)/images.json", method: .get) {[weak self] (result: Result<ProductImages, APIError>) in
            switch result {
            case .success(let response):
                self?.images=response.images
                completion(response.images.first?.src)
            case .failure(let error):
                print("Error in retrieving images: \(error)")
                completion(nil)
            }
        }
    }
    
    
}
