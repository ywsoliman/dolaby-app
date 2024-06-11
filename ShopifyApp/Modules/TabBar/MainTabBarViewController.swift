//
//  MainTabBarViewController.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 11/06/2024.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cartBarBtn(_ sender: UIBarButtonItem) {
        
        let paymentStoryboard = UIStoryboard(name: "PaymentStoryboard", bundle: nil)
        
        if let cartVC = paymentStoryboard.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController {
            navigationController?.pushViewController(cartVC, animated: true)
        }
        
    }
    
}
