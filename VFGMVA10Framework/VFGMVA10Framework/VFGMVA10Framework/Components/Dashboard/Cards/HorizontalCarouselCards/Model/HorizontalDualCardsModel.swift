//
//  HorizontalDualCardsModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 03/01/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// A struct which represents dual cards cell model.
public struct HorizontalDualCardsModel: Codable {
    public var topCard: HorizontalDualCardModel
    public var bottomCard: HorizontalDualCardModel

    /// Horizontal dual cards model constructor.
    /// - Parameters:
    ///   - topCard: Top card model.
    ///   - bottomCard: Bottom card model.
    public init(
        topCard: HorizontalDualCardModel,
        bottomCard: HorizontalDualCardModel
    ) {
        self.topCard = topCard
        self.bottomCard = bottomCard
    }
}

/// A struct which represents top or bottom card model through dual cards cell.
public struct HorizontalDualCardModel: Codable {
    public var bgImage: String?
    public var logo: String?
    public var title: String?
    public var subtitle: String?
    public var showGradientOverlay: Bool?
    public var gradientDirection: GradientDirection?
    public var titleColor: String?
    public var subtitleColor: String?
    public var actionId: String?

    public init(
        bgImage: String? = nil,
        logo: String? = nil,
        title: String? = nil,
        subtitle: String? = nil,
        link: BannerCardModel.Link? = nil,
        showGradientOverlay: Bool? = nil,
        gradientDirection: GradientDirection? = nil,
        titleColor: String? = nil,
        subtitleColor: String? = nil,
        actionId: String? = nil
    ) {
        self.bgImage = bgImage
        self.logo = logo
        self.title = title
        self.subtitle = subtitle
        self.showGradientOverlay = showGradientOverlay
        self.gradientDirection = gradientDirection
        self.titleColor = titleColor
        self.subtitleColor = subtitleColor
        self.actionId = actionId
    }
}
