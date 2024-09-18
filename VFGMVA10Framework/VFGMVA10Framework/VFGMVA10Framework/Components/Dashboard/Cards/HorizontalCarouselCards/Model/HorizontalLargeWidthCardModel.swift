//
//  HorizontalLargeWidthCardModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 19/12/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// An enum which holds the size type of the horizontal carousel layout.
public enum HorizontalCarouselLayout: String, Codable {
    case large
    case small
}

/// A struct which represents the model for horizontal card item.
public struct HorizontalLargeWidthCardModel: Codable {
    public var bgImage: String?
    public var logo: String?
    public var title: String?
    public var subtitle: String?
    public var bottomText: String?
    public var serviceIcon: String?
    public var points: VFGPointsBadgeModel?
    public var link: BannerCardModel.Link?
    public var actionId: String?
    public var showGradientOverlay: Bool?
    public var gradientDirection: GradientDirection?
    public var titleColor: String?
    public var subtitleColor: String?
    public var bottomTextColor: String?

    public init(
        bgImage: String? = nil,
        logo: String? = nil,
        title: String? = nil,
        subtitle: String? = nil,
        bottomText: String? = nil,
        serviceIcon: String? = nil,
        points: VFGPointsBadgeModel? = nil,
        link: BannerCardModel.Link? = nil,
        actionId: String? = nil,
        showGradientOverlay: Bool? = nil,
        gradientDirection: GradientDirection? = nil,
        titleColor: String? = nil,
        subtitleColor: String? = nil,
        bottomTextColor: String? = nil
    ) {
        self.bgImage = bgImage
        self.logo = logo
        self.title = title
        self.subtitle = subtitle
        self.bottomText = bottomText
        self.serviceIcon = serviceIcon
        self.points = points
        self.link = link
        self.actionId = actionId
        self.showGradientOverlay = showGradientOverlay
        self.titleColor = titleColor
        self.subtitleColor = subtitleColor
        self.bottomTextColor = bottomTextColor
    }
}
