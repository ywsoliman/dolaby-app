//
//  HomeViewModel.swift
//  ShopifyApp
//
//  Created by Israa Assem on 02/06/2024.
//

import Foundation
protocol HomeViewModelProtocol{
    func getBrands()->[Brand]
    func getBrandsCount()->Int
    var bindBrandsToViewController:()->Void { get set }
    func fetchBrands()->Void
    func getDiscountCodes(completion: @escaping () -> ())
    func loadUser()
}
class HomeViewModel:HomeViewModelProtocol{
    private let service: NetworkService
    private let currencyService: CurrencyServiceProtocol

    var bindBrandsToViewController:()->Void={}
    var brands:[Brand]?=nil
    
    init(service: NetworkService, currencyService: CurrencyServiceProtocol) {
        self.service = service
        self.currencyService = currencyService
        getConversionRates()
    }

    func fetchBrands(){
        service.makeRequest(endPoint: "/smart_collections.json", method: .get) {[weak self] (result: Result<BrandsResponse, APIError>) in
            switch result {
            case .success(let response):
                self?.brands=response.brands
                self?.bindBrandsToViewController()
            case .failure(let error):
                print("Error in retrieving brands: \(error)")
            }
        }
    }
    func loadUser() {
        do{
            let customerId = try LocalDataSource.shared.retrieveCustomerId()
            getCustomer(customerId: customerId)
        }catch{
            print("Error \(error)")
        }
       
    }

    func getCustomer(customerId:Int){
        print("Customer id for alamorire = \(customerId)")
        service.makeRequest(
            endPoint: "/customers/\(customerId).json",
            method: .get
        ) { (result: Result<CustomerResponse, APIError>) in
            switch result {
            case .success(let customerResponse):
                CurrentUser.user = customerResponse.customer
                CurrentUser.type = UserType.authenticated
            case .failure(let error):
                print("Error in getting the user data \(error.localizedDescription)")
            }
        }
    }
    func getBrands()->[Brand]{
        return brands ?? []
    }
    func getBrandsCount()->Int{
        return brands?.count ?? 0
    }
    
    func getDiscountCodes(completion: @escaping () -> ()) {
        
        service.makeRequest(endPoint: "/price_rules.json", method: .get) { (result: Result<PriceRulesResponse, APIError>) in
            
            switch result {
            case .success(let response):
                Discounts.discounts = response.priceRules
                completion()
            case .failure(let error):
                print("Error in retrieving price rules: \(error)")
            }
            
        }
        
    }
    
    func getConversionRates() {
        currencyService.fetchCurrencies()
    }
    
}
