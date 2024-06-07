//
//  Customer.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 07/06/2024.
//

import Foundation
class CustomerData{
    let email:String
    let userName:String
    let address:String
    let password:String
    
    init(email: String, userName: String, address: String, password: String) {
        self.email = email
        self.userName = userName
        self.address = address
        self.password = password
    }
}
