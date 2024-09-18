//
//  DateFormatter+Init.swift
//  VFGMVA10
//
//  Created by Sandra Morcos on 2/18/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

extension DateFormatter {
    convenience init(locale: Locale, dateFormat: String, timeZone: TimeZone?) {
        self.init()
        self.locale = locale
        self.dateFormat = dateFormat
        self.timeZone = timeZone
    }
}
