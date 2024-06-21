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
    private static var backgroundView: UIView?
    
    private init() {}
    
    static func start(on view: UIView) {
        if backgroundView == nil {
            backgroundView = UIView(frame: view.bounds)
            backgroundView?.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        }
        
        if loadingIndicator == nil {
            loadingIndicator = UIActivityIndicatorView(style: .large)
            loadingIndicator?.center = view.center
        }
        
        guard let background = backgroundView, let indicator = loadingIndicator else { return }
        
        view.addSubview(background)
        view.addSubview(indicator)
        
        indicator.startAnimating()
    }
    
    static func stop() {
        loadingIndicator?.stopAnimating()
        loadingIndicator?.removeFromSuperview()
        backgroundView?.removeFromSuperview()
        
        loadingIndicator = nil
        backgroundView = nil
    }
}
