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
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
        orderDetailsViewModel=OrderDetailsViewModel(network:NetworkService.shared)
        orderDetailsViewModel?.fetchOrder(orderId: orderID)
        orderDetailsViewModel?.bindOrderToViewController={[weak self]in
            self?.indicator.stopAnimating()
            self?.loadData()
        }
    }
    func loadData(){
        print("order details data is loaded")
    }
    

}
