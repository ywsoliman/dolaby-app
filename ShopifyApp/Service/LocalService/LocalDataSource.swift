//
//  CoreDataManager.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 11/06/2024.
//

import Foundation
import UIKit
import Security
enum LocalDataSourceError: Error {
    case dataNotFound
    case errorHappenedSaving
}
class LocalDataSource {
    static var shared:LocalDataSource = LocalDataSource()
    
    private func saveToKeychain(service: String =  "com.yourapp.user", account: String = "userID", data: Data) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func saveCustomerId(service: String =  "com.yourapp.user", account: String = "userID",customerID:Int)->Bool{
        var int = customerID
        let data = Data(bytes: &int, count: MemoryLayout<Int>.size)
        return self.saveToKeychain(service:service , account:account ,data: data)
    }
   private func retrieveFromKeychain(service: String =  "com.yourapp.user", account: String = "userID")throws -> Data {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status == errSecSuccess {
            return result as! Data
        }else{
            throw LocalDataSourceError.dataNotFound
        }
    }
    
    func retrieveCustomerId(service: String = "com.yourapp.user", account: String = "userID") throws -> Int {
            let data = try retrieveFromKeychain(service: service, account: account)
            return data.withUnsafeBytes { $0.load(as: Int.self) }
        }
    
    
    func deleteFromKeychain(service: String =  "com.yourapp.user", account: String = "userID") -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }


}
