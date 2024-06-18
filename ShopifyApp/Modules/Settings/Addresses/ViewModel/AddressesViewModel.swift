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
    var bindDefaultAddressToViewController: (() -> ()) = {}
    var addresses: CustomerAddresses? {
        didSet {
            bindAddressesToViewController()
        }
    }
    var defaultAddress: Address? {
        didSet {
            bindDefaultAddressToViewController()
        }
    }
    
    var onAddressDeleted: (() -> ()) = {}
    
    init(service: NetworkService) {
        self.service = service
        getAddresses()
    }
    
    func getAddresses() {
                
        service.makeRequest(endPoint: "/customers/\(CurrentUser.user!.id)/addresses.json", method: .get) { (result: Result<CustomerAddresses, APIError>) in
            
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
        
        service.makeRequest(endPoint: "/customers/\(CurrentUser.user!.id)/addresses/\(id).json", method: .delete) { (result: Result<EmptyResponse, APIError>) in
            
            switch result {
            case .success:
                self.removeAddress(withId: id)
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
        CurrentUser.user!.addresses = addresses
    }
    
    func setDefault(addressID: Int) {
        
        service.makeRequest(endPoint: "/customers/\(CurrentUser.user!.id)/addresses/\(addressID)/default.json", method: .put) { (result: Result<CustomerAddress, APIError>) in
            
            switch result {
            case .success(let address):
                self.defaultAddress = address.customerAddress
                self.changeCartShippingAddressToDefault(address)
            case .failure(let error):
                print("Setting default address error: \(error)")
            }
            
        }
        
    }
    
    func changeCartShippingAddressToDefault(_ address: CustomerAddress) {
        
        guard let cartId = CurrentUser.user?.cartID,
              var shippingParams = address.toDictionary() else { return }
        
        if let value = shippingParams.removeValue(forKey: "customer_address") {
            shippingParams["shipping_address"] = value
            shippingParams["billing_address"] = value
        }
        
        let addressParams = ["draft_order": shippingParams]
        
        service.makeRequest(endPoint: "/draft_orders/\(cartId).json", method: .put, parameters: addressParams) { (result: Result<DraftOrderResponse, APIError>) in
            
            switch result {
            case .success(_):
                print("Changed cart shipping address successfully!")
            case .failure(let error):
                print("Couldn't change cart shipping address: \(error)")
            }
            
        }
        
    }
    
}
