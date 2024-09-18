//
//  TertiaryTileCustomizationViewModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 09/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

/// A view model class which handles tertiary tile customization UI logic.
public class TertiaryTileCustomizationViewModel {
    let selectedTilesCount = 2
    let sections = (visible: 0, hidden: 1)
    private var dataProvider: TertiaryTileCustomizationDataProviderProtocol
    private var previousVisibleTertiryTiles: [TileModel] = []
    var tertiaryTilesConfiguration: [TileModel] = []
    private var visibleTertiaryTiles: [TileModel] {
        return Array(tertiaryTilesConfiguration.prefix(selectedTilesCount))
    }
    private var hiddenTertiaryTiles: [TileModel] {
        return Array(tertiaryTilesConfiguration.dropFirst(selectedTilesCount))
    }

    /// Tertiary tile customization view model initializer.
    /// - Parameter dataProvider: Given data provider to fetch data.
    init(dataProvider: TertiaryTileCustomizationDataProviderProtocol) {
        self.dataProvider = dataProvider
    }

    /// A method that is responsible for handling the result of get ordered tiles data.
    func getOrderedTilesData() {
        tertiaryTilesConfiguration = dataProvider.getOrderedTilesData()
        previousVisibleTertiryTiles = visibleTertiaryTiles
    }

    /// A method that is used to get numbers of visible titles.
    /// - Returns: An integer represents number of visible tiles.
    func numberOfVisibleTiles() -> Int {
        return visibleTertiaryTiles.count
    }

    /// A method that is used to get numbers of hidden titles.
    /// - Returns: An integer represents number of hidden tiles.
    func numberOfHiddenTiles() -> Int {
        return hiddenTertiaryTiles.count
    }

    /// A method that is used to get a visible tile at given index.
    /// - Parameter index: An integer that represents the visible tile corresponds to it.
    /// - Returns: An object of type *TileModel*.
    func getVisibleTile(at index: Int) -> TileModel? {
        guard index < numberOfVisibleTiles() else { return nil }
        return visibleTertiaryTiles[index]
    }

    /// A method that is used to get a hidden tile at given index.
    /// - Parameter index: An integer that represents the hidden tile corresponds to it.
    /// - Returns: An object of type *TileModel*.
    func getHiddenTile(at index: Int) -> TileModel? {
        guard index < numberOfHiddenTiles() else { return nil }
        return hiddenTertiaryTiles[index]
    }

    /// A method that is used to check if the tile is in the top of the list at given index.
    /// - Parameter indexPath: An integer that represents the visible tile corresponds to it.
    /// - Returns: A boolean value.
    func isFirstTile(at indexPath: IndexPath) -> Bool {
        return indexPath.row == 0
    }

    /// A method that is used to check if the tile is in the bottom of the list at given index.
    /// - Parameter indexPath: An integer that represents the hidden tile corresponds to it.
    /// - Returns: A boolean value.
    func isLastTile(at indexPath: IndexPath) -> Bool {
        let isVisibleRow = indexPath.section == sections.visible
        return indexPath.row == (isVisibleRow ? visibleTertiaryTiles.count : hiddenTertiaryTiles.count) - 1
    }

    /// A method that is used to add or remove tile at given index.
    /// - Parameter indexPath: An integer that represents the hidden tile corresponds to it.
    func onAddOrRemoveTile(at indexPath: IndexPath) {
        var visibleTiles = visibleTertiaryTiles
        var hiddenTiles = hiddenTertiaryTiles

        let movedVisibleItem = indexPath.section == sections.visible
            ? visibleTiles.removeIfExist(at: indexPath.row)
            : visibleTiles.removeIfExist(at: visibleTertiaryTiles.count - 1)
        let movedHiddenItem = indexPath.section == sections.visible
            ? hiddenTiles.removeIfExist(at: hiddenTertiaryTiles.count - 1)
            : hiddenTiles.removeIfExist(at: indexPath.row)

        hiddenTiles.insertIfNotNil(movedVisibleItem, at: 0)
        visibleTiles.insertIfNotNil(movedHiddenItem, at: 0)

        tertiaryTilesConfiguration = visibleTiles + hiddenTiles
    }

    /// A method that is used to rearrange tiles from source index to destination index..
    /// - Parameters:
    ///   - source: An object of type *IndexPath* that represents the source index.
    ///   - destination: An object of type *IndexPath* that represents the destination index.
    func onRearrangeTiles(from source: IndexPath, to destination: IndexPath) {
        let movedItem = tertiaryTilesConfiguration.removeIfExist(at: source.row)
        tertiaryTilesConfiguration.insertIfNotNil(movedItem, at: destination.row)
    }

    /// A method that is used to check if the user change the arrangement of visible tiles.
    /// - Returns: A boolean value.
    func isVisibleTilesNotEqualPreviousOne() -> Bool {
        !(previousVisibleTertiryTiles.sortedArrayByPosition() == visibleTertiaryTiles.sortedArrayByPosition())
    }

    /// A method that is used to confirm visible and invisible tiles after customizing it..
    func onConfirmCustomizedTiles() {
        dataProvider.onTilesDataOrderChanged(tertiaryTiles: tertiaryTilesConfiguration)
    }
}
