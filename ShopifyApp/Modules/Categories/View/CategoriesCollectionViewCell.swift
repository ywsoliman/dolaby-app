//
//  CategoriesCollectionViewCell.swift
//  ShopifyApp
//
//  Created by Israa Assem on 01/06/2024.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryPrice: UILabel!
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryImage.clipsToBounds=true
        categoryImage.layer.cornerRadius=20
        categoryImage.layer.borderColor = UIColor.darkGray.cgColor
        categoryImage.layer.borderWidth=0.5
    }

}
