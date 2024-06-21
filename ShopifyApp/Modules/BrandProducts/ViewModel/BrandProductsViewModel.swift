//
//  BrandProductsViewModel.swift
//  ShopifyApp
//
//  Created by Israa Assem on 10/06/2024.
//

import Foundation
import Kingfisher
protocol BrandProductsViewModelProtocol{
    func filterProducts(withPrice:Double,searchText:String)
    func getProductsCount(withPrice:Double,searchText:String)->Int
    var bindProductsToViewController:()->Void { get set }
    func fetchProducts()->Void
}
class BrandProductsViewModel:BrandProductsViewModelProtocol{
 

    var brandId=475723497772
    let networkService:NetworkService
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    var bindProductsToViewController:()->Void={}
    var products:[CategoriesProduct] = []
    var filteredProducts:[CategoriesProduct] = []
    var productsWithoutPrice:[BrandsProduct]?=nil
    func fetchProducts(){
        networkService.makeRequest(endPoint: "/collections/\(brandId)/products.json", method: .get) {[weak self] (result: Result<BrandProductsResponse, APIError>) in
            switch result {
            case .success(let response):
                self?.productsWithoutPrice=response.products
                self?.fetchProductsWithId()
            case .failure(let error):
                print("Error in retrieving brand products: \(error)")
            }
        }
        
    }
    func fetchProductsWithId(){
        let productsIDs=productsWithoutPrice?.map{String($0.id)}.joined(separator: ",") ?? ""
        print("productsIDs: ",productsIDs)
        networkService.makeRequest(endPoint: "/products.json?ids=\(productsIDs)", method: .get) {[weak self] (result: Result<ProductsResponse, APIError>) in
            switch result {
            case .success(let response):
                self?.products=response.products
                self?.filteredProducts = response.products
                self?.bindProductsToViewController()
            case .failure(let error):
                print("Error in retrieving products: \(error)")
            }
        }
    }
   
    func filterProducts(withPrice: Double, searchText: String){
        if searchText.isEmpty{
            filteredProducts = products.filter{Double($0.variants[0].price) ?? 0 <= withPrice}
        }
        else{
            filteredProducts =  products.filter{Double($0.variants[0].price) ?? 0 <= withPrice && $0.title.range(of: searchText, options: .caseInsensitive) != nil}
        }
    }
    
    func getProductsCount(withPrice: Double, searchText: String) -> Int {
        return filteredProducts.count
    }
}
