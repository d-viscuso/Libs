//
//  VFGCVMOverlayViewModel.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed Sultan on 8/27/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import Lottie
import UIKit

/// CVM overlay content position
public enum VFGCVMOverlayContentAlignment {
    case top(margin: CGFloat)
    case center(margin: CGFloat)
    case bottom(margin: CGFloat)
}

/// CVM overlay content position
public enum VFGCVMOverlayIconsAlignment {
    case left(margin: CGFloat = 16)
    case center(margin: CGFloat = 0)
}

/// CVM overlay icon type
public enum VFGCVMOverlayIcon {
    /// Default dimensions for overlay icons.
    public enum Size {
        public static let small = CGSize(side: 44)
        public static let medium = CGSize(side: 62)
        public static let large = CGSize(side: 120)
    }

    /// A static image
    case image(UIImage?)
    /// An animation view
    case animation(Animation?)
}

/// CVM overlay style
public enum VFGCVMOverlayStyle {
    /// Shows two stars images on the right & left
    case birthday
    /// Shows custom images for both right & left
    case custom(rightIcon: UIImage?, leftIcon: UIImage?)
    /// Shows custom icons for both right & left
    case customIcons(
        right: VFGCVMOverlayIcon? = nil,
        left: VFGCVMOverlayIcon? = nil,
        rightSize: CGSize = VFGCVMOverlayIcon.Size.medium,
        leftSize: CGSize = VFGCVMOverlayIcon.Size.small)
    case textOnly
}

/// CVM overlay appearance
public enum VFGCVMOverlayAppearance {
    /// Light appearance (light background with darker elements)
    case light
    /// Dark appearance (dark background with lighter elements)
    case dark
}

/// A model that can be injected to VFGCVMOverlayViewController
public struct VFGCVMOverlayViewModel {
    let title: String
    let content: String?
    let attributedContent: NSAttributedString?
    let primaryButtonTitle: String
    let secondaryButtonTitle: String?
    let mainIcon: VFGCVMOverlayIcon?
    let mainIconSize: CGSize
    let backgroundImage: UIImage?
    var style: VFGCVMOverlayStyle
    let appearance: VFGCVMOverlayAppearance
    var textColor: UIColor?
    var textContentAlignment: NSTextAlignment
    var primaryButtonBackgroundColor: UIColor?
    var primaryButtonBorder: UIColor?
    var secondaryButtonBackgroundColor: UIColor?
    var primaryButtonTextColor: UIColor?
    var secondaryButtonTextColor: UIColor?
    var contentAlignment: VFGCVMOverlayContentAlignment = .center(margin: 0)
    var iconsAlignment: VFGCVMOverlayIconsAlignment = .center()
    var closeIconColor: UIColor?

