//
//  ProgressHUDHelper.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 24.11.2023.
//

import Foundation
import Combine
import ProgressHUD

enum ProgressHudHelper {
    static func dismiss(deadline: Double = 0.35) {
        DispatchQueue.main.asyncAfter(deadline: .now() + deadline) {
            ProgressHUD.dismiss()
        }
    }
}

enum ProgressHudState: Equatable {
    case showProgress
    case showSuccess(message: String? = nil)
    case showFailure(message: String? = nil)
    case hide
}

final class ProgressHudBinding {
    private var subscriptions: Set<AnyCancellable> = []
    
    init(state: Published<ProgressHudState>.Publisher) {
        state
            .receive(on: DispatchQueue.main)
            .sink { state in
                switch state {
                case .showProgress: ProgressHUD.show(interaction: false)
                case .showSuccess(let message): ProgressHUD.showSucceed(message)
                case .showFailure(let message): ProgressHUD.showFailed(message)
                case .hide: ProgressHudHelper.dismiss()
                }
            }
            .store(in: &subscriptions)
    }
}
