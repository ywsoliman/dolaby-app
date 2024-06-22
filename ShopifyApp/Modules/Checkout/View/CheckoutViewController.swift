//
//  CheckoutViewController.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 01/06/2024.
//

import UIKit
import Combine
import PassKit

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
    
    private var priceBeforeDiscount: Double!
    private var appliedDiscount: Double?
    
    var onShippingAddressChanged: ((_: DraftOrderResponse) -> ()) = {_ in}
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartTableViewCell.nib(), forCellReuseIdentifier: CartTableViewCell.identifier)
        
        checkoutViewModel.bindDraftOrderToViewController = { [weak self] in
            self?.setOrderInfo()
        }
        
        initUI()
    }
    
    func initUI() {
        shippingView.layer.borderWidth = 1
        shippingView.layer.borderColor = UIColor.lightGray.cgColor
        shippingView.layer.cornerRadius = 8
        
        enableApplyWhenPromoIsAvailable()
        
        setOrderInfo()
    }
    
    @IBAction func cashOnDeliveryBtn(_ sender: UIButton) {
        let totalPrice = Double(checkoutViewModel.draftOrder.subtotalPrice)!
        totalPrice > CART_LIMIT_PRICE ? noCashOnDeliveryAvailableAlert() : confirmationAlert()
    }
    
    private func noCashOnDeliveryAvailableAlert() {
        let action = UIAlertAction(title: "Cancel", style: .cancel)
        alert(
            title: "Reached Price Limit",
            message: "Cash on delivery is ineligble on orders of total price higher than \(CART_LIMIT_PRICE.priceFormatter()). Please use Apple Pay instead.",
            viewController: self,
            actions: action
        )
    }
    
    @IBAction func applePayBtn(_ sender: UIButton) {
        if let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: createPaymentRequest()) {
            paymentVC.delegate = self
            present(paymentVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func applyPromoBtnTapped(_ sender: UIButton) {
        
        for discount in Discounts.discounts {
            if promoTextField.text! == discount.title {
                checkoutViewModel.addDiscountToDraftOrder(discount)
                return
            }
        }
        
        discountNotFoundAlert()
        
    }
    
    func confirmationAlert() {
        
        let alert = UIAlertController(title: "Purchase Confirmation", message: "Are you sure you want to make this purchase?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            self.checkoutViewModel.postOrder() { [weak self] in
                self?.navigateToHome()
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        present(alert, animated: true)
        
    }
    
    func createPaymentRequest() -> PKPaymentRequest {
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.welly.ShopifyApp"
        request.supportedNetworks = [.visa, .masterCard, .amex]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "US"
        request.currencyCode = CurrencyManager.currency
        request.paymentSummaryItems = createItemsSummary()
        
        return request
    }
    
    func createItemsSummary() -> [PKPaymentSummaryItem] {
        
        let draftOrder = checkoutViewModel.draftOrder
        var itemsSummary: [PKPaymentSummaryItem] = []
        
        for item in draftOrder.lineItems {
            let amountValue = (Double(item.price)! * Double(item.quantity) * CurrencyManager.value).roundedToTwoDecimals()
            itemsSummary.append(
                PKPaymentSummaryItem(
                    label: "\(item.title) x\(item.quantity)",
                    amount: NSDecimalNumber(string: String(amountValue))
                )
            )
            
        }
                
        itemsSummary.append(
            PKPaymentSummaryItem(
                label: "Total",
                amount: NSDecimalNumber(string: totalLabel.text)
            )
        )
        
        return itemsSummary
    }
    
    func discountNotFoundAlert() {
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert(title: "Invalid Coupon", message: "Please enter a valid discount.", viewController: self, actions: okAction)
    }
    
    func setOrderInfo() {
        let order = checkoutViewModel.draftOrder
        setPriceSetction(order)
        let shippingAddress = order.shippingAddress!
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
    
    func setShippingAddress(city: String, country: String, address: String) {
        shippingCountryLabel.text = "\(city), \(country)"
        shippingAddressLabel.text = address
    }
    
    func setPriceSetction(_ order: DraftOrder) {
        
        let subtotalPrice = (checkoutViewModel.priceBeforeDiscount ?? 0.0).currencyConverter()
        subtotalLabel.text = subtotalPrice.appendCurrency()
        
        if let discount = order.appliedDiscount {
            
            let type: String
            var totalPrice: Double
            let discountValue = Double(discount.value)!
            appliedDiscount = discountValue
            
            if discount.valueType == "fixed_amount" {
                
                type = CurrencyManager.currency
                totalPrice = subtotalPrice - discountValue
                if totalPrice < 0 { totalPrice = 0 }
                
            } else {
                
                type = "%"
                let percentage = discountValue / 100
                totalPrice = subtotalPrice - (subtotalPrice * percentage)
                
            }
            
            totalLabel.text = totalPrice.appendCurrency()
            discountLabel.text = "\(discountValue) \(type)"
            
        } else {
            totalLabel.text = subtotalLabel.text
        }
        
    }
    
    func navigateToHome() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeAddressSegue" {
            
            let destVC = segue.destination as? AddressesViewController
            destVC?.onShippingAddressChanged = { draftOrder in
                self.checkoutViewModel.draftOrder = draftOrder.draftOrder
                self.onShippingAddressChanged(draftOrder)
            }
        }
        
    }
    
    
}

extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checkoutViewModel.draftOrder.lineItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier, for: indexPath) as! CartTableViewCell
        
        cell.incrementBtn.isHidden = true
        cell.decrementBtn.isHidden = true
        cell.configure(lineItem: checkoutViewModel.draftOrder.lineItems[indexPath.row])
        
        return cell
        
    }
    
}

extension CheckoutViewController: PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        checkoutViewModel.postOrder()  { [weak self] in
            self?.navigateToHome()
        }
    }
    
    
}
