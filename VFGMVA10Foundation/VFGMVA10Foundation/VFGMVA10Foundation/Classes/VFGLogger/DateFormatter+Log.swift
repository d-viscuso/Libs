//
//  DateFormatter+Log.swift
//  VFGMVA10Foundation
//
//  Created by Esraa Eldaltony on 6/25/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

extension DateFormatter {
    internal static var logFileNameDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy.MM.dd-HH.mm.ss"
        return formatter
    }()

    internal static var logEntryDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        return formatter
    }()
}
