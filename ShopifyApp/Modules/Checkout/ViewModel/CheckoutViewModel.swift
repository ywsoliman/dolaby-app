//
//  CheckoutViewModel.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 05/06/2024.
//

import Foundation

class CheckoutViewModel {
    
    let service: NetworkService
    let subtotalPrice: Double
    var draftOrder: DraftOrder {
        didSet {
            bindDraftOrderToViewController()
        }
    }
    var bindDraftOrderToViewController: (() -> ()) = {}
    
    init(service: NetworkService, draftOrder: DraftOrder, subtotal: Double) {
        self.service = service
        self.draftOrder = draftOrder
        self.subtotalPrice = subtotal
    }
    
    func addDiscountToDraftOrder(_ priceRule: PriceRule) {
        
        var value = priceRule.value
        if value.hasPrefix("-") { value.removeFirst() }
        let appliedDiscount = AppliedDiscount(
            description: "Custom",
            value: value,
            title: priceRule.title,
            amount: value,
            valueType: priceRule.valueType
        )
        
        do {
            let discountData = try JSONEncoder().encode(appliedDiscount)
            let discountJSON = try JSONSerialization.jsonObject(with: discountData) as! [String: Any]
            let appliedDiscount = ["applied_discount": discountJSON]
            let discountParams = ["draft_order": appliedDiscount]
            
            service.makeRequest(endPoint: "/draft_orders/\(CART_ID).json", method: .put, parameters: discountParams) { (result: Result<DraftOrderResponse, APIError>) in
                
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.draftOrder = response.draftOrder
                    }
                case .failure(let error):
                    print("Updating draft error: \(error)")
                }
                
            }
            
        } catch {
            print("Error in Discount JSON")
            return
        }
        
    }
    
    func completeOrder(completion: @escaping () -> ()) {
        
        service.makeRequest(endPoint: "/draft_orders/\(CART_ID)/complete.json", method: .put) { (result: Result<DraftOrderResponse, APIError>) in
            
            switch result {
            case .success(_):
                print("Compeleted Order Successfully!")
                completion()
            case .failure(let error):
                print("Error in completing an order: \(error)")
            }
            
        }
        
    }
    
}
