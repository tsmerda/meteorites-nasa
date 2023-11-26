//
//  NearestMeteoritesDetailViewModel.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 26.11.2023.
//

import Foundation

final class NearestMeteoritesDetailViewModel: ObservableObject {
    let meteorites: [Meteorite]
    @Published private(set) var progressHudState: ProgressHudState = .shouldHideProgress
    @Published var selectedMeteorite: Meteorite?
    
    init(meteorites: [Meteorite]) {
        self.meteorites = meteorites
        self.selectedMeteorite = nil
    }
}
