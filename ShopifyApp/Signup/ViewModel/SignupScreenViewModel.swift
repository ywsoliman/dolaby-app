//
//  SignupScreenViewModel.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 26/05/2024.
//

import Foundation
class SignupScreenViewModel{
    var authManager:AuthenticationManager
    init(authManager: AuthenticationManager) {
        self.authManager = authManager
    }
    func signup(customer:Customer){
        Task{
            do{
                try await authManager.createCustomer(customer: customer)
                print("successfully")
            }catch{
                print("Error \(error)")
            }
        }
    }
}
