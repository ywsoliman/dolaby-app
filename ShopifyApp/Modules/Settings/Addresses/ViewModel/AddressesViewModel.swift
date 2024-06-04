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
    
    var onAddressDeleted: (() -> ()) = {}
    
    init(service: NetworkService) {
        self.service = service
        getAddresses()
    }
    
    func getAddresses() {
        
        service.makeRequest(endPoint: "/customers/\(MY_CUSTOMER)/addresses.json", method: .get) { (result: Result<CustomerAddresses, APIError>) in
            
            switch result {
            case .success(let addresses):
                DispatchQueue.main.async {
                    self.addresses = addresses
                }
                print("Addresses = \(addresses)")
            case .failure(let error):
                print("Addresses error: \(error)")
            }
            
        }
        
    }
    
    func delete(address: Address, completion: @escaping (() -> Void)) {
        
        guard let id = address.id else { return }
        
        service.makeRequest(endPoint: "/customers/\(MY_CUSTOMER)/addresses/\(id).json", method: .delete) { (result: Result<EmptyResponse, APIError>) in
            
            switch result {
            case .success:
                completion()
            case .failure(let error):
                print("Deleting address error: \(error)")
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
