//
//  MeViewController.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 12/06/2024.
//

import UIKit

class MeViewController: UIViewController {

    @IBOutlet weak var ordersTable: UITableView!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    var ordersViewModel: OrdersViewModelProtocol?
    let indicator = UIActivityIndicatorView(style: .large)
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib=UINib(nibName: "OrdersTableViewCell", bundle: nil)
        ordersTable.dataSource=self
        ordersTable.register(cellNib, forCellReuseIdentifier: "ordersCell")
        indicator.startAnimating()
        ordersViewModel = OrdersViewModel(service: NetworkService.shared)
        ordersViewModel?.fetchOrders()
        ordersViewModel?.bindOrdersToViewController={[weak self] in
            DispatchQueue.main.async {
                self?.indicator.stopAnimating()
                self?.ordersTable.reloadData()
            }
        }
        view.addSubview(indicator)
        indicator.center = self.view.center
        indicator.startAnimating()
        ordersTable.layer.shadowRadius=5
        ordersTable.layer.masksToBounds=false
        ordersTable.layer.shadowColor=UIColor.gray.cgColor
        ordersTable.layer.shadowOffset=CGSize(width: 0, height: 0)
        ordersTable.layer.shadowOpacity = 0.3
        welcomeLabel.text="Welcome, \(CurrentUser.user?.firstName ?? "Customer")"
    }

    override func viewWillAppear(_ animated: Bool) {
        ordersTable.reloadData()
    }
    @IBAction func onLogout(_ sender: Any) {
       _ = LocalDataSource.shared.deleteFromKeychain()
        let storyboard = UIStoryboard(name: "Samuel", bundle: nil)
         guard let onBoardingVC = storyboard.instantiateViewController(withIdentifier: "onboardingVC") as? OnboardingViewController else {
             return
         }
        onBoardingVC.modalPresentationStyle = .fullScreen
        self.present(onBoardingVC, animated: true)
        self.navigationController?.viewControllers = []

    }
    
    
    @IBAction func settingsBtn(_ sender: UIButton) {
        
        let settingsStoryboard = UIStoryboard(name: "SettingsStoryboard", bundle: nil)
        
        if let settingsVC = settingsStoryboard.instantiateViewController(withIdentifier: "SettingsTableViewController") as? SettingsTableViewController {
            navigationController?.pushViewController(settingsVC, animated: true)
        }
        
    }
}
extension MeViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ordersCell", for: indexPath) as! OrdersTableViewCell
        cell.orderPrice.text=ordersViewModel?.getOrders().first?.currentTotalPrice
        if let createdAtString = ordersViewModel?.getOrders().first?.createdAt {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let date = formatter.date(from: createdAtString) {
                formatter.dateFormat = "yyyy-MM-dd' 'HH:mm"
                let formattedDate = formatter.string(from: date)
                cell.orderDate.text = formattedDate
            } else {
                cell.orderDate.text=ordersViewModel?.getOrders().first?.createdAt
                print("Error: Unable to convert date from string")
            }
        } else {
            print("Error: createdAt string is nil")
        }
        return cell
    }
    
    
}
