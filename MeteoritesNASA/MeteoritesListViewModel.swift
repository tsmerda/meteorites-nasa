//
//  MeteoritesListViewModel.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 24.11.2023.
//

import Foundation

final class MeteoritesListViewModel: ObservableObject {
    @Published var meteoritesList: [Meteorite] = []
    @Published private(set) var progressHudState: ProgressHudState = .shouldHideProgress
    
    init() {
        getAllMeteorites()
    }
}

// MARK: -- Network methods

private extension MeteoritesListViewModel {
    func getAllMeteorites() {
        Task { @MainActor in
            progressHudState = .shouldShowProgress
            do {
                meteoritesList = try await NetworkManager.shared.getAllMeteorites()
                progressHudState = .shouldHideProgress
            } catch {
                progressHudState = .shouldShowFail(message: error.localizedDescription)
            }
        }
    }
}
