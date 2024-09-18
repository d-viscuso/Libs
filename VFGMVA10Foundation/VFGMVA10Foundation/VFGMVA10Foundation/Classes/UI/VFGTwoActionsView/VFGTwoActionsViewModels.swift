//
//  VFGTwoActionsViewModels.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 7/1/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
/// A model that can be injected to VFGTwoActionsView and VFGQuickActionsAlertView to setup their views.
public struct VFGTitlesModel {
    /// The normal title string that appears on the top of view
    public let title: String?
    /// The attributed title that appears on the top of view
    public let titleAttributedString: NSMutableAttributedString?
    /// The normal description of the view
    public let description: String?
    /// The attributed description of the view
    public let descriptionAttributedString: NSMutableAttributedString?
    /// The normal details text of the view
    public let moreDetails: String?
    /// The attributed details text of the view
    public let moreDetailsAttributedString: NSMutableAttributedString?
    /// The text for the primary button of the view
    public let primaryButtonTitle: String?
    /// The text for the secondary button of the view
    public let secondaryButtonTitle: String?

    /// - Parameters:
    ///   - title: The normal title string that appears on the top of view.
    ///   - titleAttributedString: The attributed  title  that appears on the top of view.
    ///   - description: The normal description  of the view.
    ///   - descriptionAttributedString: The attributed description of the view.
    ///   - moreDetails: The normal details text of the view.
    ///   - moreDetailsAttributedString: The attributed details text of the view.
    ///   - primaryButtonTitle: The  text for the  primary button of the view.
    ///   - secondaryButtonTitle: The  text for the  secondary button of the view.
    public init(
        title: String? = nil,
        titleAttributedString: NSMutableAttributedString? = nil,
        description: String? = nil,
        descriptionAttributedString: NSMutableAttributedString? = nil,
        moreDetails: String? = nil,
        moreDetailsAttributedString: NSMutableAttributedString? = nil,
        primaryButtonTitle: String? = nil,
        secondaryButtonTitle: String? = nil
    ) {
        self.title = title
        self.titleAttributedString = titleAttributedString
        self.description = description
        self.descriptionAttributedString = descriptionAttributedString
        self.moreDetails = moreDetails
        self.moreDetailsAttributedString = moreDetailsAttributedString
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
    }
}

/// A model that can be injected to VFGTwoActionsView and VFGQuickActionsAlertView to setup their fonts.
public struct VFGTitlesFontModel {
    /// The font for title that appears on the top of view
    public let titleFont: UIFont
    /// The font for description that appears on the top of view
    public let descriptionFont: UIFont
    /// The font for more details that appears on the top of view
    public let moreDetailsFont: UIFont

    /// - Parameters:
    ///   - titleFont: The font for title that appears on the top of view.
    ///   - descriptionFont: The font for description that appears on the top of view.
    ///   - moreDetailsFont: The font for moreDetails that appears on the top of view.
    public init(
        titleFont: UIFont = .vodafoneRegular(16),
        descriptionFont: UIFont = .vodafoneRegular(16),
        moreDetailsFont: UIFont = .vodafoneRegular(16)
    ) {
        self.titleFont = titleFont
        self.descriptionFont = descriptionFont
        self.moreDetailsFont = moreDetailsFont
    }
}

/// A model that can be injected to VFGTwoActionsView and VFGQuickActionsAlertView to setup their title alignment.
public struct VFGTitlesAlignmentModel {
    /// The alignment for title
    public let titleAlignment: NSTextAlignment
    /// The alignment for description
    public let descriptionAlignment: NSTextAlignment
    /// The alignment for more details
    public let moreDetailsAlignment: NSTextAlignment

    /// - Parameters:
    ///   - titleAlignment: The alignment for title .
    ///   - descriptionAlignment: The alignment for description .
    ///   - moreDetailsAlignment: The alignment for moreDetails .
    public init(
        titleAlignment: NSTextAlignment = .natural,
        descriptionAlignment: NSTextAlignment = .natural,
        moreDetailsAlignment: NSTextAlignment = .natural
    ) {
        self.titleAlignment = titleAlignment
        self.descriptionAlignment = descriptionAlignment
        self.moreDetailsAlignment = moreDetailsAlignment
    }
}

/// A model that can be injected to VFGTwoActionsView  to setup their title accessibility ids.
public struct VFGTwoActionsAccessibilityModel {
    /// The accessibility id for icon image
    public let icon: String
    /// The accessibility id for title label
    public let title: String
    /// The accessibility id for description label
    public let description: String
    /// The accessibility id for more details label
    public let moreDetails: String
    /// The accessibility id for primary button
    public let primaryButton: String
    /// The accessibility id for secondary button
    public let secondaryButton: String

    /// - Parameters:
    ///   - icon: The accessibility id for icon image .
    ///   - title: The accessibility id for title label .
    ///   - description: The accessibility id for description label .
    ///   - moreDetails: The accessibility id for more details label .
    ///   - primaryButton: The accessibility id for primary button .
    ///   - secondaryButton: The accessibility id for secondary button .
    public init(
        icon: String = "",
        title: String = "",
        description: String = "",
        moreDetails: String = "",
        primaryButton: String = "",
        secondaryButton: String = ""
    ) {
        self.icon = icon
        self.title = title
        self.description = description
        self.moreDetails = moreDetails
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }
}
