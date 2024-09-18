//
//  VFQuickActionsModel.swift
//  VFGMVA10Foundation
//
//  Created by Sandra Morcos on 7/30/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

/// An enum represent quck action styles
public enum VFQuickActionsStyle: Equatable {
    case red, white
    case custom(backGroundColor: UIColor, textColor: UIColor)

    public static func == (lhs: VFQuickActionsStyle, rhs: VFQuickActionsStyle) -> Bool {
        switch (lhs, rhs) {
        case (.red, .red):
            return true
        case (.white, .white):
            return true
        case let (.custom(backGroundColor: leftBColor, textColor: leftTColor),
            .custom(backGroundColor: rightBColor, textColor: rightTColor)):
            return leftBColor == rightBColor && leftTColor == rightTColor
        default:
            return false
        }
    }
}

/// A protocol that manages the data, style and actions in your quick actions
/// It represents your data model and vends information to the quick actions as needed
public protocol VFQuickActionsModel {
    /// used to pass the quick actions delegate
    func quickActionsProtocol(delegate: VFQuickActionsProtocol)
    /// to close quick action
    func closeQuickAction()
    /// to go back to the previous state
    func backQuickAction()
    /// fired after clicking on the header button
    func headerButtonAction()
    /// style enum to specify the background of the view, default is red
    var quickActionsStyle: VFQuickActionsStyle { get }
    /// a view that is being presented
    var quickActionsContentView: UIView { get }
    /// quick action title
    var quickActionsTitle: String { get }
    /// header button title, default is empty string
    /// - note: make sure that isHeaderButtonHidden is set to false
    var headerButtonTitle: String { get }
    var accessibilityModel: VFQuickActionsAccessibilityModel { get }
    /// a boolean to check whether user interaction is enabled or not
    var isUserInteractionEnabled: Bool { get }
    /// a boolean to show or hide back button, default is true
    var isBackButtonHidden: Bool { get }
    /// a boolean to show or hide close button, default is false
    var isCloseButtonHidden: Bool { get }
    /// close button image
    var closeButtonImage: UIImage? { get }
    /// a boolean to show or hide header button, default is true
    var isHeaderButtonHidden: Bool { get }
    /// a boolean to raise the view up and show the keyboard
    var shouldRaiseForKeyboard: Bool { get }
    /// a property to change the font of the header title
    var titleFont: UIFont { get }
    /// styled custom header title
    var quickActionAttributedTitle: NSAttributedString? { get }
    /// a custom header view
    var customHeaderView: UIView? { get }
    /// set maximum height ratio
    var maximumHeightRatio: CGFloat { get }
    /// quick action title accessibility label for voice over, default is quickActionsTitle
    var quickActionsTitleAccessibilityLabel: String { get }
    /// close button accessibility label for voice over, default is "Close"
    var closeButtonAccessibilityLabel: String { get }
    /// back button accessibility label for voice over, default is "Back"
    var backButtonAccessibilityLabel: String { get }
    /// A *Bool* value to determine if scroll view (that embeds custom action views) is scrollable or not.
    var isScrollEnabled: Bool { get }
    /// Corner radius for upper corners
    var upperCornersRadius: CGFloat { get }
}

extension VFQuickActionsModel {
    public var quickActionsStyle: VFQuickActionsStyle {
        return .red
    }

    public var isBackButtonHidden: Bool {
        true
    }

    public func backQuickAction() {}

    public func headerButtonAction() {}

    public var isCloseButtonHidden: Bool {
        return false
    }

    public var closeButtonImage: UIImage? {
        return VFGFoundationAsset.Image.icClose
    }

    public var isHeaderButtonHidden: Bool {
        true
    }

    public var headerButtonTitle: String {
        ""
    }

    public var isUserInteractionEnabled: Bool {
        false
    }

    public var accessibilityModel: VFQuickActionsAccessibilityModel {
        VFQuickActionsAccessibilityModel()
    }

    public var shouldRaiseForKeyboard: Bool { false }

    public var titleFont: UIFont { UIFont.vodafoneBold(17) }

    public var quickActionAttributedTitle: NSAttributedString? {
        nil
    }

    public var customHeaderView: UIView? {
        nil
    }

    public var maximumHeightRatio: CGFloat {
        0.95
    }

    public var quickActionsTitleAccessibilityLabel: String {
        quickActionsTitle
    }

    public var closeButtonAccessibilityLabel: String {
        "Close"
    }

    public var backButtonAccessibilityLabel: String {
        "Back"
    }

    public var isScrollEnabled: Bool {
        true
    }

    public var upperCornersRadius: CGFloat {
        6
    }
}
