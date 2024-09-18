//
//  VFGVerticalSubTrayView+UICollectionViewDelegateFlowLayout.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 08/11/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit

extension VFGVerticalSubTrayView: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        switch collectionView {
        case self.collectionView:
            let item = filteredAndExpandedItemsUIModels?[indexPath.row].item
            let isExpandedItem = filteredAndExpandedItemsUIModels?[indexPath.row].isExpandedItem ?? false
            var width: CGFloat = 0
            if itemShouldBeStreched(item, at: indexPath) {
                width = collectionView.bounds.width
            } else {
                width = cellWidth
            }
            if isExpandedItem {
                return CGSize(width: cellWidth, height: expandableItemCellHeight)
            } else {
                let cellHeight = cellWidth / cellWidthToHeightRatio
                return CGSize(width: width, height: cellHeight)
            }
        case tabsCollectionView:
            return CGSize(width: tabsCollectionView.frame.width / 3.6, height: tabsCollectionView.frame.height)
        default:
            return .zero
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if hasExpandedItems {
            return 18
        }
        return isSubTrayCustomizable ? 30 : 11
    }
}
