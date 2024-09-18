//
//  VFGHorizontalSubTrayView+ExpandedView.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 22/10/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGHorizontalSubTrayView {
    /// Handle expanding sub tray item view
    /// - Parameters:
    ///    - item: Sub tray item to be expanded
    ///    - expandedItems: Array list of item expanded items
    ///    - index: Number of item in sub tray to be expanded
    ///    - completion: A closure to perform actions after expanding sub tray item
    func showExpandedView(
        for item: VFGSubTrayItem,
        with expandedItems: [VFGSubTrayExpandedItemModel],
        at index: Int,
        completion: (() -> Void)? = nil
    ) {
        guard let expandedContentView: VFGSubTrayExpandedView = UIView.loadXib(bundle: .mva10Framework),
            let expandedView = expandedView else { return }
        expandedView.removeSubviews()
        let cellsSpacing: CGFloat = 12
        expandedContentView.configure(items: expandedItems, delegate: self)
        expandedContentView.translatesAutoresizingMaskIntoConstraints = false
        expandedView.addSubview(expandedContentView)
        let index = min(index, (dataModel?.items?.count ?? 0) - 2) // 2 to get the item before the last item
        let firstItemLeadingSpace: CGFloat = 16
        let leadingSpace: CGFloat =
            firstItemLeadingSpace + (CGFloat(index) * cellWidth) + (CGFloat(index) * cellsSpacing)
        expandedContentView.leadingAnchor.constraint(
            equalTo: expandedView.leadingAnchor,
            constant: leadingSpace).isActive = true
        expandedContentView.topAnchor.constraint(equalTo: expandedView.topAnchor).isActive = true
        expandedContentView.widthAnchor.constraint(equalToConstant: (cellWidth * 2) + cellsSpacing).isActive = true
        expandedContentView.layoutIfNeeded()
        let scrollThreshold: CGFloat = 170
        let expandedContentHeight: CGFloat = min(expandedContentView.itemsStackView.bounds.height, scrollThreshold)
        expandedViewHeightConstraint?.constant = expandedContentHeight
        height = mainHeight + expandedContentHeight
        expandedScrollView?.synchronize(with: collectionView)
        expandedContentView.bottomAnchor.constraint(equalTo: expandedView.bottomAnchor).isActive = true
        UIView.animate(withDuration: 0.2, animations: {
            self.delegate?.updateSubtrayHeight(for: self)
        }, completion: { _ in
            completion?()
        })
    }
    /// Handle collapsing sub tray item view
    /// - Parameters:
    ///    - completion: A closure to perform actions after collapsing sub tray item
    func hideExpandedView(completion: (() -> Void)? = nil) {
        highlightedItemIndex = nil
        height = mainHeight
        expandedViewHeightConstraint?.constant = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.delegate?.updateSubtrayHeight(for: self)
        }, completion: { _ in
            self.expandedView?.removeSubviews()
            completion?()
        })
    }
}

extension VFGHorizontalSubTrayView: VFGSubTrayExpandedItemDelegate {
    func itemDidPress(_ view: VFGSubTrayExpandedItemView, _ model: VFGSubTrayExpandedItemModel) {
        guard let highlightedItemIndex = highlightedItemIndex,
            let subItem = dataModel?.items?[highlightedItemIndex] else {
            return
        }
        subItem.expandedItemAction(
            VFGManagerFramework.trayDelegate?.subTrayItemsActions(.expandedItem(subItem, model), self)
        )
    }
}
