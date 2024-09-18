//
//  VFGDay.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 13/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

/// A struct model which represents a specific day details.
public struct VFGDay {
    public let date: Date
    public let number: String
    public var isFirstSelected: Bool
    public var isLastSelected: Bool
    public var isWithinSelectedRange: Bool
    public let isWithinDisplayedMonth: Bool
    public let isWithinMinMax: Bool
    public let isHidden: Bool
    public let isToday: Bool
}
