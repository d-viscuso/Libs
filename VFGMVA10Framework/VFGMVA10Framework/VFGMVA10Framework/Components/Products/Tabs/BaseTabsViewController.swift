//
//  BaseTabsViewController.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 4/28/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

/// Base tabs view controller. Any controller that will be added to *ProductsViewController* should conform this protocol.
public protocol BaseTabsViewController: UIViewController {
    /// This variable should typically point to *ProductsViewController*.
    var rootViewController: (UIViewController & BaseTabsViewControllerDelegate)? { get set }
    /// Use this closure every time you have a UI update that affects the views height to update the container height.
    var updateHeightClosure: ((CGFloat) -> Void)? { get set }
    /// Use this closure when your view loads for the first time to update the container height.
    var setHeightClosure: ((CGFloat) -> Void)? { get set }
    /// Refresh action triggered when the user press on refresh button in *ProductsHeaderView*. The action will be triggered for all tabs in *ProductsViewController* not only the tab the user was viewing.
    func refresh()
}

/// Base tabs view controller delegate.
public protocol BaseTabsViewControllerDelegate: AnyObject {
    /// A method invoked when fetching data is about to start.
    func dataFetchingWillStart()
    /// A method invoked after fetching data is completed.
    func dataFetchingDidComplete()
}

public enum ProductsEntryPoints {
    case myPhone
    case vHome
    case broadband
    case fixedLine
    case vodafoneTV
    case subscription
}
