//
//  VFGRemoveAccountView.swift
//  VFGMVA10Framework
//
//  Created by Adel Aref on 26/03/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// Delegate for remove account view.
protocol VFGRemoveAccountViewDelegate: AnyObject {
    /// Notifys delegate that Remove button did tap.
    func removeButtonDidPressed()
    /// Notifys delegate that back button did tap.
    func backButtonDidPressed()
}

class VFGRemoveAccountView: UIView {
    @IBOutlet weak var descriptionLabel: VFGLabel!
    @IBOutlet weak var primaryButton: VFGButton!
    @IBOutlet weak var secondaryButton: VFGButton!

    private var account: VFGAccount?
    weak var delegate: VFGRemoveAccountViewDelegate?

    func setup(delegate: VFGRemoveAccountViewDelegate, account: VFGAccount? = nil) {
        self.delegate = delegate
        self.account = account
        roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner])
        dropShadow(color: .black)
        setupUI()
    }

    private func setupUI() {
        let description = "remove_account_quick_action_subtitle".localized(bundle: .mva10Framework)
        let confirmButtonTitle = "remove_account_quick_action_confirm_button_title".localized(bundle: .mva10Framework)
        let backButtonTitle = "remove_account_quick_action_back_button" .localized(bundle: .mva10Framework)
        descriptionLabel.text = String(format: description, arguments: [account?.name ?? ""])
        primaryButton.setTitle(confirmButtonTitle, for: .normal)
        secondaryButton.setTitle(backButtonTitle, for: .normal)
    }

    @IBAction func primaryButtonDidPressed(_ sender: Any) {
        delegate?.removeButtonDidPressed()
    }

    @IBAction func secondaryButtonDidPressed(_ sender: Any) {
        delegate?.backButtonDidPressed()
    }
}

extension VFGRemoveAccountView: VFQuickActionsModel {
    func quickActionsProtocol(delegate: VFQuickActionsProtocol) {
    }

    func closeQuickAction() {
    }

    var quickActionsContentView: UIView {
        self
    }

    var quickActionsTitle: String {
        "remove_account_quick_action_title".localized(bundle: .mva10Framework)
    }

    var isCloseButtonHidden: Bool {
        false
    }

    var quickActionsStyle: VFQuickActionsStyle {
        .white
    }

    var shouldRaiseForKeyboard: Bool {
        true
    }
}
