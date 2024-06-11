//
//  OrdersViewController.swift
//  ShopifyApp
//
//  Created by Israa Assem on 03/06/2024.
//

import UIKit

class OrdersViewController: UIViewController {

    @IBOutlet weak var ordersTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let cellNib=UINib(nibName: "OrdersTableViewCell", bundle: nil)
        ordersTable.delegate=self
        ordersTable.dataSource=self
        ordersTable.register(cellNib, forCellReuseIdentifier: "ordersCell")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension OrdersViewController:UITableViewDelegate{
    
}
extension OrdersViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ordersCell", for: indexPath) as! OrdersTableViewCell
        return cell
    }
    
    
}
