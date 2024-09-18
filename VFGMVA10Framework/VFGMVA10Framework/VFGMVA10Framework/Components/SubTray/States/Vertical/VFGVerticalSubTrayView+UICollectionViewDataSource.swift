//
//  VFGVerticalSubTrayView+UICollectionViewDataSource.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 08/11/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit

extension VFGVerticalSubTrayView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.collectionView:
            return filteredAndExpandedItemsUIModels?.count ?? numberOfShimmerCells
        case tabsCollectionView:
            return filteredDataSource != nil ? categories.count : 0
        default:
            return 0
        }
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch collectionView {
        case self.collectionView:
            let shimmerCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: shimmerCellId,
                for: indexPath) as? VFGSubTrayShimmerCell
            if let subItem = filteredAndExpandedItemsUIModels?[indexPath.row].item {
                guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: verticalCellId,
                for: indexPath) as? VFGSubTrayCollectionViewCell else {
                    return VFGSubTrayCollectionViewCell()
                }
                if subItem.badge != nil {
                    badgeDelegates[indexPath.row] = cell
                }
                cell.setup(
                    item: subItem,
                    index: indexPath.row,
                    type: type,
                    isLocked: dataSource?.isLocked(item: subItem, for: self) ?? false,
                    isCustomizable: isSubTrayCustomizable,
                    isHighlighted: indexPath.row == highlightedItemIndex
                )
                shimmerCell?.stopShimmer()
                cell.customizeButtonActionClosure = {
                    subItem.customizeAction(
                        VFGManagerFramework.trayDelegate?.subTrayItemsActions(.customization(subItem), nil))
                }
                if itemShouldBeStreched(subItem, at: indexPath) {
                    cell.updateContainerTrailingContraint(with: cellWidth + strechedItemExtraSpace)
                } else {
                    cell.updateContainerTrailingContraint(with: 0)
                }
                return cell
            } else if let subItem = filteredAndExpandedItemsUIModels?[indexPath.row].expandedItem {
                guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: expandedCellId,
                for: indexPath) as? VFGSubTrayExpandedItemViewCell else { return UICollectionViewCell() }
                cell.itemContainerView.configure(model: subItem, delegate: self)
                cell.updateContainerTrailingContraint(with: -4)
                return cell
            } else {
                shimmerCell?.startShimmer()
                return shimmerCell ?? VFGSubTrayShimmerCell()
            }
        case tabsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: tabsCellId,
            for: indexPath) as? VFSubTrayCollectionViewTabsCell else {
                return VFSubTrayCollectionViewTabsCell()
            }
            let tabAction = TabAccessibilityCustomAction(
                name: "\(categories[indexPath.row]) tab selected",
                indexPath: indexPath,
                target: self,
                selector: #selector(selectTab))
            cell.tabAccessibilityCustomAction = tabAction
            return setupTabsCell(indexPath: indexPath, cell: cell)
        default:
            return UICollectionViewCell()
        }
    }
}
