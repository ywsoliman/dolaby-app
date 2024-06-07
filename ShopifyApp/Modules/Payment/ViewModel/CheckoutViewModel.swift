//
//  CheckoutViewModel.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 05/06/2024.
//

import Foundation

class CheckoutViewModel {
    
    let service: NetworkService
    var draftOrder: DraftOrder
    var bindCheckoutToViewController: (() -> ()) = {}
    
    init(service: NetworkService, draftOrder: DraftOrder) {
        self.service = service
        self.draftOrder = draftOrder
    }
    
}
