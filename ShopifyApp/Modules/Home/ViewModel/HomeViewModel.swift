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
}
class HomeViewModel:HomeViewModelProtocol{
    let networkService:NetworkServiceProtocol
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    var bindBrandsToViewController:()->Void={}
    var brands:[Brand]?=nil
    func fetchBrands(){
        let url = URL(string: "https://d4ac16c358057de2fb38bf18d04b7259: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@mad44-sv-ios3.myshopify.com/admin/api/2024-04/smart_collections.json")!
      
        networkService.fetchData(url: url) { [weak self](result:Result<BrandsResponse,Error>) in
            switch result{
            case .failure(let error):
                print("Error: ",error.localizedDescription)
            case .success(let data):
                self?.brands=data.brands
                self?.bindBrandsToViewController()
            }
        }
    }
    func getBrands()->[Brand]{
        return brands ?? []
    }
    func getBrandsCount()->Int{
        return brands?.count ?? 0
    }
}
