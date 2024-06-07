//
//  AuthenticationManager.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 07/06/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
final class AuthenticationManager{
    static let shared = AuthenticationManager()
    private init(){}
    private let db = Firestore.firestore()

    func createCustomer(customer:CustomerData) async throws{
        
        let authDataResult = try await Auth.auth().createUser(withEmail: customer.email, password: customer.password)
        let uid = authDataResult.user.uid
        try await db.collection("users").document(uid).setData([
                        "email": customer.email,
                        "username": customer.userName,
                        "address": customer.address
                    ])
        
    }
    func login(customer:CustomerCredentials)async throws{
        let authDataResult = try await Auth.auth().signIn(withEmail: customer.email, password: customer.password)
    }
    func fetchUserData(uid: String) async throws -> CustomerData {
        let document = try await db.collection("users").document(uid).getDocument()
        guard let data = document.data(),
              let email = data["email"] as? String,
              let username = data["username"] as? String,
              let address = data["address"] as? String else {
            throw NSError(domain: "com.yourapp", code: -1, userInfo: [NSLocalizedDescriptionKey: "User data is invalid"])
        }
        return CustomerData(email: email, userName: "", address: username, password: address)
    }
    
}


