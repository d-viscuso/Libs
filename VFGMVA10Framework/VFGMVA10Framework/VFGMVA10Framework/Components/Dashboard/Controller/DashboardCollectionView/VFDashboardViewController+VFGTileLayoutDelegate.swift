//
//  VFDashboardViewController+VFGTileLayoutDelegate.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 11/09/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
import UIKit

extension VFDashboardViewController: VFGTileLayoutDelegate {
    var refreshManger: VFGRefreshManager? {
        dashboardDataSource?.refreshManager
    }

    func collectionView(_ collectionView: UICollectionView, tileLayoutIndex indexPath: IndexPath) -> VFGTileLayout {
        let insets = collectionView.contentInset
        let availableWidth = collectionView.bounds.width - (insets.left + insets.right)
        let itemModel = dashboardDataSource?.cardAtIndex(indexPath: indexPath)
        let sectionType = dashboardDataSource?.typeForSection(at: indexPath.section)
        let sectionItemsCount = dashboardDataSource?.numberOfItemsAtSection(section: indexPath.section)
        return VFGTileLayout(
            indexPath: indexPath,
            containerWidth: availableWidth,
            customHeight: itemModel?.itemHeight,
            sectionType: sectionType,
            itemsCount: sectionItemsCount
        )
    }

    func collectionView(_ collectionView: UICollectionView, insetByAtIndex indexPath: IndexPath, position: VFGTileLayout.TilePosition) -> UIEdgeInsets {
        let itemModel = dashboardDataSource?.cardAtIndex(indexPath: indexPath)
        let padding = itemModel?.padding ?? 0
        var topInset = Constants.dashboardCollectionPadding
        var leftInset = Constants.dashboardCollectionPadding + padding
        var bottomInset = Constants.dashboardCollectionPadding
        var rightInset = Constants.dashboardCollectionPadding + padding

        switch dashboardDataSource?.typeForSection(at: indexPath.section) {
        case VFGDashboardCardType.highlights.rawValue:
            setHighlightsSectionItemInsets()
        case VFGDashboardCardType.highlightsTopInset.rawValue:
            setHighlightsSectionItemInsets()
        default:
            break
        }

        func setHighlightsSectionItemInsets() {
            topInset = Constants.dashboardCollectionPadding / 2
            bottomInset = Constants.dashboardCollectionPadding / 2
            switch position {
            case .left:
                leftInset = Constants.dashboardCollectionPadding
                rightInset = Constants.dashboardCollectionPadding / 2
            case .right:
                leftInset = Constants.dashboardCollectionPadding / 2
                rightInset = Constants.dashboardCollectionPadding
            case .full:
                leftInset = Constants.dashboardCollectionPadding
                rightInset = Constants.dashboardCollectionPadding
            }
        }

        return UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    }

    func checkSectionHasTitle(_ indexPath: IndexPath) -> Bool {
        guard let datasource = dashboardDataSource else { return false }
        let dataSourceContainSections = datasource.numberOfSections() > 0
        let sectionTitleNotEmpty = !(datasource.titleForSection(at: indexPath.section).isEmpty)
        let sectionsShimmring = datasource.state == .loading
        return (dataSourceContainSections && sectionTitleNotEmpty) || sectionsShimmring
    }

    func discoverIndexInSections() -> Int? {
        guard let datasource = dashboardDataSource else { return nil }
        return datasource.discoverIndexInSections()
    }

    func dashboardIndexInSections() -> Int? {
        guard let datasource = dashboardDataSource else { return nil }
        return datasource.dashboardIndexInSections()
    }

    func typeForSection(at index: Int) -> String? {
        guard let datasource = dashboardDataSource else { return "" }
        return datasource.typeForSection(at: index)
    }

    func enableHeaderForSection(at index: Int) -> Bool? {
        dashboardDataSource?.enableHeaderForSection(at: index)
    }

    func enableFooterForSection(at index: Int) -> Bool? {
        dashboardDataSource?.enableFooterForSection(at: index)
    }
}
