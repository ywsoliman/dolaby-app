//
//  AuthenticationManager.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 03/06/2024.
//

import Foundation
import FirebaseAuth
final class AuthenticationManager{
    static let shared = AuthenticationManager()
    private init(){}
    
    func createCustomer(customer:Customer) async throws{
        let authDataResult = try await Auth.auth().createUser(withEmail: customer.email, password: customer.password)
    }
}
