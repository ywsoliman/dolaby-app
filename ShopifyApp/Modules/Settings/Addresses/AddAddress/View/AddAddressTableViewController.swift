//
//  AddAddressTableViewController.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 04/06/2024.
//

import UIKit
import Combine

class AddAddressTableViewController: UITableViewController {
    
    private var addAddressViewModel: AddAddressViewModel!
    var onAddressAdded: (() -> ()) = {}

    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add an Address"
        
        observeTextFieldsToEnableSaveBtn()
        
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
            self?.setAddressDataFromLocation()
        }
        addAddressViewModel.bindInvalidCountryToViewController = { [weak self] in
            self?.showInvalidCountryAlert()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3 { return 0 }
        return 20
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }

    @IBAction func getLocationBtn(_ sender: UIBarButtonItem) {
        
        addAddressViewModel.getLocation()
        
    }
    
    @IBAction func addAddressBtn(_ sender: UIButton) {
        
        let address = AddedAddress(address1: addressTextField.text!, city: cityTextField.text!, country: countryTextField.text!)
        
        addAddressViewModel.addAddress(address)
        
    }
    
    private func showNoLocationAlert() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services in Settings.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            self.openAppSettings()
        }
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    private func showInvalidCountryAlert() {
        let alert = UIAlertController(title: "Invalid Country", message: "Please enter a valid country", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    private func setAddressDataFromLocation() {
        guard let placemark = addAddressViewModel.placemark else { return }
        addressTextField.text = placemark.name ?? ""
        cityTextField.text = placemark.locality ?? ""
        countryTextField.text = placemark.country ?? ""
    }
    
    private func observeTextFieldsToEnableSaveBtn() {
        
        saveBtn.isEnabled = false
        
        let addressPublisher = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: addressTextField)
            .map { ($0.object as? UITextField)?.text ?? "" }
        
        let cityPublisher = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: cityTextField)
            .map { ($0.object as? UITextField)?.text ?? "" }
        
        let countryPublisher = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: countryTextField)
            .map { ($0.object as? UITextField)?.text ?? "" }
        
        Publishers.CombineLatest3(addressPublisher, cityPublisher, countryPublisher)
            .map { address, city, country in
                !address.isEmpty && !city.isEmpty && !country.isEmpty
            }
            .receive(on: DispatchQueue.main)
            .sink { isValid in
                print(isValid)
                self.saveBtn.isEnabled = isValid
            }
            .store(in: &cancellables)
            
        
    }
    
}
