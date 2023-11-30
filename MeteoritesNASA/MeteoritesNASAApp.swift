//
//  MeteoritesNASAApp.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 24.11.2023.
//

import SwiftUI

@main
struct MeteoritesNASAApp: App {
    @StateObject var nav = NavigationStateManager()
    
    var body: some Scene {
        WindowGroup {
            MeteoritesListView(
                viewModel: MeteoritesListViewModel(
                    networkManager: NetworkManager(),
                    locationManager: LocationManager()
                )
            )
            .environmentObject(nav)
        }
    }
}
