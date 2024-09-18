//
//  VFGSubTrayExpandedView.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 21/10/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// Sub tray expanded view collection view cell container view
class VFGSubTrayExpandedView: UIView {
    @IBOutlet weak var itemsStackView: UIStackView!
    weak var delegate: VFGSubTrayExpandedItemDelegate?
    /// *VFGSubTrayExpandedView* configuration
    /// - Parameters:
    ///    - items: Array list of sub tray expanded view items data
    ///    - delegate: Delegation protocol for sub tray expanded view actions
    func configure(
        items: [VFGSubTrayExpandedItemModel],
        delegate: VFGSubTrayExpandedItemDelegate?
    ) {
        self.delegate = delegate
        stride(from: 0, to: items.endIndex, by: 2).forEach {
            guard let rowView: VFGSubTrayExpandedRowView = UIView.loadXib(bundle: .mva10Framework) else { return }
            rowView.configure(
                leftModel: items[$0],
                rightModel: $0 < items.index(before: items.endIndex) ? items[$0.advanced(by: 1)] : nil,
                delegate: self)
            itemsStackView.addArrangedSubview(rowView)
        }
    }
}

extension VFGSubTrayExpandedView: VFGSubTrayExpandedItemDelegate {
    func itemDidPress(_ view: VFGSubTrayExpandedItemView, _ model: VFGSubTrayExpandedItemModel) {
        itemsStackView.arrangedSubviews.forEach { subView in
            guard let rowView = subView as? VFGSubTrayExpandedRowView else { return }
            rowView.leftItemView.updateOutlineUnselected()
            rowView.rightItemView.updateOutlineUnselected()
        }
        view.updateOutlineSelected()
        delegate?.itemDidPress(view, model)
    }
}
