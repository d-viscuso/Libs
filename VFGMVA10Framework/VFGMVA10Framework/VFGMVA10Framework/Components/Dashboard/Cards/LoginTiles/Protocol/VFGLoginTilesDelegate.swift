//
//  VFGLoginTilesDelegate.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 08/11/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

/// A delegate protocol that manages user interactions with the login tiles,
/// including CTA Press
public protocol VFGLoginTilesDelegate: AnyObject {
    /// Notify the delegate once the login tile CTA is clicked.
    /// - Parameters:
    ///   - view: Current login tiles view associated with the delegate.
    ///   - tile: An object of type *LoginTileModel* which represents the tile which contains the CTA.
    ///   - type: An enum of type *VFGLoginTilesType* which represents the tile type
    func loginTiles(_ view: VFGLoginTilesView, tileCTADidPress tile: VFGLoginTileModel, forTile type: VFGLoginTilesType)
}

public extension VFGLoginTilesDelegate {
    func loginTiles(_ view: VFGLoginTilesView, tileCTADidPress tile: VFGLoginTileModel, forTile type: VFGLoginTilesType) {
        /// Default implementation
    }
}
