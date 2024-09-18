//
//  BannerCTACardModel.swift
//  VFGMVA10Framework
//
//  Created by Ihsan Kahramanoğlu on 12/27/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

/// BannerCTACardModel
public struct BannerCTACardModel: Codable {
    public var cards: [BannerCTACardItemModel]
    public var type: BannerCTACardType

    public init(cards: [BannerCTACardItemModel], type: BannerCTACardType) {
        self.cards = cards
        self.type = type
    }
}

/// A struct which represents CTA banner card model
public struct BannerCTACardItemModel: Codable {
    public var id: String?
    public var image: String?
    public var placeholderImage: String?
    public var points: VFGPointsBadgeModel?
    public var title: String?
    public var firstCTAButtonTitle: String?
    public var secondCTAButtonTitle: String?

    public init (
        id: String? = nil,
        image: String? = nil,
        placeholderImage: String? = nil,
        points: VFGPointsBadgeModel? = nil,
        title: String? = nil,
        firstCTAButtonTitle: String? = "",
        secondCTAButtonTitle: String? = ""
    ) {
        self.id = id
        self.image = image
        self.points = points
        self.placeholderImage = placeholderImage
        self.title = title
        self.firstCTAButtonTitle = firstCTAButtonTitle
        self.secondCTAButtonTitle = secondCTAButtonTitle
    }
}
