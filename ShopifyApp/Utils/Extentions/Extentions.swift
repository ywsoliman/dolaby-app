//
//  Extentions.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 09/06/2024.
//

import Foundation
import UIKit
import Combine
extension UIView{
  @IBInspectable  var cornerRaduis:CGFloat{
      get {return self.cornerRaduis}
        set{
            self.layer.cornerRadius = newValue
        }
    }
}

extension Double {
    func priceFormatter() -> String {
        return String(format: "%.2f", self)
    }
}

extension UISearchBar {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: self.searchTextField)
            .compactMap { ($0.object as? UISearchTextField)?.text }
            .eraseToAnyPublisher()
    }
}

extension DraftOrder {
    
    func toUpdateRequestDictionary() -> [String: Any] {
        let lineItemsArray = self.lineItems.map { lineItem -> [String: Any] in
            return [
                "variant_id": lineItem.variantID,
                "quantity": lineItem.quantity
            ]
        }
        
        let draftOrderDictionary: [String: Any] = [
            "id": self.id,
            "line_items": lineItemsArray
        ]
        
        return ["draft_order": draftOrderDictionary]
    }
    
}
