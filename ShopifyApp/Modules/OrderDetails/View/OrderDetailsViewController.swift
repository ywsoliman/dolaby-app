//
//  OrderDetailsViewController.swift
//  ShopifyApp
//
//  Created by Israa Assem on 17/06/2024.
//

import UIKit

class OrderDetailsViewController: UIViewController {
    var orderID:Int!
    var orderDetailsViewModel:OrderDetailsViewModelProtocol?=nil
    let indicator=UIActivityIndicatorView()
    @IBOutlet weak var orderItemsTable: UITableView!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib=UINib(nibName: "OrderDetailsTableViewCell", bundle: nil)
        orderItemsTable.dataSource=self
        orderItemsTable.register(cellNib, forCellReuseIdentifier: "orderItemsCell")
        indicator.startAnimating()
        orderDetailsViewModel=OrderDetailsViewModel(network:NetworkService.shared)
        orderDetailsViewModel?.fetchOrder(orderId: orderID)
        orderDetailsViewModel?.bindOrderToViewController={[weak self]in
            self?.indicator.stopAnimating()
            self?.loadData()
        }
        backgroundView.layer.cornerRadius = 30
        backgroundView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
    func loadData(){
        if let createdAtString = orderDetailsViewModel?.getOrder()?.created_at {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let date = formatter.date(from: createdAtString) {
                formatter.dateFormat = "yyyy-MM-dd' 'HH:mm"
                let formattedDate = formatter.string(from: date)
                orderDate.text = formattedDate
            } else {
                orderDate.text=orderDetailsViewModel?.getOrder()?.created_at
                print("Error: Unable to convert date from string")
            }
        } else {
            print("Error: createdAt string is nil")
        }
        orderPrice.text=(orderDetailsViewModel?.getOrder()?.total_price ?? "0") + " " + (orderDetailsViewModel?.getOrder()?.currency ?? "USD")
        customerName.text=(orderDetailsViewModel?.getOrder()?.customer?.firstName ?? "FName")+" "+(orderDetailsViewModel?.getOrder()?.customer?.lastName ?? "LName")
        orderItemsTable.reloadData()
    }
    
    
}
extension OrderDetailsViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderDetailsViewModel?.getOrder()?.line_items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "orderItemsCell", for: indexPath) as! OrderDetailsTableViewCell
        cell.layer.shadowRadius=5
        cell.layer.masksToBounds=false
        cell.layer.shadowColor=UIColor.black.cgColor
        cell.layer.shadowOffset=CGSize(width: 1, height: 1)
        cell.layer.shadowOpacity = 0.3
        
        cell.itemName.text=orderDetailsViewModel?.getOrder()?.line_items?[indexPath.row].name
        cell.itemPrice.text=(orderDetailsViewModel?.getOrder()?.line_items?[indexPath.row].price ?? "0") + " " + (orderDetailsViewModel?.getOrder()?.currency ?? "USD")
        cell.itemQuantity.text="Items : "+String(orderDetailsViewModel?.getOrder()?.line_items?[indexPath.row].quantity ?? 0 )
        
//        let productId=orderDetailsViewModel?.getOrder()?.line_items?[indexPath.row].productId
//        let url=URL(string: orderDetailsViewModel?.getProductImage(productId: productId) ?? "https://images.pexels.com/photos/292999/pexels-photo-292999.jpeg?cs=srgb&dl=pexels-goumbik-292999.jpg&fm=jpg")
//        guard let imageUrl=url else{
//            print("Error loading image: ",APIError.invalidURL)
//            return cell
//        }
//        cell.itemImage.kf.setImage(with: imageUrl, placeholder: UIImage(named: "loadingPlaceholder"))
        return cell
    }
}
