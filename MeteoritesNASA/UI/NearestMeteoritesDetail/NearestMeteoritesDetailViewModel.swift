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
    
    @Published private(set) var progressHudState: ProgressHudState = .hide
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

// MARK: - Handle navigation

extension NearestMeteoritesDetailViewModel {
    func fetchRoute() async {
        await MainActor.run {
            self.progressHudState = .showProgress
        }
        
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
        
        let routeResult = try? await MKDirections(request: request).calculate()
        let travelTimeResult = await getTravelTime(routeResult?.routes.first)
        
        await MainActor.run {
            route = routeResult?.routes.first
            travelTime = travelTimeResult
            self.progressHudState = .hide
        }
        
    }
    
    func getTravelTime(_ routeResult: MKRoute?) async -> String? {
        guard let routeResult else { return nil }
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string(from: routeResult.expectedTravelTime) ?? nil
    }
    
    func cancelRoute() {
        travelTime = nil
        route = nil
    }
}
