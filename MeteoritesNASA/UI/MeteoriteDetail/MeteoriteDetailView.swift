//
//  MeteoriteDetailView.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 25.11.2023.
//

import SwiftUI
import MapKit

struct MeteoriteDetailView: View {
    @StateObject private var viewModel: MeteoriteDetailViewModel
    @EnvironmentObject var nav: NavigationStateManager
    @State private var showMeteoriteDetail: Bool = true
    
    init(viewModel: MeteoriteDetailViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            mapView
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $showMeteoriteDetail) {
            meteoriteInfoModalView
        }
    }
}

private extension MeteoriteDetailView {
    @ViewBuilder
    var mapView: some View {
        if let geolocation = viewModel.meteorite.geolocation {
            let mapViewModel = MapViewModel(
                title: viewModel.meteorite.name,
                geolocation: geolocation,
                goBackAction: { nav.goBack() },
                onSelectMeteoriteAction: nil,
                locationManager: viewModel.locationManager
            )
            MapView(viewModel: mapViewModel)
        }
    }
    var meteoriteInfoModalView: some View {
        MeteoriteInfoModalView(
            viewModel: MeteoriteInfoModalViewModel(
                meteorite: viewModel.meteorite,
                onNavigateAction: nil,
                onCancelNavigationAction: nil,
                locationManager: viewModel.locationManager
            )
        )
        .presentationDetents([.height(250)])
        .presentationBackgroundInteraction(.enabled(upThrough: .height(250)))
        .interactiveDismissDisabled()
        .presentationDragIndicator(.hidden)
    }
}

#Preview {
    MeteoriteDetailView(
        viewModel: MeteoriteDetailViewModel(
            meteorite: Meteorite.example,
            locationManager: MockLocationManager()
        )
    )
}
