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
            .navigationTitle(!viewModel.showNearest ? L.MeteoriteList.allMeteorites : L.MeteoriteList.nearestMeteorites)
            .padding()
            .navigationDestination(for: Meteorite.self) { meteorite in
                meteoriteDetailView(meteorite)
            }
            .navigationDestination(for: [Meteorite].self) { meteorites in
                nearestMeteoritesDetailView(meteorites)
            }
            .onAppear {
                LocationManager.shared.requestLocationPermission()
            }
        }
        .environmentObject(nav)
    }
}

private extension MeteoritesListView {
    func meteoriteDetailView(_ meteorite: Meteorite) -> MeteoriteDetailView {
        MeteoriteDetailView(
            viewModel: MeteoriteDetailViewModel(
                meteorite: meteorite
            )
        )
    }
    func nearestMeteoritesDetailView(_ meteorites: [Meteorite]) -> NearestMeteoritesDetailView {
        NearestMeteoritesDetailView(
            viewModel: NearestMeteoritesDetailViewModel(
                meteorites: meteorites
            )
        )
    }
    @ViewBuilder
    var showNearestButton: PrimaryButton? {
        PrimaryButton(
            icon: "mappin.and.ellipse",
            title: L.MeteoriteList.showNearestMeteorites,
            action: {
                viewModel.findNearestMeteorites()
                nav.goToNearestMeteoritesDetail(viewModel.nearestMeteorites)
            }
        )
    }
    var list: some View {
        ScrollView {
            showNearestButton
            LazyVStack(spacing: Spacing.standard) {
                ForEach(viewModel.meteoritesList, id: \.id) { meteorite in
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
        viewModel: MeteoritesListViewModel()
    )
}
