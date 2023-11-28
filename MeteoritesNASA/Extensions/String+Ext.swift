//
//  String+Ext.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 24.11.2023.
//

import Foundation

extension String {
    func toFormattedDate(
        inputFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSS",
        outputFormat: String = "d. MMM yyyy",
        locale: String = Locale.current.identifier
    ) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: locale)
        dateFormatter.dateFormat = inputFormat
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }
        dateFormatter.dateFormat = outputFormat
        return dateFormatter.string(from: date)
    }
}
