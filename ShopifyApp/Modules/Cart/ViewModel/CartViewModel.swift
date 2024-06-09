//
//  CartViewModel.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 05/06/2024.
//

import Foundation

class CartViewModel {
    
    var service: NetworkService
    var bindCartToViewController: (() -> ()) = {}
    var cart: DraftOrder? {
        didSet {
            bindCartToViewController()
        }
    }
    
    init(service: NetworkService) {
        self.service = service
        getCart()
    }
    
    func getCart() {
        service.makeRequest(endPoint: "/draft_orders/\(CART_ID).json", method: .get) { (result: Result<DraftOrderResponse, APIError>) in
            
            switch result {
            case .success(let draftOrder):
                self.cart = draftOrder.draftOrder
            case .failure(let error):
                print("Error DraftOrder: \(error)")
            }
            
        }
    }
    
    func deleteItem(withId id: Int) {
        
        guard var cart = cart else { return }
        
        if let index = cart.lineItems.firstIndex(where: { $0.id == id }) {
            cart.lineItems.remove(at: index)
        }
        
        let cartParams = createUpdateDraftOrderRequestDictionary(from: cart)
        
        print("Cart Params: \(cartParams)")

        service.makeRequest(endPoint: "/draft_orders/\(cart.id).json", method: .put, parameters: cartParams) { (result: Result<DraftOrderResponse, APIError>) in
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.cart = response.draftOrder
                }
            case .failure(let error):
                print("Updating draft error: \(error)")
            }
            
        }
        
    }
    
    func createUpdateDraftOrderRequestDictionary(from draftOrder: DraftOrder) -> [String: Any] {
        let lineItemsArray = draftOrder.lineItems.map { lineItem -> [String: Any] in
            return [
                "variant_id": lineItem.variantID,
                "quantity": lineItem.quantity
            ]
        }
        
        let draftOrderDictionary: [String: Any] = [
            "id": draftOrder.id,
            "line_items": lineItemsArray
        ]
        
        return ["draft_order": draftOrderDictionary]
    }
    
}
