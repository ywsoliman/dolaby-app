//
//  CheckoutViewModel.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 05/06/2024.
//

import Foundation

class CheckoutViewModel {
    
    let service: NetworkService
    let subtotalPrice: String
    var draftOrder: DraftOrder {
        didSet {
            bindDraftOrderToViewController()
        }
    }
    var priceRules: [PriceRule] = []
    var bindDraftOrderToViewController: (() -> ()) = {}
    
    init(service: NetworkService, draftOrder: DraftOrder, subtotal: String) {
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
    
    func completeOrder() {
        
        service.makeRequest(endPoint: "/draft_orders/\(CART_ID)/complete.json", method: .put) { (result: Result<DraftOrderResponse, APIError>) in
            
            switch result {
            case .success(let draftOrder):
                print("Compeleted Order Successfully!")
            case .failure(let error):
                print("Error in completing an order: \(error)")
            }
            
        }
        
    }
    
}
