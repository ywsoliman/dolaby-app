//
//  LoginViewModel.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 03/06/2024.
//

import Foundation
final class LoginViewModel{
   @Published  var isLoading:Bool = false
   @Published  var errorMessage:String?
    private var authManager:AuthenticationManager
    init(authManager: AuthenticationManager) {
        self.authManager = authManager
    }
    
    func login(customer:Customer){
        Task{
            isLoading = true
            do{
                try await authManager.login(customer: customer)
                isLoading = false
                print("successfully")
            }catch{
                isLoading = false
                errorMessage = error.localizedDescription
                print("Error \(error)")
            }
        }
    }
}
