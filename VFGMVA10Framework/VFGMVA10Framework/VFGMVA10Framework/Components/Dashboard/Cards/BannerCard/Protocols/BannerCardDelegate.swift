//
//  BannerCardDelegate.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 24/07/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

public protocol BannerCardDelegate: AnyObject {
    func bannerView(_ view: BannerCard, configureBackground image: VFGImageView, with model: BannerCardModel)
}

public extension BannerCardDelegate {
    func bannerView(
        _ view: BannerCard,
        configureBackground image: VFGImageView,
        with model: BannerCardModel
    ) {}
}
