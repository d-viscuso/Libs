//
//  VFGDateHelperExtension.swift
//  VFGMVA10Foundation
//
//  Created by Hussein Kishk on 28/02/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

extension VFGDateHelper {
    /// Returns next month of the given date.
    /// - Parameters:
    ///   - dateString: The date given to return next month of it.
    ///   - dateFormatString:The format would be used to format the date, the default format is ///'*yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ*'
    ///   - locale: Use this parameter to provide extra Information about linguistic, cultural, and ///technological conventions. It is nil by default.
    /// - Returns: A *String* of the next month of the given date.
    public static func getNextMonthFromISO8601Date(
        dateString: String,
        dateFormatString: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
        locale: Locale? = nil
    ) -> String? {
        let dateFormatter = DateFormatter()
        if let locale = locale {
            dateFormatter.locale = locale
        }
        dateFormatter.dateFormat = dateFormatString
        var dateComponent = DateComponents()
        dateComponent.month = 1
        if
            let date = dateFormatter.date(from: dateString),
            let futureDate = Calendar.current.date(byAdding: dateComponent, to: date) {
            dateFormatter.dateFormat = "MMMM"
            return dateFormatter.string(from: futureDate)
        }
        return nil
    }

    /// Add date component to the given date.
    /// - Parameters:
    ///    - date: The date given to add component to it.
    ///    - value: The value of the component.
    ///    - component: The type  of component that would be added to the given date (eg: day).
    /// - Returns: An optional *Date* of the next month of the given date.
    static func addDateComponent(to date: Date, with value: Int, component: DateComponentRegex) -> Date? {
        var dateComponent = DateComponents()
        switch component {
        case .day:
            dateComponent.day = value
        case .month:
            dateComponent.month = value
        case .interval:
            dateComponent.second = value
        }
        let calender = Calendar.current
        return calender.date(byAdding: dateComponent, to: date)
    }
}
