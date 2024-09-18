//
//  File.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 1/6/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

public extension String {
    var currencySymbol: String? {
        switch self {
        case "GBP":
            return "€"
        default:
            return nil
        }
    }

    var ordinalNumber: String? {
        guard let number = Int(self) else {
            return nil
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal

        return formatter.string(from: NSNumber(value: number))
    }

    func toDate(format: String? = nil) -> String? {
        if let formatValue = format {
            guard let date = VFGDateHelper.getDateFromString(dateString: self, format: formatValue) else {
                return nil
            }
            return VFGDateHelper.getStringFromDate(date: date, dateFormat: formatValue)
        } else {
            guard let date = VFGDateHelper.getDateFromString(dateString: self) else {
                return nil
            }
            return VFGDateHelper.getStringFromDate(date: date, dateFormat: "dd'/'MM'/'yyyy")
        }
    }
}
