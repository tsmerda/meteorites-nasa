//
//  MeteoritesListView.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 24.11.2023.
//

import SwiftUI

struct MeteoritesListView: View {
    @StateObject private var viewModel: MeteoritesListViewModel
    private let progressHudBinding: ProgressHudBinding
    
    init(viewModel: MeteoritesListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.progressHudBinding = ProgressHudBinding(state: viewModel.$progressHudState)
    }

    var body: some View {
        VStack {
            list
        }
        .padding()
    }
}

private extension MeteoritesListView {
    var list: some View {
        ScrollView {
            LazyVStack(spacing: Spacing.standard) {
                ForEach(viewModel.meteoritesList) { meteorite in
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

#Preview {
    MeteoritesListView(
        viewModel: MeteoritesListViewModel(
            
        )
    )
}
