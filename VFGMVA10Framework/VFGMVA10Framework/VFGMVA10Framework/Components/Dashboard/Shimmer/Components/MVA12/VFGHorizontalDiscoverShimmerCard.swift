//
//  VFGHorizontalDiscoverShimmerCard.swift
//  VFGMVA10Framework
//
//  Created by Ayman Ata on 09/02/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class VFGHorizontalDiscoverShimmerCard: NSObject, VFGComponentEntry {
    private var discoverShimmerView: HorizontalDiscoverView?
    required init(config: [String: Any]?, error: [String: Any]?) {}

    var cardView: UIView? {
        discoverShimmerView = .loadXib(bundle: .mva10Framework)
        discoverShimmerView?.state = .loading
        return discoverShimmerView
    }

    var cardEntryViewController: UIViewController? {
        nil
    }
}
