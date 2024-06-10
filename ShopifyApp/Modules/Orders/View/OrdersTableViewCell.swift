//
//  OrdersTableViewCell.swift
//  ShopifyApp
//
//  Created by Israa Assem on 03/06/2024.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var orderSize: UILabel!
    @IBOutlet weak var orderQuantity: UILabel!
    @IBOutlet weak var orderSubName: UILabel!
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var orderImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
