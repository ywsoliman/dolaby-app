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
        checkUserAndProceed(actionType: .favorites)

    }
    @IBAction func cartBarBtn(_ sender: UIBarButtonItem) {
        checkUserAndProceed(actionType: .cart)

    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            switch self.selectedIndex {
            case 2:
                self.searchBtn.isHidden = true
                let authenticated = CurrentUser.type == UserType.authenticated
                if !authenticated {
                    showAlert(message: "You need to login first.") {
                        let storyboard = UIStoryboard(name: "Samuel", bundle: nil)
                          let loginVC =
                                storyboard.instantiateViewController(identifier: "loginNav") as UINavigationController
                        loginVC.modalPresentationStyle = .fullScreen
                        loginVC.modalTransitionStyle = .flipHorizontal
                        self.present(loginVC, animated: true)
                        self.navigationController?.viewControllers = []
                    }
                    self.selectedIndex = 0
                }
            default:
                self.searchBtn.isHidden = false
            }
        }
}
extension MainTabBarViewController{
    func showAlert(message: String, okHandler: @escaping () -> Void) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                okHandler()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
        }
    func checkUserAndProceed(actionType: ActionType) {
        let isAuthenticated = CurrentUser.type == UserType.authenticated ? true : false
            if isAuthenticated {
                switch actionType {
                case .favorites:
                    let storyboard = UIStoryboard(name: "Samuel", bundle: nil)
                    if let favViewController = storyboard.instantiateViewController(withIdentifier: "FavouriteScreenViewController") as? FavouriteScreenViewController {
                        navigationController?.pushViewController(favViewController, animated: true)
                    }
                case .cart:
                    let paymentStoryboard = UIStoryboard(name: "PaymentStoryboard", bundle: nil)
                    if let cartVC = paymentStoryboard.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController {
                        navigationController?.pushViewController(cartVC, animated: true)
                    }
                }
            } else {
                showAlert(message: "You need to login first.") {
                    let storyboard = UIStoryboard(name: "Samuel", bundle: nil)
                    let loginVC = storyboard.instantiateViewController(identifier: "loginNav") as UINavigationController
                    loginVC.modalPresentationStyle = .fullScreen
                    loginVC.modalTransitionStyle = .flipHorizontal
                    self.present(loginVC, animated: true)
                    self.navigationController?.viewControllers = []
                }
            }
        }
}
enum ActionType {
    case favorites
    case cart
}
