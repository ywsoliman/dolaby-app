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
        try await  authDataResult.user.sendEmailVerification()
        try await db.collection("users").document(uid).setData([
            "firstName": customer.firstName,
                        "lastName": customer.lastName,
                        "phoneNumber": customer.phone,
                        "email": customer.email,
                        "id": customer.id ?? 0
                    ])
    }
    func login(customer:CustomerCredentials)async throws->CustomerData{
        let authDataResult = try await Auth.auth().signIn(withEmail: customer.email, password: customer.password)
        if !authDataResult.user.isEmailVerified {
            throw NSError(domain: "com.yourapp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Email Not verified"])
        }
        print(authDataResult.user.uid)
        let customer:CustomerData = try await fetchUserData(uid: authDataResult.user.uid)
        return customer
    }
    func addUserID(shopifyID:Int,userID:String)async throws{
        try await db.collection("users").document(userID).setData([
                                 "id": shopifyID
                    ])
    }
    func fetchUserData(uid: String) async throws -> CustomerData {
        let document = try await db.collection("users").document(uid).getDocument()
        guard let data = document.data(),
              let email = data["email"] as? String,
              let fName = data["firstName"] as? String,
              let lName = data["lastName"] as? String,
              let phone = data["phoneNumber"] as? String,
              let id = data["id"] as? Int
              else {
            throw NSError(domain: "com.yourapp", code: -1, userInfo: [NSLocalizedDescriptionKey: "User data is invalid"])
        }
        return CustomerData(id:id, userId: uid,firstName:fName, lastName: lName, phone: phone, email: email, password: "")
    }
    
}


