//
//  BaseMultiTabsViewController.swift
//  VFGMVA10Foundation
//
//  Created by Moataz Akram on 12/4/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

/// Any Controller that will be added in MultiTabsViewController should conform this protocol 
public protocol BaseMultiTabsViewController: UIViewController {
    var rootViewController: (UIViewController & BaseMultiTabsViewControllerDelegate)? { get set }
    /// Use this closure every time you have a UI update that affects the views height to update the container height.
    var updateHeightClosure: ((CGFloat) -> Void)? { get set }
    var setHeightClosure: ((CGFloat) -> Void)? { get set }

    func refresh()
}

extension BaseMultiTabsViewController {
    func refresh() {}
}

/// Use this protocol in case your controller needs to fetch data & update height at the start & complete methods.
public protocol BaseMultiTabsViewControllerDelegate: AnyObject {
    /// A method invoked when fetching data is about to start
    func dataFetchingWillStart()
    /// A method invoked after fetching data is completed
    func dataFetchingDidComplete()
}

extension BaseMultiTabsViewControllerDelegate {
    func dataFetchingWillStart() {}
    func dataFetchingDidComplete() {}
}
/// Use this protocol to trigger a callback method when the user press on one of the tabs in a multi tabs controller
public protocol VFGMultiTabsDelegate: AnyObject {
    /// A method invoked when the user press on one of the tabs in a multi tabs controller
    func didSelectTabAt(indexPath: IndexPath)
}

class VFGBaseMultiTabsViewController: UIViewController, BaseMultiTabsViewController {
    var rootViewController: (UIViewController & BaseMultiTabsViewControllerDelegate)?
    var updateHeightClosure: ((CGFloat) -> Void)?
    var setHeightClosure: ((CGFloat) -> Void)?
}
