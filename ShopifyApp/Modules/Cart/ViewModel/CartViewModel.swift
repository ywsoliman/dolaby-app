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
    var productsVariants: [Variant] = []
    
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
                self.productsVariants.append(response.variant)
                completion()
            case .failure(let error):
                print("Error in fetching product variant: \(error)")
            }
            
        }
        
    }
    
    func deleteCart() {
        
        guard let cartId = CurrentUser.user?.cartID else { return }
        
        service.makeRequest(endPoint: "/draft_orders/\(cartId).json", method: .delete) { (result: Result<EmptyResponse, APIError>) in
            
            switch result {
            case .success:
                self.cart = nil
                CurrentUser.user!.cartID = nil
                updateCustomer(willCreateDraft: false)
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
        
        guard let cartDict = cart.toDictionary() else { return }
        let cartBody = ["draft_order": cartDict]
        
        service.makeRequest(endPoint: "/draft_orders/\(cart.id).json", method: .put, parameters: cartBody) { (result: Result<DraftOrderResponse, APIError>) in
            
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
