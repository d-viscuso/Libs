//
//  VFGMVA12SwitchAccountCell.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 04/08/2022.
//

import VFGMVA10Foundation
/// *VFGSwitchAccountViewController* table view cell
class VFGMVA12SwitchAccountCell: UITableViewCell {
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var iconImageView: VFGImageView!
    @IBOutlet weak var profileIconLabel: VFGLabel!
    @IBOutlet weak var msisdnLabel: VFGLabel?
    @IBOutlet weak var nameLabel: VFGLabel!
    @IBOutlet weak var accessoryImageView: VFGImageView!

    var isSelectedAccount = false
    /// *VFGSwitchAccountViewController* table view cell configuration
    /// - Parameters:
    ///    - account: Current cell account
    ///    - isSelectedAccount: Determine if current cell account is the selected account or not
    func configureCell(_ account: VFGAccount, isSelectedAccount: Bool = false) {
        self.isSelectedAccount = isSelectedAccount
        if let profileImage = VFGImage(named: account.imageName) {
            profileView.isHidden = false
            iconImageView.isHidden = false
            profileIconLabel.isHidden = true
            iconImageView.image = profileImage
        } else {
            iconImageView.isHidden = true
            profileIconLabel.isHidden = false
            if let char = account.name.first {
                profileView.isHidden = false
                profileIconLabel.text = String(char)
            } else {
                profileView.isHidden = true
            }
        }

        if isSelectedAccount {
            accessoryImageView.isHidden = false
            accessoryImageView.image = VFGFrameworkAsset.Image.icTickGreenSmall
        } else {
            accessoryImageView.isHidden = true
        }

        if !account.msisdn.isEmpty {
            msisdnLabel?.isHidden = false
            msisdnLabel?.text = account.msisdn
        } else {
            msisdnLabel?.isHidden = true
        }

        if !account.name.isEmpty {
            nameLabel.isHidden = false
            nameLabel.text = account.name
        } else {
            nameLabel.isHidden = true
        }
    }
}
