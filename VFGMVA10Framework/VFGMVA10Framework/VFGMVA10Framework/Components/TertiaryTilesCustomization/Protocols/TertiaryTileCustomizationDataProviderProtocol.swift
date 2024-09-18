//
//  TertiaryTileCustomizationDataProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 09/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

/// Data provider protocol for tertiary tile customization journey.
public protocol TertiaryTileCustomizationDataProviderProtocol {
    /// A function to get a list of previously saved ordered tiles.
    /// First two items of the list will be shown as active ones.
    /// The remaining items of the list will be shown as inactive ones.
    /// return A list of [TileModel].
    func getOrderedTilesData() -> [TileModel]

    /// A callback that is invoked when the user confirms the new tiles order.
    /// It is invoked with list of tiles changed.
    /// These values can be used to update dashboard, and save the values for persistence.
    /// - Parameters:
    ///   - tertiaryTiles: The list of tiles changed.
    func onTilesDataOrderChanged(tertiaryTiles: [TileModel])
}
