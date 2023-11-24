//
//  MeteoritesNASAApp.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 24.11.2023.
//

import SwiftUI

@main
struct MeteoritesNASAApp: App {
    private var viewModel = MeteoritesListViewModel()
    
    var body: some Scene {
        WindowGroup {
            MeteoritesListView(viewModel: viewModel)
        }
    }
}
