//
//  VFGBadgeModel.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 9/13/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

/// A model that contains the badge type, image, backgroundColor, text, textColor & font
public struct BadgeModel: Equatable {
    var type: BadgeType
    var image: UIImage?
    public var backgroundColor: UIColor?
    public var text: String?
    var textColor: UIColor?
    var font: UIFont?

    /// Empty initializer that creates an empty text
    /// background: VFGRedDefaultBackground
    /// textColor: VFGWhiteText
    /// font: vodafoneBold(12)
    public init() {
        type = .text
        text = ""
        self.backgroundColor = .VFGRedDefaultBackground
        textColor = .VFGWhiteText
        font = .vodafoneBold(12)
    }

    /// Initializer
    /// - Parameters:
    ///   - image: badge's image
    ///   - backgroundColor: badge background color, default is VFGRedDefaultBackground
    public init(image: UIImage, backgroundColor: UIColor = .VFGRedDefaultBackground) {
        type = .image
        self.backgroundColor = backgroundColor
        self.image = image
    }

    /// Initializer
    /// - Parameters:
    ///   - text: badge's text
    ///   - backgroundColor: badge background color, default is VFGRedDefaultBackground
    ///   - font: badge's font, default is vodafoneBold(12)

    public init(
        text: String,
        backgroundColor: UIColor = .VFGRedDefaultBackground,
        font: UIFont = .vodafoneBold(12)
    ) {
        type = .text
        self.text = text
        self.backgroundColor = backgroundColor
        textColor = .VFGWhiteText
        self.font = font
    }
}

/// Badge type whether is is text or image
public enum BadgeType {
    case text
    case image
}
