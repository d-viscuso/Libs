//
//  VFGTooltipsManagerDelegate.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 23/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

/// A delegate protocol triggers tooltips status changes.
public protocol VFGTooltipsManagerDelegate: AnyObject {
    /// A boolean to determine whether the dismiss all button hidden or not
    var isDismissAllButtonHidden: Bool? { get }

    /// Triggered when all the tooltips are completed
    func tooltipsDidComplete()

    /// Triggered when a single tooltip is completed
    /// - Parameters:
    ///   - number: The number of completed tooltip
    func tooltipDidComplete(_ number: Int)

    /// Triggered when a tooltip view is pressed.
    func tooltipViewDidTap(_ number: Int)

    /// Triggered when a tooltip view is dismissed.
    func tooltipViewDidDismiss(_ number: Int)

    /// Triggered when the dismiss all button is pressed
    func tooltipDimissAllButtonDidTap()
}

public extension VFGTooltipsManagerDelegate {
    var isDismissAllButtonHidden: Bool? {
        true
    }
    func tooltipsDidComplete() {}
    func tooltipDidComplete(_ number: Int) {}
    func tooltipViewDidTap(_ number: Int) {}
    func tooltipViewDidDismiss(_ number: Int) {}
    func tooltipDimissAllButtonDidTap() {}
}
