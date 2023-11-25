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
    
    func formattedMass(_ mass: String?) -> String? {
        guard let massStr = mass, let massValue = Double(massStr) else {
            return nil
        }
        if massValue >= 1000 {
            let kgValue = massValue / 1000.0
            if floor(kgValue) == kgValue {
                return "\(Int(kgValue)) kg"
            } else {
                return String(format: "%.2f kg", kgValue)
            }
        } else {
            return "\(Int(massValue)) g"
        }
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
