//
//  AddressesViewModel.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 03/06/2024.
//

import Foundation

class AddressesViewModel {
    
    private let service: NetworkService
    var bindAddressesToViewController: (() -> ()) = {}
    var addresses: CustomerAddresses? {
        didSet {
            bindAddressesToViewController()
        }
    }
    
    init(service: NetworkService) {
        self.service = service
        getAddresses()
    }
    
    private func getAddresses() {
        
        service.makeRequest(endPoint: "/customers/\(MY_CUSTOMER)/addresses.json", method: .get) { (result: Result<CustomerAddresses, APIError>) in
            
            switch result {
            case .success(let addresses):
                self.addresses = addresses
                print("Addresses = \(addresses)")
            case .failure(let error):
                print("Addresses error: \(error)")
            }
            
        }
        
    }
    
    func setDefault(addressID: Int) {
        
        service.makeRequest(endPoint: "/customers/\(MY_CUSTOMER)/addresses/\(addressID)/default.json", method: .put) { (result: Result<Address, APIError>) in
            
            switch result {
            case .success(_):
                self.getAddresses()
            case .failure(let error):
                print("Setting default address error: \(error)")
            }
            
        }
        
    }
    
}
