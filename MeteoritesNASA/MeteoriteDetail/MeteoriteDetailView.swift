//
//  MeteoriteDetailView.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 25.11.2023.
//

import SwiftUI

struct MeteoriteDetailView: View {
    @StateObject private var viewModel: MeteoriteDetailViewModel
    private let progressHudBinding: ProgressHudBinding
    
    init(viewModel: MeteoriteDetailViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.progressHudBinding = ProgressHudBinding(state: viewModel.$progressHudState)
    }
    
    var body: some View {
        Text("DetailView")
    }
}

#Preview {
    MeteoriteDetailView(
        viewModel: MeteoriteDetailViewModel(
            meteorite: Meteorite.example
        )
    )
}
