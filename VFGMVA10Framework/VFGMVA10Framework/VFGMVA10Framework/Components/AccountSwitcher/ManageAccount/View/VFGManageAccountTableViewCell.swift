//
//  VFGManageAccountTableViewCell.swift
//  VFGMVA10Framework
//
//  Created by Ayman Ata on 29/08/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// A delegate to handle actions from *VFGManageAccountTableViewCell*
protocol VFGManageAccountTableViewCellDelegate: AnyObject {
    /// Adds or edits given account's name.
    /// - Parameters:
    /// - account: An *VFGAccount* that will be edited.
    func editAddAccountName(_ account: VFGAccount?)
    /// Removes given account from user accounts.
    /// - Parameters:
    /// - account: An *VFGAccount* that should be removed.
    func removeAccount(_ account: VFGAccount?)
    /// Makes given account the default account.
    /// - Parameters:
    /// - account: An *VFGAccount* that should be marked as default.
    func makeAccountDefault(_ account: VFGAccount?)
}

class VFGManageAccountTableViewCell: UITableViewCell {
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var iconImageView: VFGImageView!
    @IBOutlet weak var profileIconLabel: VFGLabel!
    @IBOutlet weak var nameLabel: VFGLabel!
    @IBOutlet weak var msisdnLabel: VFGLabel!
    @IBOutlet weak var labelsStackView: UIStackView!
    @IBOutlet weak var editAccountButton: VFGButton!
    @IBOutlet weak var removeAccountButton: VFGButton!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var makeDefaultButton: VFGButton!
    @IBOutlet weak var makeDefaultLabel: VFGLabel!
    @IBOutlet weak var separatorView: UIView!
    weak var delegate: VFGManageAccountTableViewCellDelegate?
    private var currentAccount: VFGAccount?

    override func awakeFromNib() {
        super.awakeFromNib()
        let removeButtontitle = "remove_from_device_button_title".localized(bundle: .mva10Framework)
        removeAccountButton.setTitle(removeButtontitle, for: .normal)
        mainStackView.setCustomSpacing(20, after: buttonsStackView)
    }

    func configureCell(_ account: VFGAccount, isSelectedAccount: Bool = false, isLastCell: Bool) {
        self.currentAccount = account
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

        let addEditNameButtonTitle = account.name.first == nil ?
        "add_account_name_button_title" : "edit_account_button_title"
        editAccountButton.setTitle(addEditNameButtonTitle.localized(bundle: .mva10Framework), for: .normal)

        let checkBoxImage = VFGImage(named: isSelectedAccount ? "icCheckboxChecked" : "inactive")
        makeDefaultButton.setImage(checkBoxImage, for: .normal)

        let makeDefaultLabelText = isSelectedAccount ?
        "default_account_title_label" : "make_default_account_title_label"
        makeDefaultLabel.text = makeDefaultLabelText.localized(bundle: .mva10Framework)

        removeAccountButton.isHidden = isSelectedAccount
        separatorView.isHidden = isLastCell

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

    @IBAction func addEditAccountNameButtonTapped(_ sender: Any) {
        delegate?.editAddAccountName(currentAccount)
    }

    @IBAction func removeAccountButtonTapped(_ sender: Any) {
        delegate?.removeAccount(currentAccount)
    }

    @IBAction func makeAccountDefaultButtonTapped(_ sender: Any) {
        delegate?.makeAccountDefault(currentAccount)
    }
}
