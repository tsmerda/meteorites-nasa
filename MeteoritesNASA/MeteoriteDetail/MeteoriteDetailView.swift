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
    private let progressHudBinding: ProgressHudBinding
    
    init(viewModel: MeteoriteDetailViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.progressHudBinding = ProgressHudBinding(state: viewModel.$progressHudState)
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
                goBackAction: { nav.goBack() }
            )
                MapView(viewModel: mapViewModel)
        }
    }
    var meteoriteInfoModalView: some View {
        MeteoriteInfoModalView(
            viewModel: MeteoriteInfoModalViewModel(
                meteorite: viewModel.meteorite
            )
        )
        .presentationDetents([.height(230), .medium])
        .presentationBackgroundInteraction(.enabled(upThrough: .medium))
        .interactiveDismissDisabled()
        .presentationDragIndicator(.automatic)
    }
}

#Preview {
    MeteoriteDetailView(
        viewModel: MeteoriteDetailViewModel(
            meteorite: Meteorite.example
        )
    )
}
