//
//  VFGShopViewModel.swift
//  VFGMVA10Framework
//
//  Created by Ayman Ata on 25/01/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import Foundation

/// **VFGShopViewModel** is the view-model that contains required data to make VFGShopViewController works properly.
public class VFGShopViewModel {
    private var model: VFGShopModel
    public init(model: VFGShopModel) {
        self.model = model
    }

    let rightLeftInsets: CGFloat = 16
    let inbetweenSpace: CGFloat = 8
    let spaceBetweenCells: CGFloat = 16
    let topInset: CGFloat = 14
    let bottomInset: CGFloat = 40

    var visibleCells: CGFloat {
        scrollDirection == .vertical ? 2 : 2.4
    }
    var cellWidth: CGFloat {
        (UIScreen.main.bounds.width - (rightLeftInsets * 2 + inbetweenSpace)) / visibleCells
    }
    var cellHeight: CGFloat {
        let topMargin: CGFloat = 8
        let backgrounfViewHeight: CGFloat = 136
        let imageViewHeight: CGFloat = 104
        return topMargin + backgrounfViewHeight + imageViewHeight / 2
    }

    var scrollDirection: UICollectionView.ScrollDirection {
        model.shopViewType == .vertical ? .vertical : .horizontal
    }

    var numberOfItems: Int {
        model.shopItems?.count ?? 0
    }

    public var overlayHeight: CGFloat {
        let headerHeight: CGFloat = 40
        let topBottomInsets: CGFloat = 60
        guard scrollDirection != .horizontal else {
            return cellHeight + headerHeight + topBottomInsets
        }
        let numberOfRows = ceil(Double(numberOfItems) / 2)
        let spaceBetweenRows = CGFloat(numberOfRows - 1) * inbetweenSpace
        let totlaHeight = CGFloat(numberOfRows) * cellHeight + spaceBetweenRows + headerHeight + topBottomInsets
        return totlaHeight
    }

    func modelAt(index: IndexPath) -> VFGShopItemModel? {
        guard index.item < model.shopItems?.count ?? 0 else { return nil }
        return model.shopItems?[index.item]
    }
}
