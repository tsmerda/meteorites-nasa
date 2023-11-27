//
//  Localization.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 27.11.2023.
//

import Foundation

typealias L = LocalizedString

extension String {
    var tr: String { tr() }

    private func tr(_ stringValue: String) -> String {
        String(format: self.tr, stringValue)
    }

    func tr(_ stringValues: [String]) -> String {
        String(format: self.tr, arguments: stringValues)
    }

    func tr(withComment comment: String = "") -> String {
        NSLocalizedString(self, comment: comment)
    }
}

enum LocalizedString {
    enum Generic {
        static let unknown = "generic_unknown".tr
    }
    
    enum MeteoriteList {
        static let allMeteorites = "meteorite_list_all_meteorites".tr
        static let nearestMeteorites = "meteorite_list_nearest_meteorites".tr
        static let showNearestMeteorites = "meteorite_list_show_nearest_meteorites".tr
    }
    
    enum NearestMeteoritesDetail {
        static let nearestMeteorites = "nearest_meteorites_detail_nearest_meteorites".tr
    }
    
    enum Map {
        static let alertTitle = "map_alert_title".tr
        static let alertText = "map_alert_text".tr
        static let alertDismiss = "map_alert_dismiss".tr
    }
    
    enum MeteoriteInfoModal {
        static let recclass = "meteorite_info_modal_recclass".tr
        static let detailInfo = "meteorite_info_modal_detail_info".tr
        static let distance = "meteorite_info_modal_distance".tr
        static let mass = "meteorite_info_modal_mass".tr
        static let date = "meteorite_info_modal_date".tr
        static let coordinates = "meteorite_info_modal_coordinates".tr
        static let id = "meteorite_info_modal_id".tr
        static let navigateToMeteorite = "meteorite_info_modal_navigate_to_meteorite".tr
        static let kilograms = "meteorite_info_modal_kilograms".tr
        static let grams = "meteorite_info_modal_grams".tr
        static let kilometers = "meteorite_info_modal_kilometers".tr
    }
}
