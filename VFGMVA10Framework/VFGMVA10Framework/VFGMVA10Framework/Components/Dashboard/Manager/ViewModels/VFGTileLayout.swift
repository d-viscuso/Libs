//
//  VFGTileLayout.swift
//  VFGMVA10
//
//  Created by Tomasz Czyżak on 23/06/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//
import UIKit
/// Dashboard card layout
struct VFGTileLayout {
    /// Tile positions
    enum TilePosition {
        case left, right, full
    }
    /// Dashboard card size
    let size: CGSize
    /// Dashboard card column number
    let column: Int
    /// Dashboard card position
    let position: TilePosition
    /// *VFGTileLayout* initializer based on card size and column number
    /// - Parameters:
    ///    - size: Dashboard card size
    ///    - column: Dashboard card column number
    init(size: CGSize, column: Int, position: TilePosition) {
        self.size = size
        self.column = column
        self.position = position
    }
    /// *VFGTileLayout* initializer based on card indexPath, width, height and sectionType
    /// - Parameters:
    ///    - indexPath: Dashboard current card index path
    ///    - containerWidth: Dashboard card container width
    ///    - customHeight: Dashboard card container height
    ///    - sectionType: Dashboard card section type (dashboard, discover or none)
    init(indexPath: IndexPath, containerWidth: CGFloat, customHeight: CGFloat? = nil, sectionType: String? = "", itemsCount: Int? = 0) {
        var tileWidth = containerWidth
        let secondaryItemWidth = containerWidth / 2
        var tileHeight: CGFloat = secondaryItemWidth
        let secondaryItemHeight = tileHeight / 2
        var column = 0
        var position: TilePosition = .full

        let type = VFGDashboardCardType(rawValue: sectionType ?? "")
        switch type {
        case .dashboard:
            setupDashboardTileLayout()
        case .highlights, .highlightsTopInset:
            setupHighlightsTileLayout()
        default:
            tileHeight = customHeight ?? containerWidth
        }

        func setupDashboardTileLayout() {
            switch indexPath.row {
            case 0:
                tileWidth = containerWidth
                tileHeight += Constants.Dashboard.Layout.firstItemExtraHeight
            case 1:
                tileWidth = secondaryItemWidth
                position = .left
            case 2, 3:
                tileWidth = secondaryItemWidth
                tileHeight = secondaryItemHeight
                column = 1
                position = .right
            default:
                tileWidth = containerWidth
            }
        }

        func setupHighlightsTileLayout() {
            let sectionHightRatio = 0.76
            tileHeight = sectionHightRatio * secondaryItemWidth
            let count = itemsCount ?? 0
            let isOddNumberOfTiles = count % 2 > 0
            let isSectionLastTile = indexPath.row == count - 1
            let isRightTile = indexPath.row % 2 > 0

            if isOddNumberOfTiles, isSectionLastTile {
                tileWidth = containerWidth
            } else {
                if isRightTile {
                    column = 1
                }
                tileWidth = secondaryItemWidth
                position = column == 1 ? .right : .left
            }
        }
        self.init(size: CGSize(width: tileWidth, height: tileHeight), column: column, position: position)
    }
}
