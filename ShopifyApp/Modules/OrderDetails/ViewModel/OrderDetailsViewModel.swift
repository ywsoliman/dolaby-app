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
  //  func getProductImage(productId:Int,completion:(String?)->())

}
class OrderDetailsViewModel:OrderDetailsViewModelProtocol{

    var networkService:NetworkService?=nil
    init(network:NetworkService){
        self.networkService=network
    }
    var order:OrderDetails?=nil
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
    
//    func getProductImage(productId: Int,@escaping completion: (String?) -> ())  {
//        networkService?.makeRequest(endPoint: "/orders/\(orderId).json", method: .get) {[weak self] (result: Result<OrderResponse, APIError>) in
//            switch result {
//            case .success(let response):
//                self?.order=response.order
//            case .failure(let error):
//                print("Error in retrieving order: \(error)")
//            }
//        }
//    }
    
    
}
