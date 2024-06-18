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
    var cart: DraftOrder?
    
    init(service: NetworkService) {
        self.service = service
        getCart()
    }
    
    func getCart() {
        service.getCart { (result: Result<DraftOrderResponse, APIError>) in
            switch result {
            case .success(let response):
                self.cart = response.draftOrder
                self.getProductVariants()
            case .failure(let error):
                print("Getting Cart Error: \(error)")
            }
        }
    }
    
    func getProductVariants() {
        
        let dispatchGroup = DispatchGroup()
        for item in cart!.lineItems {
            dispatchGroup.enter()
            fetchProductVariant(withId: item.variantID) {
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.bindCartToViewController()
        }
        
    }
    
    func fetchProductVariant(withId id: Int, completion: @escaping () -> ()) {
        
        service.makeRequest(endPoint: "/variants/\(id).json", method: .get) { (result: Result<VariantResponse, APIError>) in
            
            switch result {
            case .success(let response):
                self.addQuantityToLineItem(response)
                completion()
            case .failure(let error):
                print("Error in fetching product variant: \(error)")
            }
            
        }
        
    }
    
    func addQuantityToLineItem(_ response: VariantResponse) {
        
        guard var cart = cart else { return }
        
        for i in cart.lineItems.indices {
            if cart.lineItems[i].variantID == response.variant.id {
                cart.lineItems[i].inventoryQuantity = response.variant.inventoryQuantity
            }
        }
        
        self.cart = cart
    }
    
    func deleteCart(completion: @escaping () -> ()) {
        
        cart = nil
        CurrentUser.user?.cartID = nil
        updateCustomer()
        completion()
        
    }
    
    func deleteItem(withId id: Int, completion: @escaping () -> ()) {
        
        guard var updatedCart = cart else { return }
        
        if let index = updatedCart.lineItems.firstIndex(where: { $0.id == id }) {
            updatedCart.lineItems.remove(at: index)
        }
        
        cart = updatedCart
        completion()
        
    }
    
    func updateCart() {
        
        guard let cart = cart,
              let cartDict = cart.toDictionary() else { return }
        
        let cartBody = ["draft_order": cartDict]
        
        service.makeRequest(endPoint: "/draft_orders/\(cart.id).json", method: .put, parameters: cartBody) { (result: Result<DraftOrderResponse, APIError>) in
            
            switch result {
            case .success:
                print("Updated cart succesufully")
            case .failure(let error):
                print("Updating draft error: \(error)")
            }
            
            
            
        }
        
    }
}
