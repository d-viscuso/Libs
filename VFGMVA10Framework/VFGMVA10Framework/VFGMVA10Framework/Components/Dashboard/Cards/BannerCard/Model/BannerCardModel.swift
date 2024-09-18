//
//  BannerCardModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 24/07/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

/// an image source type for the banner card
public enum BannerImageSource: String, Codable {
    /// local named resource
    case namedImage
    /// url for a remote image resource
    case networkImage
    /// url for a remote gif resource
    case networkGif
}

/// struct for define an image source
public struct BannerImageModel: Codable {
    /// image source type
    public var type: BannerImageSource
    /// image source value
    public var value: String

    public init(type: BannerImageSource, value: String) {
        self.type = type
        self.value = value
    }
}

/// A struct which represents the model for banner card view.
public struct BannerCardModel: Codable {
    public var bgImage: String?
    public var imageModel: BannerImageModel?
    public var logo: String?
    public var serviceIcon: String?
    public var actionId: String?
    public var points: VFGPointsBadgeModel?
    public var link: Link?
    public var showGradientOverlay: Bool?
    public var gradientDirection: GradientDirection?

    public init (
        bgImage: String? = nil,
        imageModel: BannerImageModel? = nil,
        logo: String? = nil,
        serviceIcon: String? = nil,
        actionId: String? = nil,
        points: VFGPointsBadgeModel? = nil,
        link: Link? = nil,
        showGradientOverlay: Bool? = false,
        gradientDirection: GradientDirection? = nil
    ) {
        self.bgImage = bgImage
        self.imageModel = imageModel
        self.logo = logo
        self.serviceIcon = serviceIcon
        self.actionId = actionId
        self.points = points
        self.link = link
        self.showGradientOverlay = showGradientOverlay
        self.gradientDirection = gradientDirection
    }

    /// A struct which represents the model for action element.
    public struct Link: Codable {
        public var actionTitle: String
        public var actionIcon: String
        public var actionTitleColor: String?

        public init(
            actionTitle: String,
            actionIcon: String,
            actionTitleColor: String? = nil
        ) {
            self.actionTitle = actionTitle
            self.actionIcon = actionIcon
            self.actionTitleColor = actionTitleColor
        }
    }
}
