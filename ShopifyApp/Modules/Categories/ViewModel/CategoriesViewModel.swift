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
    func getNonFilteredProductsCount()->Int
    var  bindProductsToViewController:()->Void { get set }
    func fetchProducts()->Void
    func updateCategoryFilter(_ category: String?)->Void
    func updateTypeFilter(_ type: String?)->Void
    func setSearchText(_ enteredText: String?)->Void
}
class CategoriesViewModel:CategoriesViewModelProtocol{
    func getNonFilteredProductsCount() -> Int {
        return allProducts?.count ?? 0
    }
    func setSearchText(_ enteredText: String?) {
        searchText=enteredText ?? ""
        filterProducts()
    }
    
    let networkService:NetworkService
    private var searchText = ""
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    var bindProductsToViewController:()->Void={}
    var allProducts:[CategoriesProduct]?=nil
    var filteredProducts: [CategoriesProduct] = []
    
    var categoryFilter: String?
    var typeFilter: String?
    func fetchProducts(){
        networkService.makeRequest(endPoint: "/products.json", method: .get) {[weak self] (result: Result<ProductsResponse, APIError>) in
            switch result {
            case .success(let response):
                self?.allProducts=response.products
                self?.filterProducts()
                self?.bindProductsToViewController()
            case .failure(let error):
                print("Error in retrieving categories products: \(error)")
            }
        }
    }
    func getProducts()->[CategoriesProduct]{
        return filteredProducts
    }
    func getProductsCount()->Int{
        return filteredProducts.count
    }
    func filterProducts() {
        filteredProducts = allProducts ?? []
        
        if let categoryFilter = categoryFilter {
            filteredProducts = filteredProducts.filter { $0.tags.contains(categoryFilter) }
        }
        
        if let typeFilter = typeFilter {
            filteredProducts = filteredProducts.filter { $0.productType == typeFilter }
        }
        if searchText != ""{
            filteredProducts = filteredProducts.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
        NotificationCenter.default.post(name: .productsFilteredNotification, object: nil)
    }
    
    func updateCategoryFilter(_ category: String?) {
        categoryFilter = category
        filterProducts()
    }
    
    func updateTypeFilter(_ type: String?) {
        typeFilter = type
        filterProducts()
    }
}
extension Notification.Name {
    static let productsFilteredNotification = Notification.Name("productsFilteredNotification")
}
