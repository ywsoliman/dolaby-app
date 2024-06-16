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
    var cellIndex:Int!
    var delegate:FavItemDelegate?
    private var currentFavImageName: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }


    @IBAction func onFavBtnPressed(_ sender: Any) {
        !isCurrentItemFav() ? delegate?.saveFavItem(itemIndex: cellIndex) : delegate?.deleteFavItem(itemIndex: cellIndex)
        updateFavBtnImage(isFav: !isCurrentItemFav())
    }
    func updateFavBtnImage(isFav:Bool){
        let imageName = isFav ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName)
        favBtn.setImage(image, for: .normal)
        currentFavImageName = imageName
    }
    func isCurrentItemFav() -> Bool {
           return  currentFavImageName == "heart.fill"
       }
}
