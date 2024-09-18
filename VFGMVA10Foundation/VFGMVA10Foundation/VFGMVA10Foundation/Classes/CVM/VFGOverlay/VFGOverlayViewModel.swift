//
//  VFGFullScreenOverlayViewModel.swift
//  VFGMVA10Foundation
//
//  Created by Ashraf Dewan on 15/12/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
/// An enum that holds all overlay types
public enum OverlayType {
    case flexHeight
    case fullScreen
}
/// Data model for full screen overlay view controller
public class VFGOverlayViewModel {
    var overlayType: OverlayType
    var backgroundImage: UIImage?
    var iconImage: UIImage?
    var titleLabelText: String?
    var subtitleLabelText: String?
    var primaryButtonText: String
    var secondaryButtonText: String?
    var primaryButtonCompletion: (() -> Void)?
    var secondaryButtonCompletion: (() -> Void)?
    /// View model initializer with background image
    /// - Parameters:
    ///    - backgroundImage: View controller background image
    ///    - primaryButtonText: Primary button title
    ///    - secondaryButtonText: Secondary button title
    ///    - primaryButtonCompletion: Primary button action
    ///    - secondaryButtonCompletion: Secondary button action
    public init(
        overlayType: OverlayType,
        backgroundImage: UIImage,
        primaryButtonText: String,
        secondaryButtonText: String? = nil,
        primaryButtonCompletion: (() -> Void)? = nil,
        secondaryButtonCompletion: (() -> Void)? = nil
    ) {
        self.overlayType = overlayType
        self.backgroundImage = backgroundImage
        self.primaryButtonText = primaryButtonText
        self.secondaryButtonText = secondaryButtonText
        self.primaryButtonCompletion = primaryButtonCompletion
        self.secondaryButtonCompletion = secondaryButtonCompletion
    }
    /// View model initializer with icon image, title and subtitle
    /// - Parameters:
    ///    - iconImage: View controller icon image
    ///    - titleLabelText: Title text
    ///    - subtitleLabelText: Subtitle text
    ///    - primaryButtonText: Primary button title
    ///    - secondaryButtonText: Secondary button title
    ///    - primaryButtonCompletion: Primary button action
    ///    - secondaryButtonCompletion: Secondary button action
    public init(
        overlayType: OverlayType,
        iconImage: UIImage,
        titleLabelText: String,
        subtitleLabelText: String,
        primaryButtonText: String,
        secondaryButtonText: String? = nil,
        primaryButtonCompletion: (() -> Void)? = nil,
        secondaryButtonCompletion: (() -> Void)? = nil
    ) {
        self.overlayType = overlayType
        self.iconImage = iconImage
        self.titleLabelText = titleLabelText
        self.subtitleLabelText = subtitleLabelText
        self.primaryButtonText = primaryButtonText
        self.secondaryButtonText = secondaryButtonText
        self.primaryButtonCompletion = primaryButtonCompletion
        self.secondaryButtonCompletion = secondaryButtonCompletion
    }
}
