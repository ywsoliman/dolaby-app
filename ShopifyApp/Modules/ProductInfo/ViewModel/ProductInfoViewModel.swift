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
    
    func addProductToCart(id: Int, quantity: Int) {
        
        guard let user = CurrentUser.user else { return }

        if let cartId = user.cartID {
            addProductToCart(cartId: cartId, productId: id, quantity: quantity)
        } else {
            createCartWithProduct(id: id, quantity: quantity)
        }

    }
    
    private func addProductToCart(cartId: String, productId: Int, quantity: Int) {
        networkService.getCart { [weak self] (result: Result<DraftOrderResponse, APIError>) in
            switch result {
            case .success(let response):
                self?.updateCart(cart: response.draftOrder, id: productId, quantity: quantity)
            case .failure(let error):
                print("Add to Product Error: \(error)")
            }
        }
    }
    
    private func updateCart(cart: DraftOrder, id: Int, quantity: Int) {
        
        var updatedCart = updateCartLineItems(cart, id: id, quantity: quantity)
        
        networkService.makeRequest(endPoint: "/draft_orders/\(cart.id).json", method: .put, parameters: updatedCart) { (result: Result<DraftOrderResponse, APIError>) in
            
            switch result {
            case .success:
                print("Added product to cart successfully")
            case .failure(let error):
                print("Failed to add product to cart: \(error)")
            }
            
            
        }
    }
    

    func updateCartLineItems(_ cart: DraftOrder, id: Int, quantity: Int) -> [String: Any] {
        
        var lineItemsArray = cart.lineItems.map { lineItem -> [String: Any] in
            return [
                "variant_id": lineItem.variantID,
                "quantity": lineItem.quantity
            ]
        }
            
        lineItemsArray.append([
            "variant_id": id,
            "quantity": quantity
        ])
        
        let draftOrderDictionary: [String: Any] = [
            "id": cart.id,
            "line_items": lineItemsArray
        ]
        
        return ["draft_order": draftOrderDictionary]
        
    }
    
    
    private func createCartWithProduct(id: Int, quantity: Int) {
        print("User ID: \(CurrentUser.user!.id)")
        let draftOrder: [String: Any] = [
            "draft_order": [
                "line_items": [
                    [
                        "variant_id": id,
                        "quantity": quantity
                    ]
                ],
                "customer": [
                    "id": CurrentUser.user!.id
                ],
                "use_customer_default_address": true
            ]
        ]
        
        networkService.makeRequest(endPoint: "/draft_orders.json", method: .post, parameters: draftOrder) { (result: Result<DraftOrderResponse, APIError>) in
            
            switch result {
            case .success(let response):
                CurrentUser.user!.cartID = String(response.draftOrder.id)
                updateCustomer(willCreateDraft: true)
                print("Created a draft order with one item successfully!")
            case .failure(let error):
                print("Failed to creat a draft order with one item: \(error)")
            }
            
        }
        
    }
    
}
