//
//  NetworkServiceMock.swift
//  ShopifyAppTests
//
//  Created by Youssef Waleed on 14/06/2024.
//

import Foundation
@testable import ShopifyApp

class NetworkServiceMock {
    
    var shouldFail: Bool = false
    
    private let fakeDiscountCodes: [String: Any] = [
        "price_rules": [
            [
                "id": 1436614164780,
                "value_type": "percentage",
                "value": "-50.0",
                "title": "RBQ484Y5MAQM"
            ]
        ]
    ]
    
    private var fakeCustomerAddresses: [String: Any] = [
        "addresses": [
            [
                "id": 10181039948076,
                "customer_id": 8093190160684,
                "first_name": "Youssef",
                "last_name": "Waleed",
                "address1": "Salah Salem Street",
                "city": "Giza",
                "country": "Egypt",
                "name": "Youssef Waleed",
                "country_code": "EG",
            ]
        ]
    ]
    
    func getDiscountCodes(completion: @escaping (PriceRulesResponse?, Error?) -> Void) {
        
        var priceRuleResponse: PriceRulesResponse?
        
        do {
            let data = try JSONSerialization.data(withJSONObject: fakeDiscountCodes)
            priceRuleResponse = try JSONDecoder().decode(PriceRulesResponse.self, from: data)
        } catch {
            print("Mock error \(error)")
        }
        
        shouldFail ? completion(nil, NetworkError.genericError) : completion(priceRuleResponse, nil)
        
    }
    
    func getCustomerAddresses(completion: @escaping (CustomerAddresses?, Error?) -> Void) {
        
        var customerAddresses: CustomerAddresses?
        
        do {
            let data = try JSONSerialization.data(withJSONObject: fakeCustomerAddresses)
            customerAddresses = try JSONDecoder().decode(CustomerAddresses.self, from: data)
        } catch {
            print("Mock error \(error)")
        }
        
        shouldFail ? completion(nil, NetworkError.genericError) : completion(customerAddresses, nil)
        
    }
    
    func addCustomerAddress(completion: @escaping (CustomerAddress?, Error?) -> Void) {
        
        guard !shouldFail else {
            completion(nil, NetworkError.genericError)
            return
        }
        
        var addresses = fakeCustomerAddresses["addresses"] as? [[String: Any]] ?? []
        let newAddress: [String: Any] = [
            "id": 12345678901234,
            "customer_id": 8093190160684,
            "first_name": "John",
            "last_name": "Doe",
            "address1": "123 Main Street",
            "city": "Cairo",
            "country": "Egypt",
            "name": "John Doe",
            "country_code": "EG",
        ]
        
        addresses.append(newAddress)
        fakeCustomerAddresses["addresses"] = addresses
        
        do {
            let addressDict = ["customer_address": newAddress]
            let data = try JSONSerialization.data(withJSONObject: addressDict)
            let customerAddress = try JSONDecoder().decode(CustomerAddress.self, from: data)
            completion(customerAddress, nil)
        } catch {
            completion(nil, error)
        }
        
        removeAddress(withId: 12345678901234)
    }
    
    private func removeAddress(withId id: Int) {
        if var addresses = fakeCustomerAddresses["addresses"] as? [[String: Any]] {
            if let index = addresses.firstIndex(where: { ($0["id"] as? Int) ==  12345678901234 }) {
                addresses.remove(at: index)
            }
            fakeCustomerAddresses["addresses"] = addresses
        }
        
    }
    
}
