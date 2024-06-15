//
//  MainTabBarViewController.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 11/06/2024.
//

import UIKit

class MainTabBarViewController: UITabBarController ,UITabBarControllerDelegate{
    @IBOutlet weak var searchBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate=self
    }
   
    @IBAction func onSearchBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Samuel", bundle: nil)
        guard let searchViewController = storyboard.instantiateViewController(withIdentifier: "SearchScreenViewController") as? SearchScreenViewController else {
            return
        }
        navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    @IBAction func onFavPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Samuel", bundle: nil)
        guard let favViewController = storyboard.instantiateViewController(withIdentifier: "FavouriteScreenViewController") as? FavouriteScreenViewController else {
            return
        }
        navigationController?.pushViewController(favViewController, animated: true)
    }
    @IBAction func cartBarBtn(_ sender: UIBarButtonItem) {
        
        let paymentStoryboard = UIStoryboard(name: "PaymentStoryboard", bundle: nil)
        
        if let cartVC = paymentStoryboard.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController {
            navigationController?.pushViewController(cartVC, animated: true)
        }
        
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            switch self.selectedIndex {
            case 0:
                self.searchBtn.isHidden = false
            default:
                self.searchBtn.isHidden = true
            }
        }
}
