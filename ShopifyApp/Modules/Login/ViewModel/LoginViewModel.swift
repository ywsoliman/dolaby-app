//
//  LoginViewModel.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 07/06/2024.
//

import Foundation
final class LoginViewModel{
   @Published  var isLoading:Bool = false
   @Published  var successful:Bool = false
   @Published  var errorMessage:String?
    private var authManager:AuthenticationManager
    private var localDatabase:LocalDataSource
    private var networkService:NetworkService
    private var uid:String = ""
    private var customerID:Int?
//    var bindingSuccessToViewController :((_ customerCoreDataModel:CustomerCoreDataModel)->()) = {customerData in}
   
    init(authManager: AuthenticationManager,newtworkService:NetworkService,localDatabase:LocalDataSource) {
        self.localDatabase = localDatabase
        self.authManager = authManager
        self.networkService = newtworkService
    }
    
    
    func login(customer:CustomerCredentials){
        Task{
            isLoading = true
            do{
             let customer = try await authManager.login(customer: customer)
                uid = customer.userID ?? ""
                customerID = customer.id!
               try saveUsersData()
                getCustomer()
            }catch{
                successful = false
                isLoading = false
                errorMessage = error.localizedDescription
                print("Error \(error)")
            }
        }
    }

    func saveUsersData() throws{
        _ = localDatabase.saveCustomerId(customerID: customerID!)
        _ = try localDatabase.retrieveCustomerId()
    }
    func getCustomer(){
        print("Customer id for alamorire = \(customerID!)")
        networkService.makeRequest(
            endPoint: "/customers/\(customerID!).json",
            method: .get
        ) { (result: Result<CustomerResponse, APIError>) in
            switch result {
            case .success(let customerResponse):
                self.successful = true
                self.isLoading = false
                CurrentUser.user = customerResponse.customer
                CurrentUser.type = UserType.authenticated
            case .failure(let error):
                self.successful = false
                self.isLoading = false
                self.errorMessage = error.localizedDescription
                print("Error \(error)")
            }
        }
    }
}
