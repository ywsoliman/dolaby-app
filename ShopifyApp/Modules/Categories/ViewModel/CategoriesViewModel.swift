//
//  CategoriesViewModel.swift
//  ShopifyApp
//
//  Created by Israa Assem on 10/06/2024.
//

import Foundation
protocol CategoriesViewModelProtocol{
    func getProducts()->[CategoriesProduct]
    func getProductsCount()->Int
    var  bindProductsToViewController:()->Void { get set }
    func fetchProducts()->Void
   
}
class CategoriesViewModel:CategoriesViewModelProtocol{
    
    let networkService:NetworkService
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    var bindProductsToViewController:()->Void={}
    var allProducts:[CategoriesProduct]?=nil
    

    func fetchProducts(){
        networkService.makeRequest(endPoint: "/products.json", method: .get) {[weak self] (result: Result<ProductsResponse, APIError>) in
            switch result {
            case .success(let response):
                self?.allProducts=response.products
                self?.bindProductsToViewController()
            case .failure(let error):
                print("Error in retrieving categories products: \(error)")
            }
        }
    }
    func getProducts()->[CategoriesProduct]{
        return allProducts ?? []
    }
    func getProductsCount()->Int{
        return allProducts?.count ?? 0
    }
   
    
   
}

