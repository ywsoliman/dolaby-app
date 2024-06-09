//
//  PaymentOptionsViewModel.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 09/06/2024.
//

import Foundation

struct PaymentOptionsViewModel {
    
    private let service: NetworkService
    var bindPaymentOptionsToViewController: (() -> ()) = {}
    
    init(service: NetworkService) {
        self.service = service
    }
    
    func completeOrder() {
        
        service.makeRequest(endPoint: "/draft_orders/\(CART_ID)/complete.json", method: .put) { (result: Result<DraftOrderResponse, APIError>) in
            
            switch result {
            case .success:
                bindPaymentOptionsToViewController()
            case .failure(let error):
                bindPaymentOptionsToViewController()
                print("Error in completing an order: \(error)")
            }
            
        }
        
    }
    
}
