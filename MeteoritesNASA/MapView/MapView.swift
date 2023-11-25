//
//  MapView.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 25.11.2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel: MapViewModel
    
    init(viewModel: MapViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Map {
            Annotation(
                "Meteorite",
                coordinate: CLLocationCoordinate2D(
                    latitude: viewModel.geolocation.coordinates[1],
                    longitude: viewModel.geolocation.coordinates[0]
                )
            ) {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.teal)
                    Text("O")
                        .padding(5)
                }
            }
        }
        .mapControlVisibility(.hidden)
    }
}

#Preview {
    MapView(
        viewModel: MapViewModel(geolocation: Geolocation.example)
    )
}
