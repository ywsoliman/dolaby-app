//
//  DiscountCollectionViewCell.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 20/06/2024.
//

import UIKit

class DiscountCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DiscountCollectionViewCell"
    
    @IBOutlet weak var discountImageView: UIImageView!
    
    func configure(image: UIImage) {
        discountImageView.image = image
    }
    
}
