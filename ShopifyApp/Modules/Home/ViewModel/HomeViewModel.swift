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
//        let url = URL(string: "https://d4ac16c358057de2fb38bf18d04b7259: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@mad44-sv-ios3.myshopify.com/admin/api/2024-04/smart_collections.json")!
//
//        networkService.fetchData(url: url) { [weak self](result:Result<BrandsResponse,Error>) in
//            switch result{
//            case .failure(let error):
//                print("Error: ",error.localizedDescription)
//            case .success(let data):
//                self?.brands=data.brands
//                self?.bindBrandsToViewController()
//            }
//        }
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
        currencyService.fetchCurrencies { (result: Result<CurrencyResponse, Error>) in
            switch result {
            case .success(let response):
                CurrencyManager.currencies = response.conversionRates
                CurrencyManager.currency = UserDefaults.standard.value(forKey: "currency") as? String ?? "USD"
                CurrencyManager.value = response.conversionRates[CurrencyManager.currency] ?? 1.0
            case .failure(let error):
                print("Fetching Currencies Error: \(error)")
            }
        }
    }
    
}
