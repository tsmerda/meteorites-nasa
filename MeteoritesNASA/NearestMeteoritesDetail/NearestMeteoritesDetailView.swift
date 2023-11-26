//
//  NearestMeteoritesDetailView.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 26.11.2023.
//

import SwiftUI
import MapKit

struct NearestMeteoritesDetailView: View {
    @StateObject private var viewModel: NearestMeteoritesDetailViewModel
    @EnvironmentObject var nav: NavigationStateManager
    @State private var showMeteoriteDetail: Bool = false
    private let progressHudBinding: ProgressHudBinding
    
    init(viewModel: NearestMeteoritesDetailViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.progressHudBinding = ProgressHudBinding(state: viewModel.$progressHudState)
    }
    
    var body: some View {
        VStack {
            mapView
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $showMeteoriteDetail, onDismiss: {
            viewModel.selectedMeteorite = nil
        }) {
            meteoriteInfoModalView
        }
    }
}

private extension NearestMeteoritesDetailView {
    @ViewBuilder
    var mapView: some View {
            let mapViewModel = MapViewModel(
                title: "Nearest meteorites",
                nearestMeteorites: viewModel.meteorites,
                goBackAction: { nav.goBack() },
                onSelectMeteoriteAction: {
                    viewModel.selectedMeteorite = $0
                    showMeteoriteDetail = true
                }
            )
                MapView(viewModel: mapViewModel)
    }
    var meteoriteInfoModalView: some View {
        MeteoriteInfoModalView(
            viewModel: MeteoriteInfoModalViewModel(
                meteorite: viewModel.selectedMeteorite,
                withRouteButton: true
            )
        )
        .id(viewModel.selectedMeteorite?.id)
        .presentationDetents([.height(300), .medium])
        // TODO: -- remove this?
        .presentationBackgroundInteraction(.enabled(upThrough: .medium))
        .presentationDragIndicator(.automatic)
    }
}

#Preview {
    NearestMeteoritesDetailView(
        viewModel: NearestMeteoritesDetailViewModel(
            meteorites: Meteorite.exampleList
        )
    )
}
