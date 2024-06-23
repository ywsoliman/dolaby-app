//
//  OrdersViewModel.swift
//  ShopifyApp
//
//  Created by Israa Assem on 15/06/2024.
//

import Foundation
protocol OrdersViewModelProtocol{
    func getOrders()->[Order]
    func getOrdersCount()->Int
    var bindOrdersToViewController:()->Void { get set }
    func fetchOrders()->Void
    func deleteOrder(orderId:Int)->Void
}
class OrdersViewModel:OrdersViewModelProtocol{

    private let service: NetworkService
    var bindOrdersToViewController:()->Void={}
    var Orders:[Order]?=nil
    init(service: NetworkService) {
        self.service = service
    }
    func fetchOrders(){
        service.makeRequest(endPoint: "/customers/\(CurrentUser.user?.id ?? 8136296333612)/orders.json", method: .get) {[weak self] (result: Result<CustomerOrdersResponse, APIError>) in
            switch result {
            case .success(let response):
                self?.Orders=response.orders
                self?.bindOrdersToViewController()
            case .failure(let error):
                print("Error in retrieving orders: \(error)")
            }
        }
    }
    func deleteOrder(orderId: Int) {
        service.makeRequest(endPoint: "/orders/\(orderId).json", method: .delete) {[weak self] (result: Result<EmptyResponse, APIError>) in
            switch result {
            case .success(let response):
                self?.fetchOrders()
            case .failure(let error):
                print("Error in deleting order: \(error)")
            }
        }
    }
    
    func getOrders()->[Order]{
        return Orders ?? []
    }
    func getOrdersCount()->Int{
        return Orders?.count ?? 0
    }
    
}
