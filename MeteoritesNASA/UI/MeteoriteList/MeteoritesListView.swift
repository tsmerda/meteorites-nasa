//
//  MeteoritesListView.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 24.11.2023.
//

import SwiftUI

struct MeteoritesListView: View {
    @StateObject private var viewModel: MeteoritesListViewModel
    @EnvironmentObject var nav: NavigationStateManager
    private let progressHudBinding: ProgressHudBinding
    
    init(viewModel: MeteoritesListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.progressHudBinding = ProgressHudBinding(state: viewModel.$progressHudState)
    }
    
    var body: some View {
        NavigationStack(path: $nav.path) {
            VStack {
                list
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    refreshButton
                }
            }
            .navigationTitle(!viewModel.showNearest ? L.MeteoriteList.allMeteorites : L.MeteoriteList.nearestMeteorites)
            .padding()
            .navigationDestination(for: Meteorite.self) { meteorite in
                meteoriteDetailView(meteorite)
            }
            .navigationDestination(for: [Meteorite].self) { meteorites in
                nearestMeteoritesDetailView(meteorites)
            }
        }
        .searchable(text: $viewModel.searchText, isPresented: $viewModel.searchIsActive)
    }
}

private extension MeteoritesListView {
    var refreshButton: some View {
        Button(action: { viewModel.refreshData() }) {
            Icons.refresh
                .foregroundColor(Color.accentColor)
        }
    }
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
    var showNearestButton: PrimaryButton? {
        if !viewModel.meteoritesList.isEmpty {
            let config = PrimaryButtonConfig(
                icon: Icons.mapPin,
                title: L.MeteoriteList.showNearestMeteorites,
                action: {
                    viewModel.findNearestMeteorites()
                    nav.goToNearestMeteoritesDetail(viewModel.nearestMeteorites)
                }
            )
            PrimaryButton(config: config)
        }
    }
    var list: some View {
        ScrollView {
            showNearestButton
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
            .padding(.vertical, Padding.standard)
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
