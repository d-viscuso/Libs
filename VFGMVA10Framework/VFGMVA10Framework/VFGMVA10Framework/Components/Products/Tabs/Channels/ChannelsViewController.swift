//
//  ChannelsViewController.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 05/12/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit

/// Channels view controller.
public class ChannelsViewController: UIViewController, BaseTabsViewController {
    public var rootViewController: (UIViewController & BaseTabsViewControllerDelegate)?
    public var updateHeightClosure: ((CGFloat) -> Void)?
    public var setHeightClosure: ((CGFloat) -> Void)?
    public func refresh() {}

    public required init(
        nibName: String = String(describing: ChannelsViewController.self),
        bundle: Bundle = Bundle.mva10Framework
    ) {
        super.init(nibName: nibName, bundle: bundle)
        title = "channels_screen_title".localized(bundle: Bundle.mva10Framework)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
