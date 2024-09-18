//
//  FullSpecificationsHeaderCell.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 21/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class FullSpecificationsHeaderCell: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: VFGLabel!

    func configure(title: String) {
        titleLabel.text = title
    }
}
