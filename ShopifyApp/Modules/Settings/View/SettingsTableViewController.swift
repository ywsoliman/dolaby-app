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
    }
    
    @IBAction func logoutBtn(_ sender: UIButton) {
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 1 {
            currencyAlert()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func currencyAlert() {
        
        let alert = UIAlertController(title: "Choose a currency", message: "", preferredStyle: .actionSheet)
        
        let usd = UIAlertAction(title: "USD", style: .default) { action in
            CurrencyService.shared.makeRequest()
            self.currencyLabel.text = action.title!
        }
        let egp = UIAlertAction(title: "EGP", style: .default) { action in
            self.currencyLabel.text = action.title!
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(usd)
        alert.addAction(egp)
        alert.addAction(cancel)
        
        present(alert, animated: true)
        
    }
    
}
