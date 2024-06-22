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
        let result = self * CurrencyManager.value
        return String(format: "%.2f \(CurrencyManager.currency)", result)
    }
}

extension String {
    func priceFormatter() -> String {
        let result = Double(self)! * CurrencyManager.value
        return String(format: "%.2f \(CurrencyManager.currency)", result)
    }
}
extension String {
    func priceFormatterValue() -> String {
        let result = Double(self)! * CurrencyManager.value
        return String(format: "%.2f", result)
    }
}

extension UISearchBar {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: self.searchTextField)
            .compactMap { ($0.object as? UISearchTextField)?.text }
            .eraseToAnyPublisher()
    }
}

extension Encodable {
    func toDictionary() -> [String: Any]? {
        do {
            let data = try JSONEncoder().encode(self)
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            return jsonObject as? [String: Any]
        } catch {
            print("Error converting object to dictionary: \(error)")
            return nil
        }
    }
}
