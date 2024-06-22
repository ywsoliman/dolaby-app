//
//  CartViewController.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 24/05/2024.
//

import UIKit

enum QuantityUpdateOperation {
    case increment, decrement
}

class CartViewController: UIViewController {
    
    @IBOutlet weak var emptyCartView: UIView!
    @IBOutlet weak var priceSection: UIStackView!
    @IBOutlet weak var checkoutBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priceLabel: UILabel!
    
    private var totalPrice: Double! {
        didSet {
            updateTotalPrice()
        }
    }
    private var cartViewModel: CartViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartTableViewCell.nib(), forCellReuseIdentifier: CartTableViewCell.identifier)
        
        LoadingIndicator.start(on: view)
        
        cartViewModel = CartViewModel(service: NetworkService.shared)
        cartViewModel.bindCartToViewController = { [weak self] in
            self?.updateCartData()
        }
        
        cartViewModel.getCart()
    }
    
    func updateCartData() {
        LoadingIndicator.stop()
        
        let numberOfItems = cartViewModel.cart?.lineItems.count ?? 0
        checkIfCartIsEmpty(numberOfItems)
        
        tableView.reloadData()
        setTotalPrice()
    }
    
    func setTotalPrice() {
        
        guard let cart = cartViewModel.cart else { return }
        
        totalPrice = cart.lineItems.reduce(0.0) { (result, item) -> Double in
            return result + (Double(item.price)! * Double(item.quantity))
        }
        priceLabel.text = totalPrice.priceFormatter()
    }
    
    func updateTotalPrice() {
        priceLabel.text = totalPrice.priceFormatter()
    }
    
    @IBAction func proceedToCheckoutBtn(_ sender: UIButton) {
        
        if CurrentUser.user?.addresses?.count == 0 {
            addAddressAlert()
            return
        }
        
        
        if let destVC = storyboard?.instantiateViewController(withIdentifier: "CheckoutViewController") as? CheckoutViewController {
            LoadingIndicator.start(on: view.self)
            cartViewModel.updateCart { [weak self] in
                
                guard let self = self,
                      let cart = cartViewModel.cart else { return }
                
                destVC.checkoutViewModel = CheckoutViewModel(service: NetworkService.shared, draftOrder: cart, priceBeforeDiscount: totalPrice)
                destVC.onShippingAddressChanged = { draftOrder in
                    self.cartViewModel.cart = draftOrder.draftOrder
                }
                
                DispatchQueue.main.async { LoadingIndicator.stop() }
                navigationController?.pushViewController(destVC, animated: true)
            }
        }
        
        
    }
    
    private func addAddressAlert() {
        
        let alert = UIAlertController(title: "No addresses found", message: "Please provide at least one address to add products to cart", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            self.navigateToAddAddress()
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func navigateToAddAddress() {
        let storyboard = UIStoryboard(name: "SettingsStoryboard", bundle: nil)
        if let destVC = storyboard.instantiateViewController(withIdentifier: "AddAddressTableViewController") as? AddAddressTableViewController {
            navigationController?.pushViewController(destVC, animated: true)
            destVC.onAddressAdded = { [weak self] in
                self?.cartViewModel.getCart()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParent {
            cartViewModel.updateCart {}
        }
        
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource, CartTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartViewModel.cart?.lineItems.count ?? 0
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
                self.cartViewModel.deleteItem(withId: cart.lineItems[indexPath.row].id) { [weak self] in
                    self?.totalPrice -= Double(cart.lineItems[indexPath.row].price)! * Double(cart.lineItems[indexPath.row].quantity)
                    print("Total price after deleting: \(self?.totalPrice ?? -1)")
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            } else {
                LoadingIndicator.start(on: self.view)
                self.cartViewModel.deleteCart() { [weak self] in
                    LoadingIndicator.stop()
                    self?.totalPrice = 0.0
                    self?.checkIfCartIsEmpty(0)
                }
            }
            
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func updateItemQuantity(_ cell: CartTableViewCell, operation: QuantityUpdateOperation) {
        
        
        guard let indexPath = tableView.indexPath(for: cell), let cart = cartViewModel.cart else { return }
        let item = cart.lineItems[indexPath.row]
        let itemQuantity = item.inventoryQuantity?.getValidQuantity() ?? 1
        
        switch operation {
            
        case .increment:
            if cell.itemQuantity < itemQuantity {
                cell.itemQuantity += 1
                totalPrice += Double(item.price) ?? 0.0
            }
        case .decrement:
            if cell.itemQuantity > 1 {
                cell.itemQuantity -= 1
                totalPrice -= Double(item.price) ?? 0.0
            }
            
        }
        
        cartViewModel.cart?.lineItems[indexPath.row].quantity = cell.itemQuantity
        cell.quantityLabel.text = String(cell.itemQuantity)
        cell.updateButtonState(maxQuantity: itemQuantity)
        updateTotalPrice()
        
    }
    
}
