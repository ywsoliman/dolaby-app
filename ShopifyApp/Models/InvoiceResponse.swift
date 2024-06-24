//
//  InvoiceResponse.swift
//  ShopifyApp
//
//  Created by Israa Assem on 21/06/2024.
//

import Foundation

struct InvoiceResponse: Codable {
    let draftOrderInvoice: DraftOrderInvoice

    enum CodingKeys: String, CodingKey {
        case draftOrderInvoice = "draft_order_invoice"
    }
}

struct DraftOrderInvoice: Codable {
    let to, subject, customMessage: String
    let bcc: [String]

    enum CodingKeys:  String,CodingKey{
        case to,subject
        case customMessage = "custom_message"
        case bcc
    }
}
