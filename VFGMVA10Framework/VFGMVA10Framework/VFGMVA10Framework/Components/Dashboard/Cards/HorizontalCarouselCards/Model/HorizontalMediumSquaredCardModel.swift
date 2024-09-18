//
//  HorizontalMediumSquaredCardModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 03/01/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// A struct which represents the model for horizontal card item.
public struct HorizontalMediumSquaredCardModel: Codable {
    public var bgImage: String?
    public var logo: String?
    public var title: String?
    public var subtitle: String?
    public var link: BannerCardModel.Link?
    public var actionId: String?
    public var showGradientOverlay: Bool?
    public var gradientDirection: GradientDirection?
    public var titleColor: String?
    public var subtitleColor: String?

    public init(
        bgImage: String? = nil,
        logo: String? = nil,
        title: String? = nil,
        subtitle: String? = nil,
        link: BannerCardModel.Link? = nil,
        actionId: String? = nil,
        showGradientOverlay: Bool? = nil,
        gradientDirection: GradientDirection? = nil,
        titleColor: String? = nil,
        subtitleColor: String? = nil
    ) {
        self.bgImage = bgImage
        self.logo = logo
        self.title = title
        self.subtitle = subtitle
        self.link = link
        self.actionId = actionId
        self.showGradientOverlay = showGradientOverlay
        self.gradientDirection = gradientDirection
        self.titleColor = titleColor
        self.subtitleColor = subtitleColor
    }
}
