//
//  VFGTileLayoutDelegate.swift
//  VFGMVA10
//
//  Created by Tomasz Czyżak on 23/06/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// Delegation protocol for *VFDashboardViewController* to handle its dashboard cards layout
protocol VFGTileLayoutDelegate: AnyObject {
    /// Discover section position
    var discoverSnapThreshold: CGFloat? { get set }
    /// Discover section position
    var refreshManger: VFGRefreshManager? { get }
    /// Return dashboard card layout for current index
    /// - Parameters:
    ///    - collectionView: *VFDashboardViewController* collection view
    ///    - indexPath: Dashboard card current index
    func collectionView(_ collectionView: UICollectionView, tileLayoutIndex indexPath: IndexPath) -> VFGTileLayout
    /// Return dashboard card Insets
    /// - Parameters:
    ///    - collectionView: *VFDashboardViewController* collection view
    ///    - indexPath: Dashboard card current index
    ///    - position: Tile position
    func collectionView(_ collectionView: UICollectionView, insetByAtIndex indexPath: IndexPath, position: VFGTileLayout.TilePosition) -> UIEdgeInsets
    /// Check if current section has title
    /// - Parameters:
    ///    - index: Current section index
    func checkSectionHasTitle(_ indexPath: IndexPath) -> Bool
    /// Return discover section index
    func discoverIndexInSections() -> Int?
    /// Return dashboard section index
    func dashboardIndexInSections() -> Int?
    /// Return current section type
    /// - Parameters:
    ///    - index: Current section index
    func typeForSection(at index: Int) -> String?
    /// Returns if header of specific section is visible or not
    func enableHeaderForSection(at index: Int) -> Bool?
    /// Returns if footer of specific section is visible or not
    func enableFooterForSection(at index: Int) -> Bool?
}
