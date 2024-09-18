//
//  VFGPageBannerModel.swift
//  VFGMVA10Foundation
//
//  Created by Hamsa Hassan on 9/1/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
/// A model that can be injected to VFGPageBanner to setup it's views.
public struct VFGPageBannerModel {
    var header: String
    var headerTextColor: UIColor
    var description: String
    var descriptionTextColor: UIColor
    var image: UIImage?
    var primaryButton: String
    var primaryButtonBackgroundColor: UIColor?
    var primaryButtonBorderColor: UIColor?
    var primaryButtonTitleColor: UIColor?
    var secondaryButton: String?
    var secondaryButtonBackgroundColor: UIColor?
    var secondaryButtonBorderColor: UIColor?
    var secondaryButtonTitleColor: UIColor?
    var backgroundColors: [CGColor]
    var buttonType: ButtonType

    /// Page banner button type
    public enum ButtonType {
        /// no view appear on the top of page banner.
        case none
        /// switch will appear on the top of page banner.
        case toggle(isOn: Bool)
        /// close button will appear on the top of page banner.
        case close
    }
    /// - Parameters:
    ///   - header: The title that appears on the top of page banner.
    ///   - headerTextColor: The text color for title.
    ///   - description: the description for page banner.
    ///   - descriptionTextColor: The text color for description.
    ///   - image: The image that appear on the top left of page banner.
    ///   - primaryButton: The text for primary button.
    ///   - primaryButtonBackgroundColor: The background color for primary button.
    ///   - primaryButtonBorderColor: The border color for primary button.
    ///   - primaryButtonTitleColor: The text color for primary button.
    ///   - secondaryButton: The text for secondary button.
    ///   - secondaryButtonBackgroundColor: The background color for secondary button.
    ///   - secondaryButtonBorderColor: The border color for secondary button.
    ///   - secondaryButtonTitleColor: The text color for secondary button.
    ///   - backgroundColors: The colors for making gradient background color.
    ///   - buttonType: The type for the button appear on the top of page banner, can be switch , close button or without any button .

    public init(
        header: String,
        headerTextColor: UIColor = .VFGWhiteText,
        description: String,
        descriptionTextColor: UIColor = .VFGWhiteText,
        image: UIImage? = nil,
        primaryButton: String,
        primaryButtonBackgroundColor: UIColor? = nil,
        primaryButtonBorderColor: UIColor? = nil,
        primaryButtonTitleColor: UIColor? = nil,
        secondaryButton: String? = nil,
        secondaryButtonBackgroundColor: UIColor? = nil,
        secondaryButtonBorderColor: UIColor? = nil,
        secondaryButtonTitleColor: UIColor? = nil,
        backgroundColors: [CGColor] = UIColor.VFGDiscoverRedGradient,
        buttonType: ButtonType = .none
    ) {
        self.header = header
        self.headerTextColor = headerTextColor
        self.description = description
        self.descriptionTextColor = descriptionTextColor
        self.image = image
        self.primaryButton = primaryButton
        self.primaryButtonBackgroundColor = primaryButtonBackgroundColor
        self.primaryButtonBorderColor = primaryButtonBorderColor
        self.primaryButtonTitleColor = primaryButtonTitleColor
        self.secondaryButton = secondaryButton
        self.secondaryButtonBackgroundColor = secondaryButtonBackgroundColor
        self.secondaryButtonBorderColor = secondaryButtonBorderColor
        self.secondaryButtonTitleColor = secondaryButtonTitleColor
        self.backgroundColors = backgroundColors
        self.buttonType = buttonType
    }
}
