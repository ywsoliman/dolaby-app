//
//  CategoriesCollectionViewCell.swift
//  ShopifyApp
//
//  Created by Israa Assem on 01/06/2024.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryPrice: UILabel!
    
    @IBOutlet weak var favBtn: UIButton!
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    var cellIndex:Int!
    var delegate:FavItemDelegate?
    @IBAction func onFavBtnPressed(_ sender: Any) {
        print(cellIndex)
        delegate?.didPressFavoriteButton(itemIndex: cellIndex)
    }
}
