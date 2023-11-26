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
            .navigationTitle("Meteorites")
            .padding()
            .navigationDestination(for: Meteorite.self) { meteorite in
                MeteoriteDetailView(
                    viewModel: MeteoriteDetailViewModel(
                        meteorite: meteorite
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
    var list: some View {
        ScrollView {
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
        }
    }
}

#Preview {
    MeteoritesListView(
        viewModel: MeteoritesListViewModel(
            
        )
    )
}
