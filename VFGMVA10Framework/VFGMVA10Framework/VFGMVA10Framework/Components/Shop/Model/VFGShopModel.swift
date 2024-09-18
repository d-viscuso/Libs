//
//  VFGShopModel.swift
//  VFGMVA10Framework
//
//  Created by Ayman Ata on 25/01/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import Foundation

/// **VFGShopModel** is the model for the shop view scree.
public struct VFGShopModel: Codable {
    /// Type of the shop view.
    var shopViewType: VFGShopViewType?
    /// Shop items that will be presented in the shop view.
    var shopItems: [VFGShopItemModel]?

    /// Creates new instance of *VFGShopModel*.
    /// - Parameters:
    ///   - shopViewType: Type of the shop view.
    ///   - shopItems: Shop items that will be presented in the shop view.
    public init(shopViewType: VFGShopViewType, shopItems: [VFGShopItemModel]) {
        self.shopViewType = shopViewType
        self.shopItems = shopItems
    }
}

/// Type of the shop view,  either vertical or horzontal.
public enum VFGShopViewType: String, Codable {
    case vertical
    case horizontal
}

/// *VFGShopItemModel* is the model for each shop item.
public struct VFGShopItemModel: Codable {
    /// Shop view item title.
    public var title: String?
    /// Shop view item image.
    public var image: String?
    /// Shop view item badge.
    public var badge: Int?
}
