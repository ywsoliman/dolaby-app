//
//  DiscountPageControlReusableView.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 20/06/2024.
//

import UIKit

class DiscountPageControlReusableView: UICollectionReusableView, DiscountPageControlDelegate {
    
    static let identifier = "DiscountPageControlReusableView"
    
    @IBOutlet weak var discountPageControl: UIPageControl!
    
    func configure(_ page: Int) {
        discountPageControl.currentPage = page
    }
    
}
