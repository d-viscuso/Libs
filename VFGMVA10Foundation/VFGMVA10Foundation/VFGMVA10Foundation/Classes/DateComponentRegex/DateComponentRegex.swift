//
//  DateComponentRegex.swift
//  VFGMVA10Foundation
//
//  Created by SAMEH on 11/03/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

enum DateComponentRegex {
    case day(searchingRegex: String = "#Today[+-][0-9]+#", replacingRegex: String = "(#Today)|(#)")
    case month(searchingRegex: String = "#Month[+-][0-9]+#", replacingRegex: String = "(#Month)|(#)")
    case interval(searchingRegex: String = "#Date[+-][0-9]+#", replacingRegex: String = "(#Date)|(#)")

    var searchingRegex: String {
        switch self {
        case let .day(searchingRegex, _):
            return searchingRegex
        case let .month(searchingRegex, _):
            return searchingRegex
        case let .interval(searchingRegex, _):
            return searchingRegex
        }
    }

    var replacingRegex: String {
        switch self {
        case let .day(_, replacingRegex):
            return replacingRegex
        case let .month(_, replacingRegex):
            return replacingRegex
        case let .interval(_, replacingRegex):
            return replacingRegex
        }
    }
}
