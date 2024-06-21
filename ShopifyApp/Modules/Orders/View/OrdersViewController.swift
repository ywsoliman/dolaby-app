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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Israa", bundle: nil)
         guard let orderDetailsViewController = storyboard.instantiateViewController(withIdentifier: "orderDetailsVC") as? OrderDetailsViewController else {
             return
         }
        orderDetailsViewController.orderID = ordersViewModel?.getOrders()[indexPath.row].id
         navigationController?.pushViewController(orderDetailsViewController, animated: true)
    }
}
extension OrdersViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ordersViewModel?.getOrdersCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ordersCell", for: indexPath) as! OrdersTableViewCell
        cell.orderPrice.text=Double((ordersViewModel?.getOrders()[indexPath.row].currentTotalPrice) ?? "0.0")?.priceFormatter()
        if let createdAtString = ordersViewModel?.getOrders()[indexPath.row].createdAt {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let date = formatter.date(from: createdAtString) {
                formatter.dateFormat = "yyyy-MM-dd' 'HH:mm"
                let formattedDate = formatter.string(from: date)
                cell.orderDate.text = formattedDate
            } else {
                cell.orderDate.text=ordersViewModel?.getOrders()[indexPath.row].createdAt
                print("Error: Unable to convert date from string")
            }
        } else {
            print("Error: createdAt string is nil")
        }
        cell.layer.shadowRadius=5
        cell.layer.masksToBounds=false
        cell.layer.shadowColor=UIColor.black.cgColor
        cell.layer.shadowOffset=CGSize(width: 1, height: 1)
        cell.layer.shadowOpacity = 0.3
        return cell
    }
    
    
}
