//
//  VFGLoginTilesDataSource.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 08/11/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

/// A data source protocol that manages the data in your login tiles
/// It represents your data model and vends information to the login tiles as needed
/// It creates and configures the login tiles views to display your data
public protocol VFGLoginTilesDataSource: AnyObject {
    /// Provide data for both login tiles.
    /// - Parameters:
    ///   - view: Current login tiles view associated with the data source.
    /// - Returns: An object of type *LoginTileModel* which represents the tile which contains the CTA.
    func loginTiles(_ view: VFGLoginTilesView) -> VFGLoginTilesModel
}
