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
    
    init(service: NetworkService) {
        self.service = service
    }
    
    func addAddress(_ address: AddedAddress) {
        
        let addressParams: [String: Any] = ["address": [
                "address1": address.address1,
                "city": address.city,
                "country": address.country
            ]]
        
        service.makeRequest(endPoint: "/customers/\(MY_CUSTOMER)/addresses.json", method: .post, parameters: addressParams) { (result: Result<CustomerAddress, APIError>) in
            
            switch result {
            case .success(_):
                self.bindAddressToViewController()
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
