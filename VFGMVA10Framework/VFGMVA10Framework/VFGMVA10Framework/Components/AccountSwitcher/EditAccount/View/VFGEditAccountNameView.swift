//
//  VFGEditAccountNameView.swift
//  VFGMVA10Framework
//
//  Created by Ayman Ata on 15/12/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// Delegate for edit account name view.
protocol VFGEditAccountNameViewDelegate: AnyObject {
    /// Notifys delegate that save button did tap.
    /// - Parameter name: The new name that user wants for this account.
    func saveButtonDidTap(withName name: String)
    /// Notifys delegate that back button did tap.
    func backButtonDidTap()
}

class VFGEditAccountNameView: UIView {
    private var account: VFGAccount?
    weak var delegate: VFGEditAccountNameViewDelegate?

    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var nameTextField: VFGTextField!
    @IBOutlet weak var backButton: VFGButton!
    @IBOutlet weak var saveButton: VFGButton!

    func setupWith(account: VFGAccount) {
        self.account = account
        nameTextField.textFieldText = account.name
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        nameTextField.delegate = self
        addKeyboardDismissHandler()
    }

    @IBAction func saveButtonDidPress(_ sender: Any) {
        delegate?.saveButtonDidTap(withName: nameTextField.textFieldText)
    }

    @IBAction func backButtonDidPress(_ sender: Any) {
        delegate?.backButtonDidTap()
    }

    private func setupUI() {
        let saveButtonTitle = "edit_account_quick_action_save_button_title".localized(bundle: .mva10Framework)
        let backButtonTitle = "edit_account_name_back_button" .localized(bundle: .mva10Framework)
        titleLabel.text = "edit_account_quick_action_subtitle".localized(bundle: .mva10Framework)
        saveButton.setTitle(saveButtonTitle, for: .normal)
        saveButton.isEnabled = false
        backButton.setTitle(backButtonTitle, for: .normal)
        nameTextField.changeBorderColor(to: .VFGGreyDividerFive)
        nameTextField.textFieldRightIcon = nil
    }
}

extension VFGEditAccountNameView: VFGTextFieldProtocol {
    func vfgTextFieldDidBeginEditing(_ vfgTextField: VFGMVA10Foundation.VFGTextField) {
    }

    func vfgTextFieldDidEndEditing(_ vfgTextField: VFGMVA10Foundation.VFGTextField) {
    }

    func vfgTextFieldRightButtonClicked(_ vfgTextField: VFGMVA10Foundation.VFGTextField) {
    }

    func vfgTextFieldDidChange(_ vfgTextField: VFGTextField, text: String) {
        if text.isEmpty || (text == account?.name) {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
}

extension VFGEditAccountNameView: VFQuickActionsModel {
    func quickActionsProtocol(delegate: VFQuickActionsProtocol) {
    }

    func closeQuickAction() {
    }

    var quickActionsContentView: UIView {
        self
    }

    var quickActionsTitle: String {
        "edit_account_quick_action_title".localized(bundle: .mva10Framework)
    }

    var isCloseButtonHidden: Bool {
        true
    }

    var quickActionsStyle: VFQuickActionsStyle {
        .white
    }

    var shouldRaiseForKeyboard: Bool {
        true
    }
}
