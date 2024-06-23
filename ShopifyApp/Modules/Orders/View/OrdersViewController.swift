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

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAlert=UIAlertController(title:"Delete order" , message: "Are you sure you want to delete this order?", preferredStyle: .alert)
        let deleteAlertAction=UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let orderId=self?.ordersViewModel?.getOrders()[indexPath.row].id else{
                print("No order if found!")
                return
            }
            self?.ordersViewModel?.deleteOrder(orderId: orderId)
        }
        let noAlertAction=UIAlertAction(title: "No", style: .default)
        deleteAlert.addAction(noAlertAction)
        deleteAlert.addAction(deleteAlertAction)
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") { [weak self](_, _, boolValue) in
            self?.present(deleteAlert, animated: true)
            }
            let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
            return swipeActions
    }
}
extension OrdersViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ordersViewModel?.getOrdersCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ordersCell", for: indexPath) as! OrdersTableViewCell
        cell.orderPrice.text=(ordersViewModel?.getOrders()[indexPath.row].totalPrice ?? "0.0") + " " + (ordersViewModel?.getOrders()[indexPath.row].currency ?? "USD")
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
