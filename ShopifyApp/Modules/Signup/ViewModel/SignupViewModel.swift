//
//  SignupViewModel.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 07/06/2024.
//

import Foundation
import Alamofire
final class SignupScreenViewModel{
    @Published  var isLoading:Bool = false
    @Published  var isSuccessful:Bool = false
    @Published  var errorMessage:String?
    private var networkService:NetworkService
    private var authManager:AuthenticationManager
    var bindSuccessToViewController:((_ createdCustomer:CustomerData) -> ()) = {createdCustomer in }
    init(authManager: AuthenticationManager,networkService:NetworkService) {
        self.authManager = authManager
        self.networkService = networkService
    }
    
    func createShopifyCustomer(customer:CustomerData){
        isLoading=true
        let parameters: [String: Any] = [
               "customer": [
                   "first_name": customer.firstName,
                   "last_name": customer.lastName,
                   "email": customer.email,
                   "phone": customer.phone
               ]
           ]
        print(parameters)
        print("Calling the shopify API")
        networkService.makeRequest(
            endPoint: "/customers.json",
            method: .post,
            parameters: parameters
        ) {[weak self] (result: Result<CustomerDataResponse, APIError>) in
            switch result {
            case .success(let response):
                self?.bindSuccessToViewController(response.customer)
            case .failure(let error):
                print("Failed to create customer: \(error)")
                self?.isLoading = false
                self?.isSuccessful = false
                self?.errorMessage = error.localizedDescription
            }
        }
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
