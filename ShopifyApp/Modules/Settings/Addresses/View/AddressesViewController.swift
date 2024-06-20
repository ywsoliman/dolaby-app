//
//  AddressesTableViewController.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 03/06/2024.
//

import UIKit

class AddressesViewController: UIViewController {
    
    @IBOutlet weak var noAddressesView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var addressesViewModel: AddressesViewModel!
    var onAddressChanged: (() -> ()) = {}
    var onShippingAddressChanged: ((_: DraftOrderResponse) -> ()) = {_ in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AddressTableViewCell.nib(), forCellReuseIdentifier: AddressTableViewCell.identifier)
        
        addressesViewModel = AddressesViewModel(service: NetworkService.shared)
        addressesViewModel.bindAddressesToViewController = { [weak self] in
            let numberOfItems = self?.addressesViewModel.addresses?.addresses.count ?? 0
            self?.checkIfAddressesAreEmpty(numberOfItems)
            self?.tableView.reloadData()
            self?.onAddressChanged()
        }
        addressesViewModel.bindDefaultAddressToViewController = { [weak self] in
            self?.onAddressChanged()
        }
        addressesViewModel.bindCartWithNewShippingAddressToViewController = { [weak self] draftOrder in
            self?.onShippingAddressChanged(draftOrder)
        }
        
        LoadingIndicator.start(on: view)
        addressesViewModel.getAddresses()
        
    }
    
    func showAlertWithMessage(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addAddressSegue" {
            let destVC = segue.destination as? AddAddressTableViewController
            destVC?.onAddressAdded = { [weak self] in
                self?.addressesViewModel.getAddresses()
            }
        }
        
    }
    
}

extension AddressesViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressesViewModel.addresses?.addresses.count ?? 0
    }
    
    func checkIfAddressesAreEmpty(_ numberOfItems: Int) {
        LoadingIndicator.stop()
        if numberOfItems == 0 {
            noAddressesView.isHidden = false
        } else {
            noAddressesView.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let address = addressesViewModel.addresses?.addresses[indexPath.row] else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AddressTableViewCell.identifier, for: indexPath) as! AddressTableViewCell
        
        cell.configure(address: address)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let addresses = addressesViewModel.addresses else { return }
        guard let id = addresses.addresses[indexPath.row].id else { return }
        addressesViewModel.setDefault(addressID: id) { [weak self] in
            self?.changeCellsAccessory(tableView, indexPath)
        }
    }
    
    func changeCellsAccessory(_ tableView: UITableView, _ indexPath: IndexPath) {
        for cell in tableView.visibleCells {
            cell.accessoryType = .none
        }
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            deleteAddressAlert(indexPath, tableView)
        }
        
    }
    
    func deleteAddressAlert(_ indexPath: IndexPath, _ tableView: UITableView) {
        
        guard let addresses = addressesViewModel.addresses?.addresses else { return }
        
        let alert = UIAlertController(title: "Delete Confirmation", message: "Are you sure you want to delete this?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {_ in
            
            let address = addresses[indexPath.row]
            if address.addressDefault ?? false {
                if addresses.count > 1 {
                    self.showAlertWithMessage(message: "You can't delete a default address")
                } else {
                    self.showAlertWithMessage(message: "You must have at least one address")
                }
                return
            }
            
            self.addressesViewModel.delete(address: addresses[indexPath.row]) {
                self.addressesViewModel.getAddresses()
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}
