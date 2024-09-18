//
//  VFGVerticalSubTrayView+UICollectionViewDelegate.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 08/11/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit

extension VFGVerticalSubTrayView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.collectionView:
            let hasExpandedItems = filteredAndExpandedItemsUIModels?[indexPath.row]
                .item?.hasExpandedItems ?? false

            if
                hasExpandedItems,
                let cell = collectionView.cellForItem(at: indexPath) as? VFGSubTrayCollectionViewCell {
                    if highlightedItemIndex == indexPath.row {
                        cell.updateOutlineUnselected()
                        highlightedItemIndex = nil
                    } else {
                        cell.updateOutlineSelected()
                        highlightedItemIndex = indexPath.row
                    }
            }
            let cell = collectionView.cellForItem(at: indexPath) as? VFGSubTrayCollectionViewCell
            cell?.updateContainerTrailingContraint(with: 0)
            guard let selectedItem = filteredAndExpandedItemsUIModels?[safe: indexPath.row]?.item else {
                return
            }
            selectedItem.action()
        case tabsCollectionView:
            let tabAction = TabAccessibilityCustomAction(
                name: "\(categories[indexPath.row]) tab selected",
                indexPath: indexPath,
                target: self,
                selector: #selector(selectTab)
            )
            selectTab(tabAction)
        default:
            break
        }
    }

    @objc func selectTab(_ sender: TabAccessibilityCustomAction) {
        // Reset highlighted Item
        highlightedItemIndex = nil
        var itemsToReload = [sender.indexPath]
        let previouslySelected = selectedTabIndexPath
        if previouslySelected != sender.indexPath {
            itemsToReload.append(previouslySelected)
        }
        selectedTabIndexPath = sender.indexPath
        selectedCategory = selectedTabIndexPath == IndexPath(row: 0, section: 0) ?
            .all : .other(categories[sender.indexPath.row])

        UIView.performWithoutAnimation {
            tabsCollectionView.reloadItems(at: itemsToReload)
            tabsCollectionView.scrollToItem(at: selectedTabIndexPath, at: .right, animated: true)
        }

        tabSelected()
        if !searchQurey.isEmpty {
            searchProducts(with: searchQurey, in: selectedCategory)
        }
    }
}
