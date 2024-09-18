//
//  BalanceHistoryViewController+SetupCollectionCells.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 01/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension BalanceHistoryViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? VFGFilterCell else {
            return
        }
        if filterView?.selectedCategories.first ?? "" == BalanceHistoryLocalize.all.localizedString {
            deselectItem(collectionView, indexPath: IndexPath(item: 0, section: 0))
            filterView?.selectedCategories.removeFirst()
        }

        if filterView?.selectedCategories.contains(BalanceHistoryLocalize.all.localizedString) ?? false {
            let allIndexPath = IndexPath(item: 0, section: 0)
            deselectItem(collectionView, indexPath: allIndexPath)
            filterView?.selectedCategories = []
        }

        if cell.categoryType == BalanceHistoryLocalize.all.localizedString {
            for index in 1..<collectionView.numberOfItems(inSection: 0) {
                deselectItem(collectionView, indexPath: IndexPath(item: index, section: 0))
            }
            filterView?.selectedCategories = []
        }

        filterView?.selectedCategories.append(cell.categoryType)
        filterView.selectCell(at: indexPath)
        historyViewModel?.filter(with: filterView?.selectedCategories ?? [])
        return
    }

    func deselectItem(_ collectionView: UICollectionView, indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.isSelected = false
        collectionView.deselectItem(at: indexPath, animated: false)
    }

    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? VFGFilterCell else {
            return
        }
        if collectionView == filterView?.filterCollectionView {
            filterView?.selectedCategories.removeAll { addOnType in
                addOnType == cell.categoryType
            }

            if filterView?.selectedCategories.isEmpty ?? false {
                let allIndexPath = IndexPath(item: 0, section: 0)
                collectionView.cellForItem(at: allIndexPath)?.isSelected = true
                filterView?.selectedCategories = [BalanceHistoryLocalize.all.localizedString]
            }

            historyViewModel?.filter(with: filterView?.selectedCategories ?? [])
        }
    }
}
