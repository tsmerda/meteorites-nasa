//
//  NearestMeteoritesDetailViewModel.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 26.11.2023.
//

import Foundation
import MapKit

final class NearestMeteoritesDetailViewModel: ObservableObject {
    let meteorites: [Meteorite]
    let locationManager: LocationManager
    
    @Published private(set) var progressHudState: ProgressHudState = .shouldHideProgress
    @Published var selectedMeteorite: Meteorite?
    @Published var route: MKRoute?
    @Published var travelTime: String?
    
    init(
        meteorites: [Meteorite],
        locationManager: LocationManager
    ) {
        self.meteorites = meteorites
        self.locationManager = locationManager
        self.selectedMeteorite = nil
        self.route = nil
        self.travelTime = nil
    }
}
extension NearestMeteoritesDetailViewModel {
    func fetchRoute() {
        progressHudState = .shouldShowProgress
        var source = CLLocationCoordinate2D()
        var destination = CLLocationCoordinate2D()
        if let latitudeString = selectedMeteorite?.geolocation?.latitude,
           let longitudeString = selectedMeteorite?.geolocation?.longitude,
           let latitude = Double(latitudeString),
           let longitude = Double(longitudeString) {
            destination = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        if let userCoordinates = locationManager.userLocation {
            source = CLLocationCoordinate2D(latitude: userCoordinates.latitude, longitude: userCoordinates.longitude)
        }
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .automobile
        
        Task {
            let result = try? await MKDirections(request: request).calculate()
            route = result?.routes.first
            getTravelTime()
            progressHudState = .shouldHideProgress
        }
    }
    
    func getTravelTime() {
        guard let route else { return }
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        travelTime = formatter.string(from: route.expectedTravelTime)
    }
    
    func cancelRoute() {
        travelTime = nil
        route = nil
    }
}
