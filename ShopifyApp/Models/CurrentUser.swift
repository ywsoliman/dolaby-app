//
//  CurrentUser.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 14/06/2024.
//

import Foundation
enum UserType{
    case authenticated
   case anonymous
}
class CurrentUser {
    
    static var user: Customer?
    static var type: UserType = UserType.anonymous
    private init() {}
    
}
