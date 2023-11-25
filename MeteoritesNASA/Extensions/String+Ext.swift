//
//  String+Ext.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 24.11.2023.
//

import Foundation

extension String {
    func toFormattedDate(
        outputFormat: String = "d. MMM yyyy",
        localeIdentifier: String = "en_US"
    ) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: localeIdentifier)
        dateFormatter.dateFormat = outputFormat
        return dateFormatter.string(from: Date())
    }
}
