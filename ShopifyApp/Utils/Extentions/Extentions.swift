//
//  Extentions.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 09/06/2024.
//

import Foundation
import UIKit
extension UIView{
  @IBInspectable  var cornerRaduis:CGFloat{
      get {return self.cornerRaduis}
        set{
            self.layer.cornerRadius = newValue
        }
    }
}
