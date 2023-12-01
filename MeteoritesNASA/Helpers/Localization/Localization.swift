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
        static let showNearestMeteorites = "meteorite_list_show_nearest_meteorites".tr
        static let noSearchResults = "meteorite_list_no_search_results".tr
    }
    
    enum NearestMeteoritesDetail {
        static let nearestMeteorites = "nearest_meteorites_detail_nearest_meteorites".tr
        static let infoLabel = "nearest_meteorites_detail_info_label".tr
    }
    
    enum Map {
        static let alertTitle = "map_alert_title".tr
        static let alertText = "map_alert_text".tr
        static let alertDismiss = "map_alert_dismiss".tr
        static let travelTime = "map_travel_time".tr
        static let meteorite = "map_meteorite".tr
        static let requestPermissionAlertTitle = "map_request_permission_alert_title".tr
        static let requestPermissionAlertMessage = "map_request_permission_alert_message".tr
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
        static let cancelNavigation = "meteorite_info_modal_cancel_navigation".tr
        static let kilograms = "meteorite_info_modal_kilograms".tr
        static let grams = "meteorite_info_modal_grams".tr
        static let kilometers = "meteorite_info_modal_kilometers".tr
        static let openInMaps = "meteorite_info_modal_open_in_maps".tr
    }
    
    enum Error {
        static let invalidUrl = "error_invalid_url".tr
        static let serverError = "error_server_error".tr
        static let invalidData = "error_invalid_data".tr
    }
}
