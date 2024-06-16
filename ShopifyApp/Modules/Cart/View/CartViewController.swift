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
    
    private var totalPrice: Double!
    
    private var cartViewModel: CartViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartTableViewCell.nib(), forCellReuseIdentifier: CartTableViewCell.identifier)
        
        cartViewModel = CartViewModel(service: NetworkService.shared)
        cartViewModel.bindCartToViewController = { [weak self] in
            self?.setTotalPrice()
            self?.tableView.reloadData()
        }
        
    }
    
    func setTotalPrice() {
        
        guard let cart = cartViewModel.cart else { return }
        
        totalPrice = cart.lineItems.reduce(0.0) { (result, item) -> Double in
            return result + (Double(item.price)! * Double(item.quantity))
        }
        totalPrice *= CurrencyManager.value
        priceLabel.text = totalPrice.priceFormatter()
    }
    
    func updateTotalPrice() {
        priceLabel.text = totalPrice.priceFormatter()
    }
    
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource, CartTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfItems = cartViewModel.cart?.lineItems.count ?? 0
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
        cell.delegate = self
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
            
            guard let cart = self.cartViewModel.cart else { return }
            if cart.lineItems.count > 1 {
                self.cartViewModel.deleteItem(withId: cart.lineItems[indexPath.row].id)
            } else {
                self.cartViewModel.deleteCart()
            }
            self.cartViewModel.productsVariants.remove(at: indexPath.row)
            
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func cartCellIncrementBtn(_ cell: CartTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let productVariant = cartViewModel.productsVariants[indexPath.row]
        let inventoryQuantity = productVariant.inventoryQuantity
        if cell.itemQuantity < inventoryQuantity {
            cell.itemQuantity += 1
            cartViewModel.cart?.lineItems[indexPath.row].quantity = cell.itemQuantity
            cell.quantityLabel.text = String(cell.itemQuantity)
            cell.updateButtonState(maxQuantity: inventoryQuantity)
            totalPrice += Double(productVariant.price) ?? 0.0
            updateTotalPrice()
        }
    }
    
    func cartCellDecrementBtn(_ cell: CartTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let productVariant = cartViewModel.productsVariants[indexPath.row]
        let inventoryQuantity = productVariant.inventoryQuantity
        if cell.itemQuantity > 1 {
            cell.itemQuantity -= 1
            cartViewModel.cart?.lineItems[indexPath.row].quantity = cell.itemQuantity
            cell.quantityLabel.text = String(cell.itemQuantity)
            cell.updateButtonState(maxQuantity: inventoryQuantity)
            totalPrice -= Double(productVariant.price) ?? 0.0
            updateTotalPrice()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "checkoutSegue" {
            guard let cart = cartViewModel.cart else { return }
            let destVC = segue.destination as? CheckoutViewController
            destVC?.checkoutViewModel = CheckoutViewModel(service: NetworkService.shared, draftOrder: cart, subtotal: totalPrice)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        cartViewModel.updateCart()
    }
    
}
