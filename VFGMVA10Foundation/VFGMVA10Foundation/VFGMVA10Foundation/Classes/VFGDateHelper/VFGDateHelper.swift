//
//  VFGDateHelper.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 10/11/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// `VFGDateHelper` is a helper enum to provide wide varity of functionality to dates.
public enum VFGDateHelper {
    public static var locale: Locale?
    /// Use this function to format two dates in a single string.
    /// - Parameters:
    ///   - startDate: The start/first date.
    ///   - endDate: The end/second date.
    ///   - dateFormatString:The format of the given dates, the default format is '*yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ*'
    ///   - format: The format of the returning date, the default format is '*dd MMM*'
    /// - Returns: A *String* of start and end date in the given format (eg: 06 Aug - 01 Sep)
    public static func getDateIntervalFromISO8601Date(
        startDate: String,
        endDate: String,
        dateFormatString: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
        format: String = "dd MMM"
    ) -> String {
        guard let start = changeDateStringFormat(
            dateString: startDate,
            format: format,
            dateFormatString: dateFormatString) else { return "" }
        guard let end = changeDateStringFormat(
            dateString: endDate,
            format: format,
            dateFormatString: dateFormatString) else { return "- \(start)" }
        return "\(start) - \(end)"
    }

    /// Extracts the day component from a given date string and returns it's numerical value in string format.
    /// - Parameters:
    ///   - dateString: The date given to return the month component of it.
    ///   - dateFormatString:The format of the given date, the default format is '*yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ*'.
    /// - Returns: A *String* of the day's numerical value  (eg: 08, 09 .. etc)
    public static func getDayFromISO8601Date(
        dateString: String,
        dateFormatString: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    ) -> String {
        guard let date = changeDateStringFormat(
            dateString: dateString,
            format: "dd",
            dateFormatString: dateFormatString) else { return "" }
        return date
    }

    /// Extracts the month component from a given date string and returns it's full name.
    /// - Parameters:
    ///   - dateString: The date given to return the month component of it.
    ///   - dateFormatString:The format of the given date, the default format is '*yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ*'.
    /// - Returns: A *String* of the month component in the full name (eg: August, September .. etc)
    public static func getMonthFromISO8601Date(
        dateString: String,
        dateFormatString: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    ) -> String {
        guard let date = changeDateStringFormat(
            dateString: dateString,
            format: "MMMM",
            dateFormatString: dateFormatString) else { return "" }
        return date
    }

    /// Extracts the month component from a given date string and returns it's short name.
    /// - Parameters:
    ///    - dateString: The date given to return the month component of it.
    ///    - dateFormatString:The format of the given date, the default format is '*yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ*'.
    /// - Returns: A *String* of the month component in the short name (eg: Aug, Sep .. etc)
    public static func getMonthShortNameFromISO8601Date(
        dateString: String,
        dateFormatString: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    ) -> String {
        guard let date = changeDateStringFormat(
            dateString: dateString,
            format: "MMM",
            dateFormatString: dateFormatString) else { return "" }
        return date
    }

