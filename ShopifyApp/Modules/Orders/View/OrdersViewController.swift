//
//  OrdersViewController.swift
//  ShopifyApp
//
//  Created by Israa Assem on 03/06/2024.
//

import UIKit

class OrdersViewController: UIViewController {
    var ordersViewModel: OrdersViewModelProtocol?
    let indicator = UIActivityIndicatorView(style: .large)
    @IBOutlet weak var ordersTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib=UINib(nibName: "OrdersTableViewCell", bundle: nil)
        ordersTable.delegate=self
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
    }

}
extension OrdersViewController:UITableViewDelegate{
    
}
extension OrdersViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ordersViewModel?.getOrdersCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ordersCell", for: indexPath) as! OrdersTableViewCell
        cell.orderPrice.text=ordersViewModel?.getOrders()[indexPath.row].currentTotalPrice
        cell.orderDate.text=ordersViewModel?.getOrders()[indexPath.row].createdAt
//        cell.layer.cornerRadius=15
//        cell.layer.borderWidth=0.5
//        cell.layer.masksToBounds=true
//        cell.layer.borderColor=UIColor.gray.cgColor
        cell.layer.shadowRadius=5
        cell.layer.masksToBounds=false
        cell.layer.shadowColor=UIColor.black.cgColor
        cell.layer.shadowOffset=CGSize(width: 1, height: 1)
        cell.layer.shadowOpacity = 0.3
        return cell
    }
    
    
}
