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
    
    func addAddress(_ newAddress: AddedAddress) {
        
        guard let user = CurrentUser.user,
              let addresses = user.addresses else { return }
        
        for address in addresses {
            if address.address1 == newAddress.address1 &&
                address.city == newAddress.city &&
                address.country == newAddress.country {
                bindAddressExistsToViewController()
            }
        }
        
        let addressParams: [String: Any] = ["address": [
            "address1": newAddress.address1,
            "city": newAddress.city,
            "country": newAddress.country
        ]]
        
        service.makeRequest(endPoint: "/customers/\(user.id)/addresses.json", method: .post, parameters: addressParams) { (result: Result<CustomerAddress, APIError>) in
            
            switch result {
            case .success(let response):
                CurrentUser.user?.addresses?.append(response.customerAddress)
                if CurrentUser.user?.addresses?.count == 1 {
                    self.addressesViewModel.setDefault(addressID: response.customerAddress.id!) {
                        self.bindAddressToViewController()
                    }
                } else {
                    self.bindAddressToViewController()
                }
            case .failure(let error):
                self.bindInvalidCountryToViewController()
                print("Adding an address error: \(error)")
            }
            
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
