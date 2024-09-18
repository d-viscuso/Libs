//
//  UsageType.swift
//  VFGMVA10Group
//
//  Created by Sandra Morcos on 11/18/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
/// Dashboard usage card types
public enum UsageType: String {
    case data
    case money
    case voice
    case messages
    case roaming
    case unlimited

    // All following strings need to be replaced with localized values when made available
    /// Dashboard usage card title
    public var title: String {
        switch self {
        case .data:
            return "usage_card_data_title"
        case .money:
            return "usage_card_money_title"
        case .voice:
            return "usage_card_voice_title"
        case .messages:
            return "usage_card_messages_title"
        case .roaming:
            return "usage_card_roaming_title"
        case .unlimited:
            return "usage_card_unlimited_title"
        }
    }
    /// Dashboard usage card subtitle
    public var totalDescription: String {
        return "usage_card_out_of_total"
    }
    /// Dashboard usage card image
    public var imageName: String {
        switch self {
        case .data, .unlimited:
            return "dataSharing"
        case .money:
            return "money"
        case .voice:
            return "callLog"
        case .messages:
            return "sms"
        case .roaming:
            return "icMobile"
        }
    }
    /// Dashboard usage card remaining days value
    public var remainingDaysLabel: String {
        return ""
    }
}
