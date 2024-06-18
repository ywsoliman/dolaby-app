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
        
        guard let cartId = CurrentUser.user?.cartID else { return }
        
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
            
            service.makeRequest(endPoint: "/draft_orders/\(cartId).json", method: .put, parameters: discountParams) { (result: Result<DraftOrderResponse, APIError>) in
                
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

    func postOrder(completion: @escaping () -> ()) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
        let formattedDate = formatter.string(from: date)
        let parameters: [String: Any] = [
            "order": [
                "created_at": formattedDate,
                "currency": CurrencyManager.currency,
                "email": CurrentUser.user?.email ?? "israaassem20@gmail.com",
                "total_price": draftOrder.totalPrice,
                "customer":
                    ["id":
                        CurrentUser.user?.id
                    ],
                "line_items": draftOrder.lineItems.map { item in
                           [
                               "title": item.title,
                               "price": item.price,
                               "quantity": item.quantity,
                               "variant_title": item.variantTitle
                           ]
                       }
            ]
        ]
        service.makeRequest(endPoint: "/orders.json", method: .post,parameters: parameters) {[weak self] (result: Result<OrderResponse, APIError>) in
            switch result {
            case .success(_):
                print("Order is posted Successfully!")
                completion()
                self?.updateCustomer()
            case .failure(let error):
                print("Error in posting an order: \(error)")
            }
        }
    }
    func updateCustomer(){
        CurrentUser.user?.cartID=nil
        let updatedCustomerData:[String:Any]=[
            "customer":[
                "note": nil
            ]
        ]
        service.makeRequest(endPoint: "/customers/\((CurrentUser.user?.id)!).json",method:.put, parameters: updatedCustomerData) { (result: Result<CustomerResponse, APIError>) in
            switch result {
            case .success(_):
                print("Customer is updated Successfully!")
            case .failure(let error):
                print("User id: \((CurrentUser.user?.id)!)")
                print("Error in updating customer: \(error)")
            }
        }
    }
}
