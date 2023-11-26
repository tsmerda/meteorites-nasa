//
//  MeteoriteDetailViewModel.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 25.11.2023.
//

import Foundation

final class MeteoriteDetailViewModel: ObservableObject {
    let meteorite: Meteorite
    @Published private(set) var progressHudState: ProgressHudState = .shouldHideProgress
    
    init(meteorite: Meteorite) {
        self.meteorite = meteorite
    }
}
