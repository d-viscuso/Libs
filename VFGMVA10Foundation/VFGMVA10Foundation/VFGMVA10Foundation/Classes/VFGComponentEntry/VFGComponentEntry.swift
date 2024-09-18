//
//  VFGComponentEntry.swift
//  mva10
//
//  Created by Sandra Morcos on 12/13/18.
//  Copyright © 2019 vodafone. All rights reserved.
//

import Foundation
import UIKit

/// A protocol that manages your view as an entry point through dashboard
public protocol VFGComponentEntry: AnyObject {
    /// Component entry initializer
    /// - Parameters:
    ///    - config: Dictionary for given data
    ///    - error: Dictionary for errors if found
    init(config: [String: Any]?, error: [String: Any]?)

    /// A view displayed on the app dashboard as a tile
    var cardView: UIView? { get }

    /// A boolean variable indicates whether component access is allowed or not
    var isLocked: Bool { get }

    /// A view displayed when component is locked
    var lockedCardView: UIView? { get }

    /// A boolean variable indicates whether maximum height is applied to dashboard generic components or not. Default is false.
    var isMaximumHeightDisabled: Bool { get }

    /// A view controller which displayed after the selection of the tile from the dashboard
    var cardEntryViewController: UIViewController? { get }

    /// A method executed when card is clicked if cardEntryViewController is nil
    func didSelectCard()

    /// A method to handle display state in dashboard collection views
    func willDisplay()

    /// A method executed when component entry finish displaying
    func didEndDisplay()

    /// - Notify cell when it's visible with current offset
    /// - Parameters:
    ///    - percentage: The percentage of current offset
    func didScroll(percentage: CGFloat)
}

public extension VFGComponentEntry {
    var isLocked: Bool { false }
    var lockedCardView: UIView? { nil }
    var isMaximumHeightDisabled: Bool { false }

    func didSelectCard() {}
    func willDisplay() {}
    func didEndDisplay() {}
    func didScroll(percentage: CGFloat) {}
}