    /// - Parameters:
    ///   - title: The title that appears under the image
    ///   - content: The description
    ///   - primaryButtonTitle: The primary button text
    ///   - secondaryButtonTitle: The secondary button text
    ///   - mainIcon: The main icon
    ///   - backgroundImage: The screen's background
    ///   - style: The overlay style
    ///   - textColor: text color
    ///   - textContentAlignment: text Content Alignment
    ///   - primaryButtonBackgroundColor: primary button BackgroundColor
    ///   - primaryButtonBorder: primary button BorderColor
    ///   - secondaryButtonBackgroundColor: secondary button BackgroundColor
    ///   - primaryButtonTextColor: primary button TextColor
    ///   - secondaryButtonTextColor: secondary button TextColor
    ///   - contentAlignment: Controls content position either to be on the top, center or bottom with proper margin
    ///   - closeIconColor: close icon Color
    public init(
        title: String,
        content: String,
        primaryButtonTitle: String,
        secondaryButtonTitle: String? = nil,
        mainIcon: UIImage? = nil,
        backgroundImage: UIImage? = nil,
        style: VFGCVMOverlayStyle = .birthday,
        appearance: VFGCVMOverlayAppearance = .light,
        textColor: UIColor? = nil,
        textContentAlignment: NSTextAlignment = .center,
        primaryButtonBackgroundColor: UIColor? = nil,
        primaryButtonBorder: UIColor? = nil,
        secondaryButtonBackgroundColor: UIColor? = nil,
        primaryButtonTextColor: UIColor? = nil,
        secondaryButtonTextColor: UIColor? = nil,
        contentAlignment: VFGCVMOverlayContentAlignment = .center(margin: -UIScreen.main.bounds.height * 0.1),
        iconsAlignment: VFGCVMOverlayIconsAlignment = .center(),
        closeIconColor: UIColor? = nil
    ) {
        self.title = title
        self.content = content
        self.attributedContent = nil
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
        self.mainIcon = mainIcon != nil ? .image(mainIcon) : nil
        self.mainIconSize = VFGCVMOverlayIcon.Size.large
        self.backgroundImage = backgroundImage
        self.style = style
        self.appearance = appearance
        self.textColor = textColor
        self.textContentAlignment = textContentAlignment
        self.primaryButtonBackgroundColor = primaryButtonBackgroundColor
        self.primaryButtonBorder = primaryButtonBorder
        self.secondaryButtonBackgroundColor = secondaryButtonBackgroundColor
        self.primaryButtonTextColor = primaryButtonTextColor
        self.secondaryButtonTextColor = secondaryButtonTextColor
        self.contentAlignment = contentAlignment
        self.iconsAlignment = iconsAlignment
        self.closeIconColor = closeIconColor
    }

    /// - Parameters:
    ///   - title: The title that appears under the image
    ///   - content: The description
    ///   - primaryButtonTitle: The primary button text
    ///   - secondaryButtonTitle: The secondary button text
    ///   - mainIcon: The main icon
    ///   - mainIconSize: The main icon size
    ///   - backgroundImage: The screen's background
    ///   - style: The overlay style
    ///   - appearance: The overlay appearance (light/dark)
    ///   - textColor: text color
    ///   - textContentAlignment: text Content Alignment
    ///   - primaryButtonBackgroundColor: primary button BackgroundColor
    ///   - primaryButtonBorder: primary button BorderColor
    ///   - secondaryButtonBackgroundColor: secondary button BackgroundColor
    ///   - primaryButtonTextColor: primary button TextColor
    ///   - secondaryButtonTextColor: secondary button TextColor
    public init(
        title: String,
        content: NSAttributedString,
        primaryButtonTitle: String,
        secondaryButtonTitle: String? = nil,
        mainIcon: VFGCVMOverlayIcon? = nil,
        mainIconSize: CGSize = VFGCVMOverlayIcon.Size.large,
        backgroundImage: UIImage? = nil,
        style: VFGCVMOverlayStyle = .birthday,
        appearance: VFGCVMOverlayAppearance = .light,
        textColor: UIColor? = nil,
        textContentAlignment: NSTextAlignment = .center,
        primaryButtonBackgroundColor: UIColor? = nil,
        primaryButtonBorder: UIColor? = nil,
        secondaryButtonBackgroundColor: UIColor? = nil,
        primaryButtonTextColor: UIColor? = nil,
        secondaryButtonTextColor: UIColor? = nil
    ) {
        self.title = title
        self.content = nil
        self.attributedContent = content
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
        self.mainIcon = mainIcon
        self.mainIconSize = mainIconSize
        self.backgroundImage = backgroundImage
        self.style = style
        self.appearance = appearance
        self.textColor = textColor
        self.textContentAlignment = textContentAlignment
        self.primaryButtonBackgroundColor = primaryButtonBackgroundColor
        self.primaryButtonBorder = primaryButtonBorder
        self.secondaryButtonBackgroundColor = secondaryButtonBackgroundColor
        self.primaryButtonTextColor = primaryButtonTextColor
        self.secondaryButtonTextColor = secondaryButtonTextColor
    }
}
