//
//  VerticalPickerCellView.swift
//  VFGMVA10Group
//
//  Created by Mohamed Mahmoud Zaki on 7/30/19.
//  Copyright © 2019 Mohamed Mahmoud Zaki. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VerticalPickerCellView: UIView {
    @IBOutlet weak var label: VFGLabel!
    @IBOutlet weak var giftImageView: VFGImageView!
    @IBOutlet weak var giftImageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightGiftImageView: VFGImageView!
    @IBOutlet weak var rightGiftImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftGiftImageWidthConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        if #available(iOS 14.0, *) {
            // Fix cropped imageView caused by new default margins
            giftImageViewLeadingConstraint.constant = Constants.TopUp.os14DefaultMargins
        }
    }
}
