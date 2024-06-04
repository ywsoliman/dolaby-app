//
//  AddressesTableViewController.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 03/06/2024.
//

import UIKit

class AddressesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var addressesViewModel: AddressesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AddressTableViewCell.nib(), forCellReuseIdentifier: AddressTableViewCell.identifier)
        
        addressesViewModel = AddressesViewModel(service: NetworkService.shared)
        addressesViewModel.bindAddressesToViewController = { [weak self] in
            self?.tableView.reloadData()
        }
        
    }
    
    @IBAction func addAnAddressBtn(_ sender: UIButton) {
        
        if let addAddressVC = UIStoryboard(name: "SettingsStoryboar", bundle: nil).instantiateViewController(withIdentifier: "AddAddressTableViewController") as? AddAddressTableViewController {
            addAddressVC.onAddressAdded = { [weak self] in
                self?.addressesViewModel.getAddresses()
            }
            navigationController?.pushViewController(addAddressVC, animated: true)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let address = addressesViewModel.addresses?.addresses[indexPath.row] else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AddressTableViewCell.identifier, for: indexPath) as! AddressTableViewCell
        
        cell.configure(address: address)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let addresses = addressesViewModel.addresses else { return }
        guard let id = addresses.addresses[indexPath.row].id else { return }
        
        addressesViewModel.setDefault(addressID: id)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            deleteAddressAlert(indexPath, tableView)
        }
        
    }
    
    func deleteAddressAlert(_ indexPath: IndexPath, _ tableView: UITableView) {
        
        guard let addresses = addressesViewModel.addresses else { return }
        
        let alert = UIAlertController(title: "Delete Confirmation", message: "Are you sure you want to delete this?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {_ in
            
            self.addressesViewModel.delete(address: addresses.addresses[indexPath.row]) {
                self.addressesViewModel.getAddresses()
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}
