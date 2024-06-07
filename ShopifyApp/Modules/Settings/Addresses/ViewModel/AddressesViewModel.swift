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
                self.addresses = addresses
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
//                self.removeAddress(withId: id)
                completion()
            case .failure(let error):
                print("Deleting address error: \(error)")
            }
            
        }
        
    }
    
    func removeAddress(withId id: Int) {
        guard var addresses = addresses?.addresses else { return }
        for i in addresses.indices {
            if addresses[i].id == id {
                addresses.remove(at: i)
                break
            }
        }
    }
    
    func setDefault(addressID: Int) {
        
        service.makeRequest(endPoint: "/customers/\(MY_CUSTOMER)/addresses/\(addressID)/default.json", method: .put) { (result: Result<CustomerAddress, APIError>) in
            
            switch result {
            case .success(_):
                self.getAddresses()
            case .failure(let error):
                print("Setting default address error: \(error)")
            }
            
        }
        
    }
    
}
