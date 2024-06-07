//
//  SignupViewModel.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 07/06/2024.
//

import Foundation
final class SignupScreenViewModel{
    @Published  var isLoading:Bool = false
    @Published  var isSuccessful:Bool = false
    @Published  var errorMessage:String?
    private var authManager:AuthenticationManager
    init(authManager: AuthenticationManager) {
        self.authManager = authManager
    }
    func signup(customer:CustomerData){
        isLoading=true
        Task{
            do{
                try await authManager.createCustomer(customer: customer)
                isLoading=false
                isSuccessful=true
                print("successfully")
            }catch{
                print("Error \(error)")
                isLoading=false
                isSuccessful=false
                errorMessage = error.localizedDescription
            }
        }
    }
}
