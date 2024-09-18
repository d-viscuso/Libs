//
//  BalanceHistorySectionHeader.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 11/5/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class BalanceHistorySectionHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var dateLabel: VFGLabel!
    var date: String? {
        didSet {
            dateLabel.text = date
        }
    }
}
