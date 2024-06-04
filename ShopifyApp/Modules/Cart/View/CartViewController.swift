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
    var rows = 2

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartTableViewCell.nib(), forCellReuseIdentifier: CartTableViewCell.identifier)
        
    }
    
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checkIfCartIsEmpty()
        return rows
    }
    
    func checkIfCartIsEmpty() {
        if rows == 0 {
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier) as! CartTableViewCell
        
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
            self.rows -= 1
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}
