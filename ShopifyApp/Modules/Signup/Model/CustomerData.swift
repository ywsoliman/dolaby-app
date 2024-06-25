//
//  Customer.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 07/06/2024.
//

import Foundation
class CustomerData:Codable{
    var id:Int?
    var userID:String?
    let email:String
    let firstName:String
    let lastName:String
    let phone:String
    let password:String?
    
    init(id:Int?,userId:String?,firstName: String, lastName: String, phone: String,email: String, password: String) {
        self.id = id
        self.userID = userId
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.password = password
    }
    
    enum CodingKeys: String, CodingKey {
           case id , email
           case firstName = "first_name"
           case lastName = "last_name"
           case phone
           case password
       }
}
struct CustomerDataResponse: Codable {
    let customer: CustomerData
}
