//
//  AddAddressTableViewController.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 04/06/2024.
//

import UIKit

class AddAddressTableViewController: UITableViewController {
    
    private var addAddressViewModel: AddAddressViewModel!
    var onAddressAdded: (() -> ()) = {}

    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add an Address"
        
        addAddressViewModel = AddAddressViewModel(service: NetworkService.shared)
        addAddressViewModel.bindAddressToViewController = { [weak self] in
            print("Address binding")
            self?.onAddressAdded()
            self?.navigationController?.popViewController(animated: true)
        }
        addAddressViewModel.bindAlertToViewController = { [weak self] in
            self?.showNoLocationAlert()
        }
        addAddressViewModel.bindLocationToViewController = { [weak self] in
            
            guard let placemark = self?.addAddressViewModel.placemark else { return }
            
            self?.addressTextField.text = placemark.name ?? ""
            self?.cityTextField.text = placemark.locality ?? ""
            self?.countryTextField.text = placemark.country ?? ""
            
        }
        
    }

    @IBAction func getLocationBtn(_ sender: UIBarButtonItem) {
        
        addAddressViewModel.getLocation()
        
    }
    
    @IBAction func addAddressBtn(_ sender: UIButton) {
        
        let address = AddedAddress(address1: addressTextField.text!, city: cityTextField.text!, country: countryTextField.text!)
        
        addAddressViewModel.addAddress(address)
        
    }
    
    func showNoLocationAlert() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services in Settings.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            self.openAppSettings()
        }
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
