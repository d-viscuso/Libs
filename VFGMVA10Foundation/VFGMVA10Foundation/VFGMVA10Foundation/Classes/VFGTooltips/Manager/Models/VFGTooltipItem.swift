//
//  VFGTooltipItem.swift
//  VFGMVA10Group
//
//  Created by Yahya Saddiq on 16/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit

/// Model of a tooltip.
public struct VFGTooltipItem {
    /// The target view of the tooltip.
    /// Target view must be provided to show a tooltip.
    public let target: UIView?
    /// Tooltip title.
    public let title: String
    /// Tooltip description.
    public let description: String
    /// Tooltip action on appearance.
    /// For example: scroll collection view horizontally when the tooltip appears.
    public var action: (() -> Void)?
    /// Tooltip button details.
    public var button: VFGTooltipItemButton
    /// Dismiss all tooltips button title
    public var dismissAllButtonTitle: String
    /// Tooltip custom preferences.
    /// Including animation, drawing and positioning.
    /// Default preferences is used if none is provided.
    public let preferences: VFGTooltips.Preferences?
    /// The target view frame of the tooltip
    /// The target view frame is the first option to show a tooltip above it otherwise we will exclude it from the `target` property 
    public let targetFrame: CGRect?


    /// Tooltip model initializer
    /// - Parameters:
    ///    - target: The target view of the tooltip. Target view must be provided to show a tooltip.
    ///    - title: Tooltip title..
    ///    - description: Tooltip description.
    ///    - button: Tooltip button details..
    ///    - preferences: Tooltip custom preferences, Including animation, drawing and positioning.
    ///    - action: Tooltip action on appearance. For example: scroll collection view horizontally when the tooltip appears.
    public init(
        target: UIView?,
        title: String,
        description: String,
        button: VFGTooltipItemButton,
        dismissAllButtonTitle: String = "Dismiss All",
        preferences: VFGTooltips.Preferences? = nil,
        action: (() -> Void)? = nil,
        targetFrame: CGRect? = nil
    ) {
        self.target = target
        self.title = title
        self.description = description
        self.action = action
        self.button = button
        self.dismissAllButtonTitle = dismissAllButtonTitle
        self.preferences = preferences
        self.targetFrame = targetFrame
    }
}
