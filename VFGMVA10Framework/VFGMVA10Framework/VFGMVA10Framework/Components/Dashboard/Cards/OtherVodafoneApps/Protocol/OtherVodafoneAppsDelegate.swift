//
//  OtherVodafoneAppsDelegate.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 22/11/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

/// A delegate protocol that manages user interactions with the other vodafone apps,
/// including CTA Press
public protocol OtherVodafoneAppsDelegate: AnyObject {
    /// Notify the delegate once the other vodafone app CTA is clicked.
    /// - Parameters:
    ///   - view: Current other vodafone apps view associated with the delegate.
    ///   - item: An object of type *OtherVodafoneAppsItemModel* which represents the app model of clicked item.
    func otherVodafoneApps(_ view: OtherVodafoneAppsView, itemCTADidPress item: OtherVodafoneAppsItemModel)
}

extension OtherVodafoneAppsDelegate {
    func otherVodafoneApps(_ view: OtherVodafoneAppsView, itemCTADidPress item: OtherVodafoneAppsItemModel) {}
}
