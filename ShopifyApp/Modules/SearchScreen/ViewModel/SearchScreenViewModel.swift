//
//  SearchScreenViewModel.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 14/06/2024.
//

import Foundation
final class SearchScreenViewModel{
    let networkService:NetworkService
    @Published  var isLoading:Bool = false
    var bindProductsToViewController:()->Void={}
    var allProducts:[CategoriesProduct] = []
    var filteredProducts: [CategoriesProduct] = []
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    func fetchProducts(){
        networkService.makeRequest(endPoint: "/products.json", method: .get) {[weak self] (result: Result<ProductsResponse, APIError>) in
            switch result {
            case .success(let response):
                self?.allProducts=response.products
                self?.filteredProducts=response.products
                self?.bindProductsToViewController()
            case .failure(let error):
                print("Error in retrieving categories products: \(error)")
            }
        }
    }
    func filterBySearchText(text:String){
        if text.isEmpty {
                filteredProducts = allProducts
        } else {
            filteredProducts = allProducts.filter { product in
                    return product.title.range(of: text, options: .caseInsensitive) != nil
                }
            }
            bindProductsToViewController()
    }
}
