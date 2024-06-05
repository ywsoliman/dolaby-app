//
//  CartViewController.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 24/05/2024.
//

import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet weak var emptyCartView: UIView!
    @IBOutlet weak var priceSection: UIStackView!
    @IBOutlet weak var checkoutBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priceLabel: UILabel!
    
    private var cartViewModel: CartViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartTableViewCell.nib(), forCellReuseIdentifier: CartTableViewCell.identifier)
        
        cartViewModel = CartViewModel(service: NetworkService.shared)
        cartViewModel.bindCartToViewController = { [weak self] in
            self?.priceLabel.text = self?.cartViewModel.cart?.totalPrice
            self?.tableView.reloadData()
        }
        
    }
    
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cart = cartViewModel.cart else { return 0 }
        let numberOfItems = cart.lineItems.count
        checkIfCartIsEmpty(numberOfItems)
        return numberOfItems
    }
    
    
    func checkIfCartIsEmpty(_ numberOfItems: Int) {
        if numberOfItems == 0 {
            emptyCartView.isHidden = false
            checkoutBtn.isEnabled = false
            priceSection.isHidden = true
        } else {
            emptyCartView.isHidden = true
            checkoutBtn.isEnabled = true
            priceSection.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let lineItems = cartViewModel.cart?.lineItems else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier) as! CartTableViewCell
        
        cell.configure(lineItem: lineItems[indexPath.row])
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            deleteCellAlert(indexPath, tableView)
        }
        
    }
    
    func deleteCellAlert(_ indexPath: IndexPath, _ tableView: UITableView) {
        
        let alert = UIAlertController(title: "Delete Confirmation", message: "Are you sure you want to delete this?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}
