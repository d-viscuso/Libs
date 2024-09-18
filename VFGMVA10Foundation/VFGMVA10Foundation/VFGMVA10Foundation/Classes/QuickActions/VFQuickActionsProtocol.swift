//
//  VFQuickActionsProtocol.swift
//  VFGMVA10Foundation
//
//  Created by Esraa Eldaltony on 1/14/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// A protocol that manages user interactions with quick actions, including reload, close and scrolling
public protocol VFQuickActionsProtocol: AnyObject {
    /// Reload quick action with a given model
    func reloadQuickAction(model: VFQuickActionsModel?)
    /// Close quick action
    /// - Parameters:
    ///   - completion: Tells the delegate that close action is just closed
    func closeQuickAction(completion: (() -> Void)?)
    /// To scroll the quick action with a given height
    /// - Parameters:
    ///   - height: The amount of height that will scroll the quick action view
    func shouldScroll(height: CGFloat)
}

public extension VFQuickActionsProtocol {
    func shouldScroll(height: CGFloat) {}
}
