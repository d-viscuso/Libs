//
//  VFGContactsSectionHeaderView.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 27/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFGContactsSectionHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: VFGLabel!

    func setup(title: String?) {
        titleLabel.text = title
        titleLabel.accessibilityLabel = title
    }
}
