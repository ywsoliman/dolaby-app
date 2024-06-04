//
//  PaymentOptionsViewController.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 01/06/2024.
//

import UIKit

class PaymentOptionsViewController: UIViewController {

    let CashOnDeliveryButton = UIButton()
    let ApplePayButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @objc func cashOnDeliveryTapped() {
        dismiss(animated: true)
    }
    
    @objc func applePayTapped() {
        dismiss(animated: true)
    }
    

    func setupUI() {
        view.addSubview(CashOnDeliveryButton)
        view.addSubview(ApplePayButton)
        view.backgroundColor = .systemBackground

        CashOnDeliveryButton.translatesAutoresizingMaskIntoConstraints = false
        ApplePayButton.translatesAutoresizingMaskIntoConstraints = false

        CashOnDeliveryButton.configuration = .tinted()
        CashOnDeliveryButton.configuration?.title = "Cash On Delivery"
        CashOnDeliveryButton.configuration?.image = UIImage(systemName: "backpack")
        CashOnDeliveryButton.configuration?.imagePadding = 8
        CashOnDeliveryButton.configuration?.baseForegroundColor = .black
        CashOnDeliveryButton.configuration?.baseBackgroundColor = .black
        CashOnDeliveryButton.addTarget(self, action: #selector(cashOnDeliveryTapped), for: .touchUpInside)

        ApplePayButton.configuration = .filled()
        ApplePayButton.configuration?.title = "Apple Pay"
        ApplePayButton.configuration?.image = UIImage(systemName: "applelogo")
        ApplePayButton.configuration?.imagePadding = 8
        ApplePayButton.configuration?.baseForegroundColor = .white
        ApplePayButton.configuration?.baseBackgroundColor = .black
        ApplePayButton.addTarget(self, action: #selector(applePayTapped), for: .touchUpInside)

        let padding: CGFloat = 20

        NSLayoutConstraint.activate([
            ApplePayButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ApplePayButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ApplePayButton.heightAnchor.constraint(equalToConstant: 50),
            ApplePayButton.widthAnchor.constraint(equalToConstant: 280),

            CashOnDeliveryButton.bottomAnchor.constraint(equalTo: ApplePayButton.topAnchor, constant: -padding),
            CashOnDeliveryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            CashOnDeliveryButton.heightAnchor.constraint(equalToConstant: 50),
            CashOnDeliveryButton.widthAnchor.constraint(equalToConstant: 280),
        ])
    }

}
