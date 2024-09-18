//
//  VFGSubTrayExpandedRowView.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 21/10/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// Sub tray expanded view collection view cell container row view
class VFGSubTrayExpandedRowView: UIView {
    @IBOutlet weak var leftItemView: VFGSubTrayExpandedItemView!
    @IBOutlet weak var rightItemView: VFGSubTrayExpandedItemView!
    /// *VFGSubTrayExpandedRowView* configuration
    /// - Parameters:
    ///    - leftModel: Sub tray expanded view left item model
    ///    - rightModel: Sub tray expanded view right item model
    ///    - delegate: Delegation protocol for sub tray expanded view actions
    func configure(
        leftModel: VFGSubTrayExpandedItemModel,
        rightModel: VFGSubTrayExpandedItemModel?,
        delegate: VFGSubTrayExpandedItemDelegate?
    ) {
        leftItemView.configure(model: leftModel, delegate: delegate)
        if let rightModel = rightModel {
            rightItemView.configure(model: rightModel, delegate: delegate)
        } else {
            rightItemView.isHidden = true
        }
    }
}
