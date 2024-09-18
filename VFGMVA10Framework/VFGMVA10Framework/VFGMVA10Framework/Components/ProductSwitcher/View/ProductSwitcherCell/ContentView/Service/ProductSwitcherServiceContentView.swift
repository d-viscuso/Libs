//
//  ProductSwitcherContentView.swift
//  VFGMVA10Framework
//
//  Created by Loodos on 9/2/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

class ProductSwitcherServiceContentView: UIView {
    @IBOutlet weak var iconImageView: VFGImageView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var descLabel: VFGLabel!

    func setItemModel(_ itemModel: ProductSwitcherCardItemModel) {
        guard itemModel.type == .service,
            let contentItem = itemModel.contentItems.first
        else { return }
        iconImageView.image = contentItem.icon
        titleLabel.text = contentItem.title
        descLabel.text = contentItem.desc
    }
}
