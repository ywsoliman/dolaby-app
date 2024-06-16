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
     
        var modifiedCart = cart
        modifiedCart.lineItems.append(LineItem(id: 0, variantID: id, productID: 0, title: "", variantTitle: "", sku: "", vendor: "", quantity: quantity, appliedDiscount: nil, name: "", properties: [], custom: false, price: ""))
                
        let cartDict = modifiedCart.toUpdateRequestDictionary()
        
        networkService.makeRequest(endPoint: "/draft_orders/\(modifiedCart.id).json", method: .put, parameters: cartDict) { (result: Result<DraftOrderResponse, APIError>) in
                
            switch result {
            case .success:
                print("Added product to cart successfully")
            case .failure(let error):
                print("Failed to add product to cart: \(error)")
            }
            
        }
        
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
                self.updateCustomer(withId: CurrentUser.user!.id)
                print("Created a draft order with one item successfully!")
            case .failure(let error):
                print("Failed to creat a draft order with one item: \(error)")
            }
            
        }
        
    }
    
    func updateCustomer(withId id: Int) {
        
        guard let customerDict = CurrentUser.user?.toDictionary() else { return }
        
        let customerResponse = ["customer": customerDict]
        
        networkService.makeRequest(endPoint: "/customers/\(id).json", method: .put, parameters: customerResponse) { (result: Result<CustomerResponse, APIError>) in
            
            switch result {
            case .success:
                print("Customer updated successfully!")
            case .failure(let error):
                print("Failed to update customer: \(error)")
            }
            
        }
        
    }
    
}
