//
//  ProductSwitcherCardView+UICollectionView.swift
//  VFGMVA10Framework
//
//  Created by Mayar Soliman, Vodafone on 31/10/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ProductSwitcherCardView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewModel?.state {
        case .loading:
            return 3
        case .error:
            return 1
        default:
            return viewModel?.numberOfCards ?? 0
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel?.state {
        case .loading:
            return getShimmerCell(collectionView, indexPath)
        case .error:
            return getErrorCell(collectionView, indexPath)
        default:
            return getProductsCell(collectionView, indexPath)
        }
    }

    func getProductsCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        if let cardItem = viewModel?.getCardItem(for: indexPath) as? ProductSwitcherCardItemModel,
        let cell = collectionView.cellDequeue(with: ProductSwitcherCollectionCell.self, indexPath: indexPath),
        let isEditNameEnabled = viewModel?.isEditNameEnabled,
        let isStarredEnabled = viewModel?.isStarredEnabled {
            cell.setCardItem(
                itemModel: cardItem,
                for: getCellWidth(),
                isEditNameEnabled: isEditNameEnabled,
                isStarredEnabled: isStarredEnabled)
            return cell
        }
        if let noResultCellId = viewModel?.getCardItem(for: indexPath) as? String,
        noResultCellId == ProductSwitcherNoResultCell.reuseIdentifier,
        let cell = collectionView.cellDequeue(with: ProductSwitcherNoResultCell.self, indexPath: indexPath) {
            guard let query = searchView?.searchTextField.text,
                let suggestion = viewModel?.getSuggestedQuery(for: query)
            else {
                cell.suggestQuery("", delegate: self)
                return cell
            }
            cell.suggestQuery(suggestion, delegate: self)
            return cell
        }
        return UICollectionViewCell()
    }

    func getErrorCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        guard let errorCell = collectionView.cellDequeue(with: ProductSwitchErrorCell.self, indexPath: indexPath),
            let viewModel = viewModel,
            let errorModel = viewModel.errorModel else { return UICollectionViewCell() }
        hideStackView()
        errorCell.configure(errorModel: errorModel, tryAgainClosure: viewModel.tryAgainClosure)
        errorCell.configureShadow()
        return errorCell
    }

    func getShimmerCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        guard let shimmerCell = collectionView.cellDequeue(
            with: ProductSwitcherShimmerCell.self,
            indexPath: indexPath) else { return UICollectionViewCell() }
        hideStackView()
        shimmerCell.startShimmer()
        shimmerCell.configureShadow()
        return shimmerCell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView == categoriesFilterView.filterCollectionView,
            let cell = collectionView.cellForItem(at: indexPath) as? VFGFilterCell
        else { return }
        filterCardsWith(categoryName: cell.categoryType)
    }

    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard collectionView == categoriesFilterView.filterCollectionView,
            let cell = collectionView.cellForItem(at: indexPath) as? VFGFilterCell
        else { return }
        resetFiltering(for: cell.categoryType)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProductSwitcherCardView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case productsCollectionView:
            return CGSize(width: getCellWidth(), height: cellHeight)
        case categoriesFilterView.filterCollectionView:
            return CGSize(width: getCellWidth(), height: categoryFilterHeight)
        default:
            return .zero
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if viewModel?.numberOfCards ?? 0 > 1 {
            return cardMargin
        }
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: cardMargin, bottom: 0, right: cardMargin)
    }

    func getCellWidth() -> CGFloat {
        var cellWidth: CGFloat = 0
        if viewModel?.state == .error {
            return UIScreen.main.bounds.size.width - (2 * cardMargin)
        }
        if viewModel?.numberOfCards ?? 0 > 1 {
            productsCollectionView.isScrollEnabled = true
            cellWidth = UIScreen.main.bounds.size.width - (5 * cardMargin)
        } else {
            productsCollectionView.isScrollEnabled = false
            cellWidth = UIScreen.main.bounds.size.width - (2 * cardMargin)
        }
        return cellWidth
    }
}
