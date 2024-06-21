//
//  CollectionViewHeaderReusable.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 20/06/2024.
//

import UIKit

class CollectionViewHeaderReusable: UICollectionReusableView {
    
    static let identifier = "CollectionViewHeaderReusable"
    
    @IBOutlet weak var headerLabel: UILabel!
    
    func configure(_ title: String) {
        headerLabel.text = title
    }
    
}
