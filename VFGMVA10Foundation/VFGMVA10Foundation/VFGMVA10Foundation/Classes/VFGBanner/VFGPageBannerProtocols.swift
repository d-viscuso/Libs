//
//  VFGPageBannerProtocols.swift
//  VFGMVA10Foundation
//
//  Created by Hamsa Hassan on 9/1/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// page banner dismiss  protocol.
public protocol VFGPageBannerDismissProtocol: AnyObject {
    /// Notify the delegate once page Banner is dismissed
    func dismissBanner()
}

/// page banner buttons action protocol.
public protocol VFGPageBannerProtocol: AnyObject {
    /// Notify the delegate once primary button is selected.
    /// - Parameters:
    ///   - pageBanner: Current page banner associated with the delegate.
    func primaryButtonDidSelect(for pageBanner: VFGPageBanner)
    /// Notify the delegate once secondary button is selected.
    /// - Parameters:
    ///   - pageBanner: Current page banner associated with the delegate.
    func secondaryButtonDidSelect(for pageBanner: VFGPageBanner)
    /// Notify the delegate once switch button is selected.
    /// - Parameters:
    ///   - pageBanner: Current page banner associated with the delegate.
    func switchButtonDidSelect(for pageBanner: VFGPageBanner)
}

public extension VFGPageBannerProtocol {
    func secondaryButtonDidSelect(for pageBanner: VFGPageBanner) {}
    func switchButtonDidSelect(for pageBanner: VFGPageBanner) {}
}
