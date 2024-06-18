//
//  CurriencesTableViewController.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 12/06/2024.
//

import UIKit

class CurrenciesTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    private let currenciesArray = CurrencyManager.currencies.map { $0.key }.sorted()
    private var filteredCurrencies: [String] = []
    var onCurrencyChanged: ((String) -> ()) = {_ in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredCurrencies = currenciesArray
        searchBar.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCurrencies.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath)
        
        let currency = filteredCurrencies[indexPath.row]
        cell.textLabel?.text = currency
        cell.accessoryType = (currency == CurrencyManager.currency) ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCurrency = filteredCurrencies[indexPath.row]
        CurrencyManager.currency = selectedCurrency
        CurrencyManager.value = CurrencyManager.currencies[selectedCurrency]!
        onCurrencyChanged(selectedCurrency)
        changeCellsAccessory(tableView, indexPath)
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

}

extension CurrenciesTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterCurrencies(searchText)
    }
    
    func filterCurrencies(_ searchText: String) {
        if searchText.isEmpty {
            filteredCurrencies = currenciesArray
        } else {
            filteredCurrencies = currenciesArray.filter { currency in
                return currency.lowercased().starts(with: searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
    
}