    /// Extracts the month component from a given date and returns it's short name.
    /// - Parameters:
    ///   - date: The date given to return the month component of it.
    /// - Returns: A *String* of the month component in the short name (eg: Aug, Sep .. etc)
    public static func shortMonth(from date: Date = Date()) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = self.locale ?? Locale.current
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: date)
    }

    /// Extracts the month component from a given date string and returns it's numerical value in string format.
    /// - Parameters:
    ///   - dateString: The date given to return the month component of it.
    ///   - dateFormatString:The format of the given date, the default format is '*yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ*'.
    /// - Returns: A *String* of the month's numerical value  (eg: 08, 09 .. etc)
    public static func getMonthIdFromISO8601Date(
        dateString: String,
        dateFormatString: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    ) -> String {
        guard let date = changeDateStringFormat(
            dateString: dateString,
            format: "MM",
            dateFormatString: dateFormatString) else { return "0" }
        return date
    }

    /// Extracts the year component from a given date string and returns it's numerical value in string format.
    /// - Parameters:
    ///   - dateString: The date given to return the year component of it.
    ///   - dateFormatString:The format of the given date, the default format is '*yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ*'.
    /// - Returns: A *String* of the year's numerical value (eg: 08, 09 .. etc)
    public static func getYearFromISO8601Date(
        dateString: String,
        dateFormatString: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    ) -> String {
        guard let date = changeDateStringFormat(
            dateString: dateString,
            format: "yyyy",
            dateFormatString: dateFormatString) else { return "" }
        return date
    }

    /// Extracts the day component from a given date string and returns it's suffix in string format.
    /// - Parameters:
    ///   - dateString: The date given to return the day component of it.
    ///   - dateFormatString:The format of the given date, the default format is '*yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ*'.
    /// - Returns: A *String* of the day's suffix (eg: 2nd, 3rd .. etc)
    public static func getDayWithSuffixFromISO8601Date(
        dateString: String,
        dateFormatString: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatString
        dateFormatter.locale = self.locale ?? Locale.current
        guard let date = dateFormatter.date(from: dateString) else {
            return ""
        }
        return daySuffix(date: date)
    }

    /// Use this function to format the given date into 'dd MM YY' format.
    /// - Parameters:
    ///   - paymentDate: The date given to be formatted.
    ///   - dateFormatString:The format of the given date.
    ///   - localizedKey: Localization key.
    ///   - bundle: The bundle in which the localization key is used.
    /// - Returns: A *String* of the given date in 'dd MM YY' format (eg: "03/02/22").
    public static func getFormattedDate(
        paymentDate: String,
        dateFormatString: String,
        localizedKey: String,
        bundle: Bundle
    ) -> String {
        let day = VFGDateHelper.getDayFromISO8601Date(
            dateString: paymentDate,
            dateFormatString: dateFormatString)
        let month = VFGDateHelper.getMonthIdFromISO8601Date(
            dateString: paymentDate,
            dateFormatString: dateFormatString)
        let year = VFGDateHelper.getYearFromISO8601Date(
            dateString: paymentDate,
            dateFormatString: dateFormatString)
        let twoDigitYear = (Int(year) ?? 0) % 100
        let localized = localizedKey.localized(bundle: bundle)

        return String(format: localized, "\(day)" + "/" + "\(month)" + "/" + "\(twoDigitYear)")
    }

    /// Extracts the day component from a given date and returns it's suffix in string format.
    /// - Parameters:
    ///   - date: The date given to return the day component of it.
    /// - Returns: A *String* of the day's suffix (eg: 2nd, 3rd .. etc)
    public static func daySuffix(date: Date) -> String {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.day, from: date)
        let dayOfMonth = components.day
        return daySuffix(day: dayOfMonth ?? 0)
    }

    /// Extracts the day suffix from a given integer.
    /// - Parameters:
    ///   - day: The day given to return it's suffix.
    /// - Returns: A *String* of the day's suffix (eg: 2nd, 3rd .. etc)
    public static func daySuffix(day: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(from: NSNumber(value: day)) ?? ""
    }

    /// Changes given date format into a given format.
    /// - Parameters:
    ///   - dateString: The date given to be formatted.
    ///   - format: The wanted format.
    ///   - dateFormatString: The format of the given date, the default format is '*yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ*'.
    ///   - local: Use this parameter to provide extra Information about linguistic, cultural, and technological conventions. It is nil by default.
    /// - Returns: A *String* of the given date formatted into the provided format.
    public static func changeDateStringFormat(
        dateString: String,
        format: String,
        dateFormatString: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
        locale: Locale? = nil
    ) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = self.locale ?? locale ?? Locale.current
        dateFormatter.dateFormat = dateFormatString
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = format
            return dateFormatter.string(from: date)
        }
        return nil
    }

    /// Converts the given date into string.
    /// - Parameters:
    ///   - date: The date given to be converted.
    ///   - format: The wanted format, it is nil by default.
    ///   - dateFormatString: The format of the given date, the default format is '*yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ*'.
    ///   - local: Use this parameter to provide extra Information about linguistic, cultural, and technological conventions. It is nil by default.
    /// - Returns: A string value of the given date.
    public static func getStringFromDate(
        date: Date,
        format: String? = nil,
        dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
        locale: Locale? = nil
    ) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = self.locale ?? locale ?? Locale.current
        if let format = format {
            formatter.dateFormat = format
        }
        return formatter.string(from: date)
    }

    /// Converts the given date string into date object.
    /// - Parameters:
    ///   - dateString: The date given to be converted.
    ///   - format: The wanted format of the return date object, the default format is '*yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ*'.
    ///   - local: Use this parameter to provide extra Information about linguistic, cultural, and technological conventions. It is nil by default.
    /// - Returns: A *Date?* value of the given date string.
    public static func getDateFromString(
        dateString: String,
        format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
        locale: Locale? = nil
    ) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = self.locale ?? locale ?? Locale.current
        return dateFormatter.date(from: dateString)
    }

    /// Returns a localized version of the short month name.
    /// - Parameters:
    ///   - dateString: The date given to be localized.
    ///   - shortMonthsDictionary: The dictionary of the short months names and their numerical values (eg: [01: Jan, 02: Feb, .. .])
    /// - Returns: A localized *String* value of the month of the given date string.
    public static func getShortMonthLocalized(
        _ dateString: String,
        shortMonthsDictionary: [String: String]
    ) -> String {
        let monthId = VFGDateHelper.getMonthIdFromISO8601Date(dateString: dateString)
        if let key = shortMonthsDictionary["\(monthId)"], let localizedKey = VFGDateHelper.localizedValue(for: key) {
            return localizedKey
        }
        return VFGDateHelper.getMonthShortNameFromISO8601Date(dateString: dateString)
    }

    /// Constructs a date object from the given parameters.
    /// - Parameters:
    ///   - year: The yaer component of the wanted date object.
    ///   - month: The month component of the wanted date object.
    ///   - day: The day component of the wanted date object.
    ///   - hour: The hour component of the wanted date object, it is 0 by default.
    ///   - min: The minute component of the wanted date object, it is 0 by default.
    ///   - sec: The second component of the wanted date object, it is 0 by default.
    /// - Returns: A *Date* object constructed from the given parameters.
    public static func date(
        from year: Int,
        month: Int,
        day: Int,
        hour: Int? = 0,
        min: Int? = 0,
        sec: Int? = 0
    ) -> Date {
        var calendar = Calendar.current
        guard let timeZone = TimeZone(secondsFromGMT: 0) else { return Date() }
        calendar.timeZone = timeZone
        let components = DateComponents(year: year, month: month, day: day, hour: hour, minute: min, second: sec)
        return calendar.date(from: components) ?? Date()
    }

    /// Increments 1 to  the given component of the given date and returns it as string
    /// - Parameters:
    ///   - dateString: The date given to be converted.
    ///   - component: The component given to be incremented, it is day by default.
    ///   - format: The wanted format of the return date String, the default format is '*yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ*'.
    ///   - local: Use this parameter to provide extra Information about linguistic, cultural, and technological conventions. It is nil by default.
    /// - Returns: A *String* value of the incremented date.
    public static func nextDateString(
        from dateString: String,
        component: Calendar.Component = .day,
        format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
        locale: Locale? = nil
    ) -> String {
        guard let dateString = VFGDateHelper.getDateFromString(
            dateString: dateString,
            format: format,
            locale: locale) else { return "" }
        let date = Calendar.current.date(byAdding: component, value: 1, to: dateString)
        return VFGDateHelper.getStringFromDate(
            date: date ?? Date(),
            dateFormat: format,
            locale: locale)
    }

    /// Decrements 1 of  the given component of the given date and returns it as string
    /// - Parameters:
    ///   - dateString: The date given to be converted.
    ///   - component: The component given to be decremented, it is day by default.
    ///   - format: The wanted format of the return date String, the default format is '*yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ*'.
    ///   - local: Use this parameter to provide extra Information about linguistic, cultural, and technological conventions. It is nil by default.
    /// - Returns: A *String* value of the decremented date.
    public static func previousDateString(
        from dateString: String,
        component: Calendar.Component = .day,
        format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
        locale: Locale? = nil
    ) -> String {
        guard let dateString = VFGDateHelper.getDateFromString(
            dateString: dateString,
            format: format,
            locale: locale) else { return "" }
        let date = Calendar.current.date(byAdding: component, value: -1, to: dateString)
        return VFGDateHelper.getStringFromDate(
            date: date ?? Date(),
            dateFormat: format,
            locale: locale)
    }

    /// Calculates number of days between two given dates.
    /// - Parameters:
    ///   - start: First Date.
    ///   - end: Second Date.
    /// - Returns: An *Int?* value of the difference between the two dates.
    public static func daysBetween(start: Date, end: Date) -> Int? {
        let calendar = Calendar.current
        let startDay = calendar.startOfDay(for: start)
        let endDay = calendar.startOfDay(for: end)
        return calendar.dateComponents([.day], from: startDay, to: endDay).value(for: .day)
    }

    /// Returns a localized version of the given key.
    /// - Parameters:
    ///   - key: The key given to be localized.
    /// - Returns: A *String?* of the localized key.
    static func localizedValue(for key: String) -> String? {
        if key.localized() != key {
            return key.localized()
        } else {
            return nil
        }
    }
}
