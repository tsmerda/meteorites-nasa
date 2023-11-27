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
            .navigationTitle(!viewModel.showNearest ? "Všechny meteority" : "Nejbližší meteority")
            .padding()
            .navigationDestination(for: Meteorite.self) { meteorite in
                MeteoriteDetailView(
                    viewModel: MeteoriteDetailViewModel(
                        meteorite: meteorite
                    )
                )
            }
            .navigationDestination(for: [Meteorite].self) { meteorites in
                NearestMeteoritesDetailView(
                    viewModel: NearestMeteoritesDetailViewModel(
                        meteorites: meteorites
                    )
                )
            }
            .onAppear {
                LocationManager.shared.requestLocationPermission()
            }
        }
        .environmentObject(nav)
    }
}

private extension MeteoritesListView {
    @ViewBuilder
    var showNearestButton: PrimaryButton? {
        if viewModel.nearestMeteorites != [] || viewModel.meteoritesList != [] {
            PrimaryButton(
                icon: "mappin.and.ellipse",
                title: "Show nearest meteorites",
                action: {
                    viewModel.findNearestMeteorites()
                    nav.goToNearestMeteoritesDetail(viewModel.nearestMeteorites)
                }
            )
        }
    }
    var list: some View {
        ScrollView {
            showNearestButton
            LazyVStack(spacing: Spacing.standard) {
                ForEach(viewModel.showNearest ? viewModel.nearestMeteorites : viewModel.meteoritesList, id: \.id) { meteorite in
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
