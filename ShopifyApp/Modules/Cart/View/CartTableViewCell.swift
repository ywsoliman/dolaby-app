//
//  CartTableViewCell.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 24/05/2024.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    static let identifier = "CartTableViewCell"
    
    static func nib() -> UINib {
        UINib(nibName: "CartTableViewCell", bundle: nil)
    }
        
    @IBOutlet weak var quantityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func incrementBtn(_ sender: UIButton) {
        guard let quantity = Int(quantityLabel.text!) else { return }
        quantityLabel.text = String(quantity + 1)
    }
    
    @IBAction func decrementBtn(_ sender: UIButton) {
        guard let quantity = Int(quantityLabel.text!) else { return }
        if quantity > 1 {
            quantityLabel.text = String(quantity - 1)
        }
    }
}
