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
        
        let authDataResult = try await Auth.auth().createUser(withEmail: customer.email, password: customer.password!)
        let uid = authDataResult.user.uid
        try await db.collection("users").document(uid).setData([
                        "email": customer.email,
                        "id": customer.id!
                    ])
        
    }
    func login(customer:CustomerCredentials)async throws->CustomerData{
        let authDataResult = try await Auth.auth().signIn(withEmail: customer.email, password: customer.password)
        print(authDataResult.user.uid)
        let customer:CustomerData = try await fetchUserData(uid: authDataResult.user.uid)
        print(customer.id)
        print(customer.email)
        return customer
    }
    func fetchUserData(uid: String) async throws -> CustomerData {
        let document = try await db.collection("users").document(uid).getDocument()
        guard let data = document.data(),
              let email = data["email"] as? String,
              let id = data["id"] as? Int
              else {
            throw NSError(domain: "com.yourapp", code: -1, userInfo: [NSLocalizedDescriptionKey: "User data is invalid"])
        }
        print("id = \(id)")
        return CustomerData(id:id,firstName:"", lastName: "", phone: "", email: email, password: "")
    }
    
}


