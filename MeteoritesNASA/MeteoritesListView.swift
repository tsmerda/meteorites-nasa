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
    }
}

private extension MeteoritesListView {
    var list: some View {
        ScrollView {
            LazyVStack(spacing: Spacing.standard) {
                ForEach(viewModel.meteoritesList) { meteorite in
                    Text(meteorite.name)
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
