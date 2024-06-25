//
//  CheckoutViewModel.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 05/06/2024.
//

import Foundation

class CheckoutViewModel {
    
    private let service: NetworkService
    let priceBeforeDiscount: Double!
    var draftOrder: DraftOrder {
        didSet {
            bindDraftOrderToViewController()
        }
    }
    var bindDraftOrderToViewController: (() -> ()) = {}
    
    init(service: NetworkService, draftOrder: DraftOrder, priceBeforeDiscount: Double) {
        self.service = service
        self.draftOrder = draftOrder
        self.priceBeforeDiscount = priceBeforeDiscount
        print("Price before discount: \(priceBeforeDiscount)")
    }
    
    func addDiscountToDraftOrder(_ priceRule: PriceRule, completion: @escaping () -> ()) {
        
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
            
            service.makeRequest(endPoint: "/draft_orders/\(cartId).json", method: .put, parameters: discountParams) { [weak self] (result: Result<DraftOrderResponse, APIError>) in
                
                switch result {
                case .success(let response):
                    self?.draftOrder = response.draftOrder
                    completion()
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
        print("DraftOrder",draftOrder)
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
                "total_discounts": draftOrder.appliedDiscount?.amount ?? "0",
                "send_receipt":"true",
                "inventory_behaviour":"decrement_obeying_policy",
                "customer":
                    ["id":
                        CurrentUser.user?.id
                    ],
                "line_items": draftOrder.lineItems.map { item in
                           [
                               "title": item.title,
                               "price": item.price.priceFormatterValue(),
                               "quantity": item.quantity,
                               "variant_title": item.variantTitle,
                               "variant_id": item.variantID,
                               "product_id": item.productID
                           ]
                       }
            ]
        ]
        
        print("Parameters = \(parameters)")
        
        service.makeRequest(endPoint: "/orders.json", method: .post,parameters: parameters) {[weak self] (result: Result<OrderResponse, APIError>) in
            switch result {
            case .success(_):
                print("Order is posted Successfully!")
                completion()
                self?.updateCustomer()
                self?.deleteDraftOrder()
               
            case .failure(let error):
                print("Error in posting an order: \(error)")
            }
        }
    }
    func completeOrder() {
           
        service.makeRequest(endPoint: "/draft_orders/\(draftOrder.id)/complete.json", method: .put) { (result: Result<DraftOrderResponse, APIError>) in
               
               switch result {
               case .success(_):
                   print("Compeleted Order Successfully!")
               case .failure(let error):
                   print("Error in completing an order: \(error)")
               }
               
           }
           
       }

    
    func deleteDraftOrder(){
         service.makeRequest(endPoint: "/draft_orders/\(draftOrder.id).json", method: .delete) { (result: Result<EmptyResponse, APIError>) in
             switch result {
             case .success(_):
                 print("Draft order is deleted Successfully!")
             case .failure(let error):
                 print("Error in deleting draft order: \(error)")
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
                print("Error in updating customer: \(error)")
            }
        }
    }
    
    func removeDiscountFromOrder(completion: @escaping () -> ()) {
        
        let draftOrderDict: [String: Any] = ["draft_order": ["applied_discount": nil]]
        
        service.makeRequest(endPoint: "/draft_orders/\(draftOrder.id).json", method: .put, parameters: draftOrderDict) { [weak self] (result: Result<DraftOrderResponse, APIError>) in
            
            switch result {
            case .success(let response):
                self?.draftOrder = response.draftOrder
                completion()
            case .failure(let error):
                print("Updating draft error: \(error)")
            }
            
            
        }
        
    }
    
}
