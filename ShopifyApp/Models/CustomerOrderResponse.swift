//
//  CustomerOrderResponse.swift
//  ShopifyApp
//
//  Created by Israa Assem on 15/06/2024.
//

import Foundation
struct CustomerOrdersResponse:Codable{
    let orders:[Order]?
}
struct Order: Codable {
    let id: Int?
    let contactEmail: String?
    let createdAt: String?
    let currency: String?
    let currentTotalPrice: String?
    let email: String?
    let number: Int?
    let orderNumber: Int?
    let presentmentCurrency: String?
    let processedAt: String?
    let subtotalPrice,totalPrice: String?
    let totalWeight: Int?
    let updatedAt: String?
    let customer: CustomerModel?
    let lineItems: [LineItemModel]?
    let shippingAddress: Address?
    
    enum CodingKeys: String, CodingKey {
        case id
        case contactEmail = "contact_email"
        case createdAt = "created_at"
        case currency
        case currentTotalPrice = "current_total_price"
        case email
        case number
        case orderNumber = "order_number"
        case presentmentCurrency = "presentment_currency"
        case processedAt = "processed_at"
        case subtotalPrice = "subtotal_price"
        case totalPrice = "total_price"
        case totalWeight = "total_weight"
        case updatedAt = "updated_at"
        case customer
        case lineItems = "line_items"
        case shippingAddress = "shipping_address"
    }
}

struct CustomerModel: Codable {
    let id: Int
    let email: String
    let createdAt: String
    let updatedAt: String
    let firstName: String
    let lastName: String
    let state: String
    let verifiedEmail: Bool
    let phone: String
    let emailMarketingConsent: EmailMarketingConsent
    let currency: String
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case firstName = "first_name"
        case lastName = "last_name"
        case state
        case verifiedEmail = "verified_email"
        case phone
        case emailMarketingConsent = "email_marketing_consent"
        case currency
        
    }
}
struct LineItemModel: Codable {
    let id: Int
    let currentQuantity: Int
    let fulfillableQuantity: Int
    let fulfillmentService: String
    let grams: Int
    let name: String
    let price: String
    let quantity: Int
    let title: String
    let variantId: Int?
    let productId:Int?
    let variantInventoryManagement: String?
    let variantTitle: String?
    let vendor: String?
    enum CodingKeys: String, CodingKey {
      case id
      case currentQuantity = "current_quantity"
      case fulfillableQuantity = "fulfillable_quantity"
      case fulfillmentService = "fulfillment_service"
      case grams,productId="product_id"
      case name
      case price
      case quantity
      case title
      case variantId = "variant_id"
      case variantInventoryManagement = "variant_inventory_management"
      case variantTitle = "variant_title"
      case vendor
    }
}

struct EmailMarketingConsent: Codable {
    let state: String?
    let optInLevel: String?
    let consentUpdatedAt: String?
    enum CodingKeys: String, CodingKey {
      case state
      case optInLevel = "opt_in_level"
      case consentUpdatedAt = "consent_updated_at"
    }
}


