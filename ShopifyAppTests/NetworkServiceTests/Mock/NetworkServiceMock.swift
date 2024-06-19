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
    
    private static let fakeCustomerDetails: [String: Any] = [
        "id": TEST_CUSTOMER_ID,
        "email": "steve.lastnameson@example.com",
        "first_name": "Testing",
        "last_name": "Account",
        "orders_count": 0,
        "state": "enabled",
        "total_spent": "0.00",
        "last_order_id": NSNull(),
        "note": NSNull(),
        "verified_email": true,
        "multipass_identifier": NSNull(),
        "tax_exempt": false,
        "tags": "",
        "last_order_name": NSNull(),
        "currency": "EGP",
        "phone": "+15142546011",
        "default_address": [
            "id": 10200923275564,
            "customer_id": 8140780732716,
            "first_name": "Mother",
            "last_name": "Lastnameson",
            "company": NSNull(),
            "address1": "123 Oak St",
            "address2": NSNull(),
            "city": "Ottawa",
            "province": "Ontario",
            "country": "Canada",
            "zip": "123 ABC",
            "phone": "555-1212",
            "name": "Mother Lastnameson",
            "province_code": "ON",
            "country_code": "CA",
            "country_name": "Canada",
            "default": true
        ]
    ]
    
    private static let fakeCustomer: [String: Any] = [
        "customer": [
            fakeCustomerDetails
        ]
    ]
    
    private let fakeDraftOrder: [String: Any] = [
        "draft_order": [
            "id": TEST_CART_ID,
            "email": "steve.lastnameson@example.com",
            "currency": "EGP",
            "completed_at": NSNull(),
            "name": "#D123",
            "status": "open",
            "line_items": [
                [
                    "id": 58462073913644,
                    "variant_id": 48945467031852,
                    "product_id": 9365476245804,
                    "title": "ADIDAS | CLASSIC BACKPACK",
                    "variant_title": "OS / black",
                    "sku": "AD-03-black-OS",
                    "vendor": "ADIDAS",
                    "quantity": 1,
                    "applied_discount": NSNull(),
                    "name": "ADIDAS | CLASSIC BACKPACK - OS / black",
                    "price": "70.00",
                ]
            ],
            "shipping_address": [
                "first_name": "Mother",
                "address1": "123 Oak St",
                "phone": "555-1212",
                "city": "Ottawa",
                "zip": "123 ABC",
                "province": "Ontario",
                "country": "Canada",
                "last_name": "Lastnameson",
                "address2": NSNull(),
                "company": NSNull(),
                "latitude": NSNull(),
                "longitude": NSNull(),
                "name": "Mother Lastnameson",
                "country_code": "CA",
                "province_code": "ON"
            ],
            "billing_address": [
                "first_name": "Mother",
                "address1": "123 Oak St",
                "phone": "555-1212",
                "city": "Ottawa",
                "zip": "123 ABC",
                "province": "Ontario",
                "country": "Canada",
                "last_name": "Lastnameson",
                "address2": NSNull(),
                "company": NSNull(),
                "latitude": 45.406837,
                "longitude": -75.7138004,
                "name": "Mother Lastnameson",
                "country_code": "CA",
                "province_code": "ON"
            ],
            "applied_discount": NSNull(),
            "order_id": NSNull(),
            "total_price": "70.00",
            "subtotal_price": "70.00",
            "total_tax": "0.00",
            "customer": fakeCustomerDetails
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
    
    func getDraftOrder(completion: @escaping (DraftOrderResponse?, Error?) -> Void) {
        
        var draftOrder: DraftOrderResponse?
        
        do {
            let data = try JSONSerialization.data(withJSONObject: fakeDraftOrder)
            draftOrder = try JSONDecoder().decode(DraftOrderResponse.self, from: data)
        } catch {
            print("Mock error \(error)")
        }
        
        shouldFail ? completion(nil, NetworkError.genericError) : completion(draftOrder, nil)
        
    }
    
    func createDraftOrderWithProduct(completion: @escaping (DraftOrderResponse?, Error?) -> Void) {
        
        guard !shouldFail else {
            completion(nil, NetworkError.genericError)
            return
        }
        
        var draftOrder: DraftOrderResponse?
        
        var newDraftOrder: [String: Any] = fakeDraftOrder
        newDraftOrder["id"] = TEST_CART_ID + 1
        
        do {
            let data = try JSONSerialization.data(withJSONObject: newDraftOrder)
            draftOrder = try JSONDecoder().decode(DraftOrderResponse.self, from: data)
            completion(draftOrder, nil)
        } catch {
            completion(nil, error)
        }
        
    }
    
}
