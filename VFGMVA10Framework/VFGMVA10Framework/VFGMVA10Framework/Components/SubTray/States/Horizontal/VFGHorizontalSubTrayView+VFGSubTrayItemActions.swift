//
//  VFGHorizontalSubTrayView+VFGSubTrayItemActions.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 24/10/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGHorizontalSubTrayView: VFGSubTrayItemActions {
    public func expand(_ item: VFGSubTrayItem, completion: (() -> Void)?) {
        highlightedItemIndex = dataModel?.items?.firstIndex { $0 == item }
        guard let highlightedIndex = highlightedItemIndex else { return }

        if let cell = collectionView?.cellForItem(
            at: IndexPath(
                row: highlightedIndex,
                section: 0)) as? VFGSubTrayCollectionViewCell {
            cell.updateOutlineSelected()
        }
        let highlightedIndexPath = IndexPath(row: highlightedIndex, section: 0)
        let nextIndexPath = IndexPath(row: min(highlightedIndex + 1, (dataModel?.items?.count ?? 0) - 1), section: 0)
        if !(collectionView?.fullyVisibleCellsIndexPaths().contains(nextIndexPath) ?? false) ||
            !(collectionView?.fullyVisibleCellsIndexPaths().contains(highlightedIndexPath) ?? false) {
            scrollDidFinishAction = { [weak self] in
                self?.showExpandedView(
                    for: item,
                    with: item.expandedItems ?? [],
                    at: highlightedIndex,
                    completion: completion)
            }
            collectionView?.scrollToItem(
                at: IndexPath(row: highlightedIndex, section: 0),
                at: .left,
                animated: true)
        } else {
            showExpandedView(for: item, with: item.expandedItems ?? [], at: highlightedIndex, completion: completion)
        }
    }

    public func collapse(_ item: VFGSubTrayItem, completion: (() -> Void)?) {
        hideExpandedView(completion: completion)
    }

    public func isItemExpanded(_ item: VFGSubTrayItem) -> Bool {
        if let highlightedIndex = highlightedItemIndex,
            dataModel?.items?[highlightedIndex] == item {
            return true
        }
        return false
    }
}
