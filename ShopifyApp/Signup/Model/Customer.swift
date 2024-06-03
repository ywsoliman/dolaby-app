//
//  Customer.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 03/06/2024.
//

import Foundation
class Customer{
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
