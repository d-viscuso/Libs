//
//  ScanCardViewManagerProtocol.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 10/7/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

/// Scan card view manager protocol.
public protocol ScanCardViewManagerProtocol: AnyObject {
    /// Action to navigate to scan card view.
    func navigateToScanCard()
    /// Scan card view controller.
    var viewController: UIViewController? { get set }
}
