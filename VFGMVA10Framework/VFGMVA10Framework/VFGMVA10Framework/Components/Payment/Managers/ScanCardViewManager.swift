//
//  AddPaymentCardDelegate.swift
//  VFGMVA10Framework
//
//  Created by Atta Amed on 8/31/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

/// Scan card view manager.
public class ScanCardViewManager: ScanCardViewManagerProtocol {
    public var viewController: UIViewController?

    public init(scanCardViewController: UIViewController?) {
        self.viewController = scanCardViewController
    }

    public func navigateToScanCard() {}
}
