//
//  VFGSubtrayViewDelegate.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 11/30/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//
/// Delegation protocol for sub tray view actions
public protocol VFGSubtrayViewDelegate: AnyObject {
    /// Close sub tray view
    /// - Parameters:
    ///    - animated: Determine whether closing process is animated or not
    func subtrayDidDismiss(animated: Bool)
    /// Notify with sub tray subviews change to figure its new height
    /// - Parameters:
    ///    - subtrayView: The view which height changed
    func subtrayHeightDidChange(for subtrayView: VFGSubtrayViewProtocol)
    /// Calculate sub tray view new height based on changed subviews
    /// - Parameters:
    ///    - subtrayView: The view which height changed
    func updateSubtrayHeight(for subtrayView: VFGSubtrayViewProtocol)
}

public extension VFGSubtrayViewDelegate {
    func updateSubtrayHeight(for subtrayView: VFGSubtrayViewProtocol) {}
}
