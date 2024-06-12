//
//  LoginViewModel.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 07/06/2024.
//

import Foundation
final class LoginViewModel{
   @Published  var isLoading:Bool = false
   @Published  var errorMessage:String?
    private var authManager:AuthenticationManager
    private var localDatabase:CoreDataManager
    private var networkService:NetworkService
//    var bindingSuccessToViewController :((_ customerCoreDataModel:CustomerCoreDataModel)->()) = {customerData in}
   
    init(authManager: AuthenticationManager,newtworkService:NetworkService,localDatabase:CoreDataManager) {
        self.localDatabase = localDatabase
        self.authManager = authManager
        self.networkService = newtworkService
    }
    
    func login(customer:CustomerCredentials){
        Task{
            isLoading = true
            do{
             let customer = try await authManager.login(customer: customer)
               try localDatabase.saveCustomerData(customer: customer)
               let customerCoreData = try localDatabase.getCustomerData()
//                bindingSuccessToViewController(customerCoreData)
                isLoading = false
                print("successfully")
            }catch{
                isLoading = false
                errorMessage = error.localizedDescription
                print("Error \(error)")
            }
        }
    }
//    func getCustomer(customerData:CustomerCoreDataModel){
//        networkService.makeRequest(
//            endPoint: "/customers/\(customerData.id).json",
//            method: .get
//        ) { (result: Result<Customer, APIError>) in
//            switch result {
//            case .success(let customerData):
//                print("Customer data: \(customerData.id)")
//            case .failure(let error):
//                print("Error: \(error)")
//            }
//        }
//    }
}
