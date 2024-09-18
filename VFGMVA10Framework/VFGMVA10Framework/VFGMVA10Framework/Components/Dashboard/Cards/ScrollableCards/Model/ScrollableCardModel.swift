//
//  ScrollableCardModel.swift
//  VFGMVA10Framework
//
//  Created by Giovanni Romaniello on 11/07/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

public enum ScrollableCardLayout: String, Codable {
    case large
    case small
    case medium
}

public struct ScrollableCardModel: Codable {
    public var title: String?
    public var cards: [ScrollableCardItemModel]?
    public var layout: ScrollableCardLayout?

    public init() { }

    public init(title: String?, cards: [ScrollableCardItemModel]?, layout: ScrollableCardLayout?) {
        self.title = title
        self.cards = cards
        self.layout = layout
    }
}

public struct ScrollableCardItemModel: Codable {
    public var title: String?
    public var subtitle: String?
    public var bottomText: String?
    public var bgImage: String?
    public var imageModel: BannerImageModel?
    public var logo: String?
    public var serviceIcon: String?
    public var actionId: String
    public var bannerType: String
    public var presentationType: String
    public var showGradientOverlay: Bool?
    public var point: VFGPointsBadgeModel?
    public var link: BannerCardModel.Link?

    public init(
    title: String? = nil,
    subtitle: String? = nil,
    bottomText: String? = nil,
    bgImage: String? = nil,
    imageModel: BannerImageModel? = nil,
    logo: String? = nil,
    serviceIcon: String? = nil,
    actionId: String,
    bannerType: String,
    presentationType: String,
    showGradientOverlay: Bool? = nil,
    point: VFGPointsBadgeModel? = nil,
    link: BannerCardModel.Link? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.bottomText = bottomText
        self.bgImage = bgImage
        self.imageModel = imageModel
        self.logo = logo
        self.serviceIcon = serviceIcon
        self.actionId = actionId
        self.bannerType = bannerType
        self.presentationType = presentationType
        self.showGradientOverlay = showGradientOverlay
        self.point = point
        self.link = link
    }
}
