//
//  CartTableViewCell.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 24/05/2024.
//

import UIKit
import Kingfisher

protocol CartTableViewCellDelegate {
    func cartCellIncrementBtn(_ cell: CartTableViewCell)
    func cartCellDecrementBtn(_ cell: CartTableViewCell)
}

class CartTableViewCell: UITableViewCell {
    
    static let identifier = "CartTableViewCell"
    
    static func nib() -> UINib {
        UINib(nibName: "CartTableViewCell", bundle: nil)
    }
    
    var delegate: CartTableViewCellDelegate?
    
    var itemQuantity: Int!
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var decrementBtn: UIButton!
    @IBOutlet weak var incrementBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func incrementBtn(_ sender: UIButton) {
        delegate?.cartCellIncrementBtn(self)
    }
    
    @IBAction func decrementBtn(_ sender: UIButton) {
        delegate?.cartCellDecrementBtn(self)
    }
    
    func updateButtonState(maxQuantity: Int) {
        incrementBtn.isEnabled = itemQuantity < maxQuantity
        decrementBtn.isEnabled = itemQuantity > 1
    }
    
    func configure(lineItem: LineItem) {
        
        itemQuantity = lineItem.quantity
        let price = Double(lineItem.price)! * CurrencyManager.value
        priceLabel.text = "\(price.priceFormatter()) \(CurrencyManager.currency)"
        titleLabel.text = lineItem.title
        descLabel.text = lineItem.variantTitle
        quantityLabel.text = String(itemQuantity)
        
        NetworkService.shared.makeRequest(endPoint: "/products/\(lineItem.productID)/images.json", method: .get) { (result: Result<ProductImages, APIError>) in
            
            switch result {
            case .success(let image):
                self.setProductImage(src: image.images[0].src!)
            case .failure(let error):
                print("Failed to set cart image: \(error)")
            }
            
        }
        
    }
    
    private func setProductImage(src: String) {
        productImage.kf.setImage(
            with: URL(string: src),
            placeholder: UIImage(named: "placeholder"),
            options: [.processor(DownsamplingImageProcessor(size: self.productImage.bounds.size))])
    }
}
