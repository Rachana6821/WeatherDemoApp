//
//  LocationManager.swift
//  WeatherApplication
//
//  Created by Rachana  on 26/05/23.
//

import Foundation
import SwiftUI
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager() /// Location manager instance
    private let geocoder = CLGeocoder() /// Geocoder to convert long, lat to city
    @State var city = String() /// City property to store and pass to the view
    var locationUpdateReceived: ((String) -> Void)? /// Closure property to notify location update
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    //MARK: - Sends alert to the user
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    //MARK: - Handle location error here
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
     
        print("Location Manager Error: \(error.localizedDescription)")
    }
    
    //MARK: - Checks user permissions
    func checkLocationAuthorization() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .restricted, .denied:
            let alert = UIAlertController(title: "Allow Location Access", message: "Weather needs access to your location. Turn on Location Services in your device settings.", preferredStyle: UIAlertController.Style.alert)
            
            // Button to Open Settings
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    if let BUNDLE_IDENTIFIER = Bundle.main.bundleIdentifier,
                        let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(BUNDLE_IDENTIFIER)") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            SceneDelegate.shared?.window?.rootViewController?.present(alert, animated: true, completion: nil)
            return false
            case .authorizedAlways, .authorizedWhenInUse:
            return true
            default:
            return true
        }
        
    }
    
    //MARK: - Delegate method called when location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let placemark = placemarks?.first {
                    if let city = placemark.locality {
                        print("City Name: \(city)")
                        self.city = city
                        self.locationUpdateReceived?(city) /// Notify location update
                    }
                }
            }
        }
    }
    
    
    func getCoordinates(for cityName: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 37.0902, longitude: -95.7129), radius: 100, identifier: "USA")
        
        geocoder.geocodeAddressString(cityName, in: region, preferredLocale: nil, completionHandler: { (placemarks, error) in
            if let error = error {
                // Handle error
                print("Geocoding error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let country = placemarks?.first?.country, country == "United States" {
                if let placemark = placemarks?.first {
                    let coordinates = placemark.location?.coordinate
                    completion(coordinates)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
            
        })
    }
}



