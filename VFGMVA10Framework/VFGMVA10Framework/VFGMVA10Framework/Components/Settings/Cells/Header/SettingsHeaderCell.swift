//
//  SettingsHeaderCell.swift
//  VFGMVA10Group
//
//  Created by Mohamed Mahmoud Zaki on 7/1/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
/// *SettingsViewController* table view header cell
class SettingsHeaderCell: UITableViewCell {
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var title: VFGLabel!
    @IBOutlet weak var headerImageView: VFGImageView!
    @IBOutlet weak var subTitle: VFGLabel!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!

    /// setup cell
    func setup(title: String? = nil, subTitle: String? = nil, headerImageView: UIImage? = nil) {
        self.title.text = title
        self.subTitle.text = subTitle
        self.headerImageView.image = headerImageView
        setAccessibilityForVocieOver()
    }
}

extension SettingsHeaderCell {
    /// set accessibility for vocie over
    func setAccessibilityForVocieOver() {
        title.accessibilityLabel = title.text
        subTitle.accessibilityLabel = subTitle.text
    }
}
