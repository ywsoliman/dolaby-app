//
//  AddAddressViewModel.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 04/06/2024.
//

import Foundation
import CoreLocation

class AddAddressViewModel: NSObject, CLLocationManagerDelegate {
    
    private var service: NetworkService
    private var addressesViewModel: AddressesViewModel
    private var locationManager: CLLocationManager?
    private var showNoLocationAlert: Bool = false {
        didSet {
            if showNoLocationAlert {
                bindAlertToViewController()
            }
        }
    }
    var placemark: CLPlacemark? {
        didSet {
            bindLocationToViewController()
        }
    }
    
    var bindAlertToViewController: (() -> ()) = {}
    var bindLocationToViewController: (() -> ()) = {}
    var bindAddressToViewController: (() -> ()) = {}
    var bindInvalidCountryToViewController: (() -> ()) = {}
    var bindAddressExistsToViewController: (() -> ()) = {}
    
    init(service: NetworkService, addressesViewModel: AddressesViewModel) {
        self.service = service
        self.addressesViewModel = addressesViewModel
    }
    
    func addAddress(_ newAddress: AddedAddress, completion: @escaping () -> ()) {
        
        guard let user = CurrentUser.user,
              var addresses = user.addresses else { return }
        
        if addressExists(newAddress, in: addresses) {
            bindAddressExistsToViewController()
            completion()
            return
        }
        
        let addressParams: [String: Any] = createAddressParams(newAddress)
        
        service.makeRequest(endPoint: "/customers/\(user.id)/addresses.json", method: .post, parameters: addressParams) { (result: Result<CustomerAddress, APIError>) in
            
            switch result {
            case .success(let response):
                addresses.append(response.customerAddress)
                CurrentUser.user?.addresses = addresses
                CurrentUser.user?.addresses?.append(response.customerAddress)
                self.handleSuccessfulAddingAddress(address: response.customerAddress, completion: completion)
            case .failure(let error):
                self.bindInvalidCountryToViewController()
                completion()
                print("Adding an address error: \(error)")
            }
            
        }
        
    }
    
    private func addressExists(_ newAddress: AddedAddress, in addresses: [Address]) -> Bool {
        return addresses.contains { address in
            address.address1 == newAddress.address1 &&
            address.city == newAddress.city &&
            address.country == newAddress.country
        }
    }
    
    private func createAddressParams(_ newAddress: AddedAddress) -> [String: Any] {
        return ["address": [
            "address1": newAddress.address1,
            "city": newAddress.city,
            "country": newAddress.country
        ]]
    }
    
    private func handleSuccessfulAddingAddress(address: Address, completion: @escaping () -> ()) {
        if CurrentUser.user?.addresses?.count == 1 {
                addressesViewModel.setDefault(addressID: address.id!) {
                    self.bindAddressToViewController()
                    completion()
                }
            } else {
                self.bindAddressToViewController()
                completion()
            }
    }
    
    func getLocation() {
        locationManager = CLLocationManager()
        locationManager!.delegate = self
    }
    
    private func checkLocationAuthorization() {
        
        guard let locationManager else { return }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("restricted")
        case .denied:
            showNoLocationAlert = true
        case .authorizedAlways, .authorizedWhenInUse:
            showNoLocationAlert = false
            if let location = locationManager.location {
                
                CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                    
                    guard let placemarks else { return }
                    
                    if placemarks.count > 0 {
                        self.placemark = placemarks[0]
                    }
                    
                }
            }
        @unknown default:
            break
        }
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    
}
