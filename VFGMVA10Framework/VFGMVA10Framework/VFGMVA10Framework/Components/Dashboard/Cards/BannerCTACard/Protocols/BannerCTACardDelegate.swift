//
//  BannerCTACardDelegate.swift
//  VFGMVA10Framework
//
//  Created by İhsan Kahramanoğlu on 12/27/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

/// BannerCTACardDelegate
public protocol BannerCTACardDelegate: AnyObject {
    /// A method which gets invoked once the banner cta card is pressed
    /// - Parameter model: An object of type *BannerCTACardItemModel*
    func bannerCTACardViewDidPress(_ model: BannerCTACardItemModel)
    /// A method which gets invoked once the banner first cta card is pressed
    /// - Parameter model: An object of type *BannerCTACardItemModel*
    func bannerFirstCTAButtonDidPress(_ model: BannerCTACardItemModel)
    /// A method which gets invoked once the banner second cta card is pressed
    /// - Parameter model: An object of type *BannerCTACardItemModel*
    func bannerSecondCTAButtonDidPress(_ model: BannerCTACardItemModel)
}

public extension BannerCTACardDelegate {
    func bannerCTACardViewDidPress(_ model: BannerCTACardItemModel) {}
    func bannerFirstCTAButtonDidPress(_ model: BannerCTACardItemModel) {}
    func bannerSecondCTAButtonDidPress(_ model: BannerCTACardItemModel) {}
}
