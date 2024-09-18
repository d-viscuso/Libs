//
//  HorizontalDiscoverModel.swift
//  VFGMVA10Framework
//
//  Created by Adel Aref on 14/08/2022.
//

import Foundation

/// Dashboard horizontal discover model
public struct HorizontalDiscoverModel: Codable {
    /// List of horizontal discover items
    public var discoverList: [HorizontalDiscoverItemModel]?
    /// Dashboard horizontal discover model initializer
    /// - Parameters:
    ///    - discoverList: List of horizontal discover items
    public init(discoverList: [HorizontalDiscoverItemModel]? = nil) {
        self.discoverList = discoverList
    }
}

/// Horizontal discover item model
public struct HorizontalDiscoverItemModel: Codable {
    /// Horizontal discover item title
    public var title: String?
    /// Horizontal discover icon
    public var icon: String?
    /// Horizontal discover item badge
    public var badge: Int?
    /// Horizontal discover place holder icon
    public var placeHolderIcon: String?
    /// Horizontal discover item model initializer
    /// - Parameters:
    ///    - title: Horizontal discover item title
    ///    - icon: Horizontal discover icon
    ///    - badge: Horizontal discover item badge
    ///    - placeHolderIcon: Horizontal discover place holder icon
    public init(
        title: String? = nil,
        icon: String? = nil,
        badge: Int? = nil,
        placeHolderIcon: String? = nil
    ) {
        self.title = title
        self.icon = icon
        self.badge = badge
        self.placeHolderIcon = placeHolderIcon
    }
}
