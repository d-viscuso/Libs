//
//  FullSpecificationsCell.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 19/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class FullSpecificationsCell: UITableViewCell {
    @IBOutlet weak var detailsLabel: VFGLabel!

    func configure(item: String?) {
        guard let text = item else { return }
        detailsLabel.text = text
    }
}
