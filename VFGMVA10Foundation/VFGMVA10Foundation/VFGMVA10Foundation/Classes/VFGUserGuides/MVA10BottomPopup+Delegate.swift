//
//  VFBottomPopup+Delegate.swift
//  MyVodafone
//
//  Created by Ramy Nasser on 6/18/19.
//  Copyright © 2019 TSSE. All rights reserved.
//

import UIKit

public typealias MVA10BottomPresentableViewController = MVA10BottomPopupAttributesProtocol & UIViewController

/// A delegate protocol that manages user interactions with bottom popup,
/// including view loaded, will appear, did appear, will dismiss, did dismiss and dismiss interaction.
public protocol MVA10BottomPopupDelegate: AnyObject {
    /// Notifies the view controller that its view was added to a view hierarchy.
    func bottomPopupViewLoaded()
    /// Notifies the view controller that its view is going to be added to a view hierarchy.
    func bottomPopupWillAppear()
    /// Notifies the view controller that its view was added to a view hierarchy.
    func bottomPopupDidAppear()
    /// Notifies the view controller that its view is going to be removed from a view hierarchy.
    func bottomPopupWillDismiss()
    /// Notifies the view controller that its view is removed from a view hierarchy.
    func bottomPopupDidDismiss()
    /// Notifies that the interaction percent has changed.
    func bottomPopupDismissInteraction(didChangedPercentFrom oldValue: CGFloat, to newValue: CGFloat)
}

/// A protocol which provides attributes that holds data for bottom popup and it's associated animation.
public protocol MVA10BottomPopupAttributesProtocol: AnyObject {
    /// Called when height of overlay is needed
    /// - Returns: overlay height
    func getPopupHeight() -> CGFloat
    /// Called when width of overlay is needed
    /// - Returns: overlay width
    func getPopupWidth() -> CGFloat
    /// Called when need to know the duration of presenting animation
    /// - Returns: present animation duration
    func getPopupPresentDuration() -> Double
    /// Called when need to know the duration of dismissing animation
    /// - Returns: dismiss animation duration
    func getPopupDismissDuration() -> Double
    /// Notifies if overlay can be dismissed by dragging
    /// - Returns: true if it can be dismissed by dragging
    func shouldPopupDismissInteractivelty() -> Bool
    /// Notifies if overlay can be dismissed by tapping on dimmed view
    /// - Returns: true if it can be dismissed by tapping on dimmed view
    func shouldPopupViewDismissInteractivelty() -> Bool
    /// Notifies the alpha value for dimmed view
    /// - Returns: dimmed view alpha value
    func getDimmingViewAlpha() -> CGFloat
    /// Notifies the color value for dimmed view background
    /// - Returns: dimmed view background color value
    func getDimmingViewBackgroundColor() -> UIColor
}
