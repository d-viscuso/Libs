//
//  VFGSwitchAccountTableViewCell.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 12/18/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// *VFGSwitchAccountViewController* table view cell
class VFGSwitchAccountTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: VFGImageView!
    @IBOutlet weak var nameLabel: VFGLabel!
    @IBOutlet weak var accessoryImageView: VFGImageView!
    @IBOutlet weak var topSeparator: UIView!

    var isSelectedAccount = false
    /// *VFGSwitchAccountViewController* table view cell configuration
    /// - Parameters:
    ///    - account: Current cell account
    ///    - isSelectedAccount: Determine if current cell account is the selected account or not
    func configureCell(_ account: VFGAccount, isSelectedAccount: Bool = false) {
        self.isSelectedAccount = isSelectedAccount
        nameLabel.text = account.name
        iconImageView.image = VFGImage(named: account.imageName ?? "icAdmin")

        if isSelectedAccount {
            accessoryImageView.image = VFGFrameworkAsset.Image.icTick
        } else {
            accessoryImageView.image = VFGFrameworkAsset.Image.icChevronRightRed
        }
        setupVoiceOverAccessibility()
    }
}
