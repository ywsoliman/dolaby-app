//
//  Alert.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 20/06/2024.
//

import Foundation
import UIKit

func alert(title: String, message: String, viewController: UIViewController, actions: UIAlertAction...) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    for action in actions {
        alert.addAction(action)
    }
    
    viewController.present(alert, animated: true)
}

func alertWithDuration(message: String, viewController: UIViewController) {
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    viewController.present(alert, animated: true)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        alert.dismiss(animated: true)
    }
}
