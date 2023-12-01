//
//  MeteoritesListView.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 24.11.2023.
//

import SwiftUI

struct MeteoritesListView: View {
    @StateObject private var viewModel: MeteoritesListViewModel
    @StateObject var nav = NavigationStateManager()
    
    @State private var showLocationPermissionAlert = false
    
    private let progressHudBinding: ProgressHudBinding
    
    init(viewModel: MeteoritesListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.progressHudBinding = ProgressHudBinding(
            state: viewModel.$progressHudState
        )
    }
    
    var body: some View {
        NavigationStack(path: $nav.path) {
            VStack {
                list
            }
            .edgesIgnoringSafeArea(.bottom)
            .alert(isPresented: $showLocationPermissionAlert) {
                Alert(
                    title: Text(L.Map.requestPermissionAlertTitle),
                    message: Text(L.Map.requestPermissionAlertMessage),
                    dismissButton: .default(Text(L.Map.alertDismiss))
                )
            }
            .navigationTitle(L.MeteoriteList.allMeteorites)
            .navigationDestination(for: Meteorite.self) { meteorite in
                meteoriteDetailView(meteorite)
            }
            .navigationDestination(for: [Meteorite].self) { meteorites in
                nearestMeteoritesDetailView(meteorites)
            }
        }
        .dynamicTypeSize(.medium ... .xxxLarge)
        .environmentObject(nav)
        .searchable(text: $viewModel.searchText, isPresented: $viewModel.searchIsActive)
    }
}

private extension MeteoritesListView {
    func meteoriteDetailView(_ meteorite: Meteorite) -> MeteoriteDetailView {
        MeteoriteDetailView(
            viewModel: MeteoriteDetailViewModel(
                meteorite: meteorite,
                locationManager: viewModel.locationManager
            )
        )
    }
    func nearestMeteoritesDetailView(_ meteorites: [Meteorite]) -> NearestMeteoritesDetailView {
        NearestMeteoritesDetailView(
            viewModel: NearestMeteoritesDetailViewModel(
                meteorites: meteorites,
                locationManager: viewModel.locationManager
            )
        )
    }
    @ViewBuilder
    var showNearestButton: some View {
        if !viewModel.meteoritesList.isEmpty {
            let config = PrimaryButtonConfig(
                icon: Icons.mapPin,
                title: L.MeteoriteList.showNearestMeteorites,
                action: {
                    viewModel.findNearestMeteorites { result in
                        switch result {
                        case .success(let nearestMeteorites):
                            nav.goToNearestMeteoritesDetail(nearestMeteorites)
                        case .failure(let error):
                            switch error {
                            case .permissionNotDetermined:
                                break
                            case .permissionDenied, .locationUnavailable:
                                showLocationPermissionAlert = true
                            }
                        }
                    }
                }
            )
            PrimaryButton(config: config)
                .padding(.horizontal)
        }
    }
    var list: some View {
        ScrollView {
            showNearestButton
            if viewModel.searchResults.isEmpty && viewModel.searchIsActive {
                Text(L.MeteoriteList.noSearchResults)
                    .font(Fonts.body1)
                    .foregroundColor(Colors.textLight)
                    .padding()
            } else {
                LazyVStack(spacing: Spacing.standard) {
                    ForEach(viewModel.searchResults, id: \.id) { meteorite in
                        Button(action: {
                            nav.goToMeteoriteDetail(meteorite)
                        }) {
                            MeteoriteRowView(
                                recclass: meteorite.recclass,
                                name: meteorite.name,
                                year: meteorite.year,
                                mass: viewModel.formattedMass(meteorite.mass)
                            )
                        }
                    }
                }
                .padding()
            }
        }
        .refreshable {
            viewModel.refreshData()
        }
    }
}

#Preview {
    MeteoritesListView(
        viewModel: MeteoritesListViewModel(
            networkManager: MockNetworkManager(),
            locationManager: MockLocationManager()
        )
    )
}
