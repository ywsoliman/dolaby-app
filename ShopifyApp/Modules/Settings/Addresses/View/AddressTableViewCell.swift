//
//  AddressTableViewCell.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 03/06/2024.
//

import UIKit

class AddressTableViewCell: UITableViewCell {
    
    static let identifier = "AddressTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "AddressTableViewCell", bundle: nil)
    }

    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(address: Address) {
        countryLabel.text = "\(address.countryCode ?? ""), \(address.countryName ?? "")"
        cityLabel.text = address.city ?? ""
        addressLabel.text = address.address1 ?? ""
        phoneLabel.text = address.phone ?? ""
        accessoryType = address.addressDefault ?? false ? .checkmark : .none
    }
    
}
