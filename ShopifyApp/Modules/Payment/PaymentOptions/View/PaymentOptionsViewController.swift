//
//  PaymentOptionsViewController.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 09/06/2024.
//

import UIKit
import Lottie

class PaymentOptionsViewController: UIViewController {
    
    private var paymentOptionsViewModel: PaymentOptionsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paymentOptionsViewModel = PaymentOptionsViewModel(service: NetworkService.shared)
        paymentOptionsViewModel.bindPaymentOptionsToViewController = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
    }
    
    @IBAction func cashOnDeliveryBtn(_ sender: UIButton) {
        confirmationAlert()
    }
    
    @IBAction func applePayBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func confirmationAlert() {
        
        let alert = UIAlertController(title: "Purchase Confirmation", message: "Are you sure you want to make this purchase?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            self.dismiss(animated: true)
            self.paymentOptionsViewModel.completeOrder()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        present(alert, animated: true)
        
    }
}
