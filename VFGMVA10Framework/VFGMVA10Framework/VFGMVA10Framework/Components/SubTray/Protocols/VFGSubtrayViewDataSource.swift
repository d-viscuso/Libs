//
//  VFGSubtrayViewDataSource.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 12/16/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//
/// Delegation protocol for sub tray view data source
public protocol VFGSubtrayViewDataSource: AnyObject {
    /// View to be added to sub tray view
    /// - Parameters:
    ///    - subtrayView: Sub tray to add action view to it
    /// - Returns: Should return a type of action view like *VFGSwitchAccountActionView*
    func actionView(for subtrayView: VFGSubtrayViewProtocol) -> UIView?
    /// Sub tray view title text
    /// - Parameters:
    ///    - subtrayView: Sub tray to add its title text
    /// - Returns: Should return sub tray title text
    func title(for subtrayView: VFGSubtrayViewProtocol) -> String?
    /// Determine if sub tray item is accessible or not
    /// - Parameters:
    ///    - item: Sub tray item
    ///    - subtrayView: Sub tray which hold the item
    /// - Returns: Should return sub tray item status whether it is locked or not
    func isLocked(item: VFGSubTrayItem, for subtrayView: VFGSubtrayViewProtocol) -> Bool
    /// View to be added to sub tray view
    /// - Parameters:
    ///    - subtrayView: Sub tray to add action view to it
    /// - Returns: Should return a type of manage group action view like *ManageGroupActionView*
    func manageGroupActionView(for subtrayView: VFGSubtrayViewProtocol) -> UIView?
}
