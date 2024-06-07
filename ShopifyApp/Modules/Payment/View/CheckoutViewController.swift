//
//  CheckoutViewController.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 01/06/2024.
//

import UIKit
import Combine

class CheckoutViewController: UIViewController {
    
    var checkoutViewModel: CheckoutViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shippingView: UIView!
    @IBOutlet weak var shippingCountryLabel: UILabel!
    @IBOutlet weak var shippingAddressLabel: UILabel!
    @IBOutlet weak var applyPromoBtn: UIButton!
    @IBOutlet weak var promoTextField: UITextField!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartTableViewCell.nib(), forCellReuseIdentifier: CartTableViewCell.identifier)
        
        initUI()
    }
    
    func initUI() {
        shippingView.layer.borderWidth = 1
        shippingView.layer.borderColor = UIColor.lightGray.cgColor
        shippingView.layer.cornerRadius = 8
        
        enableApplyWhenPromoIsAvailable()
        
        let order = checkoutViewModel.draftOrder
        
        setPriceSetction(order)
        
        let shippingAddress = order.shippingAddress
        setShippingAddress(
            city: shippingAddress.city,
            country: shippingAddress.country,
            address: shippingAddress.address1
        )
    }
    
    func enableApplyWhenPromoIsAvailable() {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: promoTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .map { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: applyPromoBtn)
            .store(in: &cancellables)
    }
    
    @IBAction func applyPromoBtnTapped(_ sender: UIButton) {
        
        
        
    }
    
    @IBAction func payButton(_ sender: UIButton) {
        let destinationVC = PaymentOptionsViewController()
        destinationVC.modalPresentationStyle = .pageSheet
        destinationVC.sheetPresentationController?.detents = [.medium()]
        destinationVC.sheetPresentationController?.prefersGrabberVisible = true
        present(destinationVC, animated: true)
    }
    
    func setShippingAddress(city: String, country: String, address: String) {
        shippingCountryLabel.text = "\(city), \(country)"
        shippingAddressLabel.text = address
    }
    
    func setPriceSetction(_ order: DraftOrder) {
        subtotalLabel.text = order.subtotalPrice
        totalLabel.text = order.totalPrice
        if let discount = order.appliedDiscount {
            let type = (discount.valueType == "fixed_amount") ? order.currency : "%"
            discountLabel.text = "\(discount.amount)\(type)"
        }
    }
    
    
}

extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checkoutViewModel.draftOrder.lineItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier, for: indexPath) as! CartTableViewCell
        
        cell.quantityBtns[0].isHidden = true
        cell.quantityBtns[1].isHidden = true
        cell.configure(lineItem: checkoutViewModel.draftOrder.lineItems[indexPath.row])
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeAddressSegue" {

            let destVC = segue.destination as? AddressesViewController
            destVC?.onAddressChanged = {
                guard let defaultAddress = destVC?.addressesViewModel.defaultAddress else { return }
                self.setShippingAddress(city: defaultAddress.city, country: defaultAddress.country, address: defaultAddress.address1)
            }
        }
        
    }
    
}
