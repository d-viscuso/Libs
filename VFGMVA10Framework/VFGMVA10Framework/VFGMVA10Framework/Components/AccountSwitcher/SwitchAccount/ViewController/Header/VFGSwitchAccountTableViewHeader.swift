//
//  VFGSwitchAccountTableViewHeader.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 12/19/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
import UIKit
/// *VFGSwitchAccountViewController* table view header
class VFGSwitchAccountTableViewHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var textlabel: VFGLabel!
    /// *VFGSwitchAccountViewController* table view header configuration
    /// - Parameters:
    ///    - text: Current header text
    func configureHeader(_ text: String, isMVA12: Bool = false ) {
        textlabel.text = text
        textlabel.accessibilityLabel = "\(text) section header title"
        if isMVA12 {
            textlabel.font = UIFont.vodafoneRegular(24)
            separatorView.isHidden = true
        }
    }
}
