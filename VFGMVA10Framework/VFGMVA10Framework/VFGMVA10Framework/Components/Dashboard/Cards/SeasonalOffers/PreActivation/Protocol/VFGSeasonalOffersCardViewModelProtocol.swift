//
//  VFGSeasonalOffersCardModelProtocol.swift
//  VFGMVA10Framework
//
//  Created by Tuncel, Pelin, Vodafone on 6/15/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

/// Enum for seasonal offers card types
public enum VFGSeasonalOffersCardType: String, Codable {
    /// withLogo: the card will show the icon logo
    case withLogo
    /// withoutLogo: the card will hide the icon logo
    case withoutLogo
}

/// Seasonal offers card view model protocol
public protocol VFGSeasonalOffersCardModelProtocol: AnyObject {
    /// Seasonal offer card view type
    var type: VFGSeasonalOffersCardType { get set }
}


/// Enum for Seasonal offer mode:
/// intermediate and inactive type enum values requires also an VFGSeasonalOffersCardType parameter that can be withLogo or withoutLogo
public enum VFGSeasonalOfferMode: Equatable, Codable {
    /// inactive: the offer has not been activated yet
    /// cardType: withLogo/withoutLogo
    case inactive(cardType: VFGSeasonalOffersCardType)
    /// active: the offer has been activated
    case active
    /// intermediate: the offer has been activated and the card shows the duration
    /// cardType: withLogo/withoutLogo
    case intermediate(cardType: VFGSeasonalOffersCardType)
}

extension VFGSeasonalOfferMode {
    var cardType: VFGSeasonalOffersCardType? {
        switch self {
        case .inactive(let cardType):
            return cardType
        case .intermediate(let cardType):
            return cardType
        default:
            return nil
        }
    }
}
