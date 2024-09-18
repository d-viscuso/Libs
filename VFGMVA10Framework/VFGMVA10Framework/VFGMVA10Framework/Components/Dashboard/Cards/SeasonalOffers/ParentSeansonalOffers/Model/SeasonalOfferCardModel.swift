//
//  SeasonalOffersCardModel.swift
//  VFGMVA10Framework
//
//  Created by Tuncel, Pelin, Vodafone on 6/16/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation


/// SeasonalOffersCardModel: model used to configure the VFGSeasonalOffersCardView
public struct SeasonalOffersCardModel: Codable {
    /// the primary title of the card
    public var primaryTitle: String

    /// The image url that will be shown on the card.
    public var backgroundImageURL: String

    /// the secondary title, shown under the main title
    public var secondaryTitle: String

    /// an optional logo image url (shown only if the card type is withLogo)
    public var logoImageURL: String

    /// a title shown when the card is in the active state
    public var activeTitle: String

    /// a title shown when the card is not activated
    public var intermediateTitle: String

    /// waiting time before the activation of the offer
    public var waitOfferTime: Int

    /// the CTA button shown while the card is in the active state
    public var activeButtonTitle: String

    /// date from which the offer will become active
    public var offerDate: String?

    /// card type, can be active, inactive, intermediate
    public var type: VFGSeasonalOfferMode

    /// SeasonalOffersCardModel constructor
    /// - Parameters:
    ///   - primaryTitle: the primary title of the card
    ///   - backgroundImageURL: The image url that will be shown on the card.
    ///   - secondaryTitle: the secondary title, shown under the main title
    ///   - logoImageURL: an optional logo image url (shown only if the card type is withLogo)
    ///   - activeTitle: a title shown when the card is in the active state
    ///   - intermediateTitle: a title shown when the card is not activated
    ///   - waitOfferTime: waiting time before the activation of the offer
    ///   - activeButtonTitle: the CTA button shown while the card is in the active state
    ///   - offerDate: date from which the offer will become active
    ///   - type: card type, can be active, inactive, intermediate
    public init (
        primaryTitle: String,
        backgroundImageURL: String,
        secondaryTitle: String,
        logoImageURL: String,
        activeTitle: String,
        intermediateTitle: String,
        waitOfferTime: Int,
        activeButtonTitle: String,
        offerDate: String?,
        type: VFGSeasonalOfferMode
    ) {
        self.primaryTitle = primaryTitle
        self.backgroundImageURL = backgroundImageURL
        self.secondaryTitle = secondaryTitle
        self.logoImageURL = logoImageURL
        self.activeTitle = activeTitle
        self.intermediateTitle = intermediateTitle
        self.waitOfferTime = waitOfferTime
        self.activeButtonTitle = activeButtonTitle
        self.offerDate = offerDate
        self.type = type
    }
}
