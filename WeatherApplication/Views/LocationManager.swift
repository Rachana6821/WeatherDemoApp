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
            return false
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
}



