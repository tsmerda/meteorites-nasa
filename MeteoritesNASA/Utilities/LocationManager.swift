//
//  LocationManager.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 26.11.2023.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    var status: CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }
    
    @Published var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location.coordinate
    }
}
