//
//  ProductInfoCollectionViewCell.swift
//  ShopifyApp
//
//  Created by Samuel Adel on 13/06/2024.
//

import UIKit
import Kingfisher

class ProductInfoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImage: UIImageView!
    func setup(_ image:Image){
        guard let src = image.src, let url = URL(string: src) else { return }
        productImage.kf.setImage(with: url)
    }
}
