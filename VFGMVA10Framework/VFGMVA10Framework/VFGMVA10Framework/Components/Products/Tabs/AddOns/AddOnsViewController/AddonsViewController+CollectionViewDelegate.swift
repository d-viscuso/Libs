//
//  AddonsViewController+CollectionViewDelegate.swift
//  VFGMVA10Framework
//
//  Created by Salma Ashour on 7/16/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
import UIKit

extension AddOnsViewController: UICollectionViewDataSource {
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let isLastCell = indexPath.row == addOnsViewModel?.numberOfMyProducts()

        if collectionView == addOnsProductsCollectionView {
            switch addOnsViewModel?.productContentState {
            case .loading:
                return dequeueAddOnsProductShimmerCell(collectionView, cellForItemAt: indexPath)
            case .populated:
                if isLastCell {
                    return dequeueAddOnsCVMCell(collectionView, cellForItemAt: indexPath)
                } else {
                    return dequeueAddOnsProductCell(collectionView, cellForItemAt: indexPath)
                }
            default:
                return UICollectionViewCell()
            }
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: addOnsTimelineCellId,
                    for: indexPath) as? AddOnsTimelineCell else {
                return UICollectionViewCell()
            }
            let product: AddOnsProductModel = timelineProducts[indexPath.row]
            let addOnPeriod = calculateAddonPeriod(product)
            cell.configure(product, addOnPeriod, isDailyView)
            addOnsTimelineCollectionView.sendSubviewToBack(timelineSeparatorsView)
            return cell
        }
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        numberOfSections
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if collectionView == addOnsProductsCollectionView {
            if addOnsViewModel?.productContentState == .loading {
                return 3
            } else if addOnsViewModel?.productContentState == .populated {
                return (addOnsViewModel?.numberOfAddOnsCVM() ?? 0) +
                    (addOnsViewModel?.numberOfMyProducts() ?? 0)
            } else {
                return 0
            }
        } else {
            return timelineProducts.count
        }
    }

    // MARK: - Helpers
    func setupAddOnsProductsCell() {
        let addOnsCell = UINib(nibName: addOnsProductCellId, bundle: Bundle.mva10Framework)
        addOnsProductsCollectionView.register(addOnsCell, forCellWithReuseIdentifier: addOnsProductCellId)
        addOnsProductsCollectionView.delegate = self
        addOnsProductsCollectionView.dataSource = self
    }

    func setupAddOnsTimelineProductsCell() {
        let addOnsCell = UINib(nibName: addOnsTimelineCellId, bundle: Bundle.mva10Framework)
        addOnsTimelineCollectionView.register(addOnsCell, forCellWithReuseIdentifier: addOnsTimelineCellId)
        addOnsTimelineCollectionView.delegate = self
        addOnsTimelineCollectionView.dataSource = self
    }

    func setupAddOnsCVMProductsCell() {
        let addOnsCell = UINib(nibName: addOnsCVMCellId, bundle: Bundle.mva10Framework)
        addOnsProductsCollectionView.register(addOnsCell, forCellWithReuseIdentifier: addOnsCVMCellId)
    }

    func setupAddOnsProductShimmerCell() {
        let addOnsShimmerCell = UINib(nibName: addOnsProductShimmerCellId, bundle: Bundle.mva10Framework)
        addOnsProductsCollectionView.register(addOnsShimmerCell, forCellWithReuseIdentifier: addOnsProductShimmerCellId)
    }
}

extension AddOnsViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == addOnsViewModel?.numberOfMyProducts()

        if collectionView == addOnsProductsCollectionView {
            if addOnsViewModel?.productContentState == .populated {
                if isLastCell {
                    return
                }
                navigateToRemoveORAddAddOn(with: addOnsViewModel?.myProduct(at: indexPath.row))
            }
        } else {
            if timelineProducts[indexPath.row].addonType != AddOnsTypeLocalize.myPlan.localizedString {
                navigateToRemoveORAddAddOn(with: timelineProducts[indexPath.row])
            }
        }
    }
}

extension AddOnsViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let isLastCell = indexPath.row == addOnsViewModel?.numberOfMyProducts()
        if collectionView == addOnsProductsCollectionView {
            if addOnsViewModel?.addOnCVM != nil, isLastCell {
                return CGSize(
                    width: addOnsProductsCollectionView.frame.width - cellPadding,
                    height: addOnsCVMCellHeight
                )
            } else {
                let cellWidth = collectionView.frame.width - cellPadding
                if addOnsViewModel?.productContentState == .loading {
                    return CGSize(width: cellWidth, height: cellHeight)
                }
                let sizingCell = getResizingAddOnsProductCell(at: indexPath)
                sizingCell.translatesAutoresizingMaskIntoConstraints = false
                sizingCell.widthAnchor.constraint(equalToConstant: cellWidth).isActive = true
                sizingCell.setNeedsLayout()
                sizingCell.layoutIfNeeded()
                let computedSize = sizingCell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                return CGSize(width: cellWidth, height: computedSize.height)
            }
        } else {
            return CGSize(
                width: addOnsProductsCollectionView.frame.width / 2 - cellPadding,
                height: Constants.AddOnsTimeline.timelineCurrentPlanCellHeight)
        }
    }
}

extension AddOnsViewController {
    func dequeueAddOnsProductShimmerCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> AddOnsProductShimmerCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: addOnsProductShimmerCellId,
            for: indexPath) as? AddOnsProductShimmerCell {
            cell.startShimmer()
            cell.accessibilityIdentifier = "ADshimmerCell\(indexPath.row)"
            return cell
        }
        return AddOnsProductShimmerCell()
    }

    func dequeueAddOnsCVMCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> AddOnsCVMCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: addOnsCVMCellId,
                for: indexPath) as? AddOnsCVMCell else {
            return AddOnsCVMCell()
        }
        if let addOnCVM = addOnsViewModel?.addOnCVM {
            cell.setupCell(with: addOnCVM)
            cell.delegate = self
        }
        return cell
    }

    func dequeueAddOnsProductCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> AddOnsProductCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: addOnsProductCellId,
                for: indexPath) as? AddOnsProductCell else {
            return AddOnsProductCell()
        }
        return getAddOnsProductCell(cell, at: indexPath)
    }

    func getResizingAddOnsProductCell(at indexPath: IndexPath) -> AddOnsProductCell {
        getAddOnsProductCell(at: indexPath)
    }

    func getAddOnsProductCell(_ cell: AddOnsProductCell? = nil, at indexPath: IndexPath) -> AddOnsProductCell {
        guard let product = addOnsViewModel?.myProduct(at: indexPath.item) else {
            return AddOnsProductCell()
        }
        guard let cell = cell else {
            return AddOnsProductCell.makeResizingAddOnsProductCell(for: product, isPromProduct: false)
        }
        cell.setupCell(with: product)
        cell.accessibilityIdentifier = "ADproductCell\(indexPath.item)"
        return cell
    }
}
