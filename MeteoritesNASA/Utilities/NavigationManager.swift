//
//  NavigationManager.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 25.11.2023.
//

import SwiftUI

class NavigationStateManager: ObservableObject {
    @Published var path = NavigationPath()
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func goBack() {
        path.removeLast()
    }
    
    func goToMeteoriteDetail(_ meteorite: Meteorite) {
        path.append(meteorite)
    }
    
    func errorGoToView(_ view: String) {
        debugPrint("Error go to view: \(view)")
    }
}
