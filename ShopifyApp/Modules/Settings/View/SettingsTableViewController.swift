//
//  SettingsViewController.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 01/06/2024.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var currencyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyLabel.text = CurrencyManager.currency
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCurrencySegue" {
            let destVC = segue.destination as? CurrenciesTableViewController
            destVC?.onCurrencyChanged = { selectedCurrency in
                self.currencyLabel.text = selectedCurrency
            }
        }
    }
    
}
