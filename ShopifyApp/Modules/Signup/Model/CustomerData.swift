//
//  Customer.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 07/06/2024.
//

import Foundation
class CustomerData:Codable{
    var id:Int?
    let email:String
    let firstName:String
    let lastName:String
    let phone:String
    let password:String?
    
    init(id:Int?,firstName: String, lastName: String, phone: String,email: String, password: String) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.password = password
    }
    
    enum CodingKeys: String, CodingKey {
           case id
           case email
           case firstName = "first_name"
           case lastName = "last_name"
           case phone
           case password
       }
}
