//
//  LoadingIndicator.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 20/06/2024.
//

import Foundation
import UIKit

class LoadingIndicator {
    
    private static var loadingIndicator: UIActivityIndicatorView?
    
    private init() {}
    
    static func start(on view: UIView) {
        if loadingIndicator == nil {
            loadingIndicator = UIActivityIndicatorView(style: .large)
        }
        
        guard let indicator = loadingIndicator else { return }
        
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
    }
    
    static func stop() {
        loadingIndicator?.stopAnimating()
        loadingIndicator?.removeFromSuperview()
        loadingIndicator = nil
    }
}
