//
//  VFGTopUpSomeoneElseViewModel.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Zaki on 09/03/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

protocol VFGTopUpSomeoneElseProtocol: AnyObject {
    func navigateToInitial(childAccountIndex: Int)
    func navigateToInitialTopUp(contactNumber: String)
    func nextAction(contactNumber: String)
    func validateMobileNumber(number: String) -> Bool
    func shouldScroll(height: CGFloat)
    func contactButtonDidPress()
}

class VFGTopUpSomeoneElseViewModel {
    var sectionTitle = ""
    var nextButtonTitle = ""
    var newRecipentTitle = ""
    var textfieldPlaceHolder = ""
    var textfieldHeaderTtitle = ""
    var textfieldErrorTitle = ""
    var isOpenContactsGranted = false
    var accounts: [VFGAccount] = []
    var topUpStatus: TopUpStatus = .topUpSomeOneElse
    weak var initialTopDelegate: VFGTopUpProtocol?
    var validation: VFGContactNumberValidatorProtocol?
    var customView: UIView?
    var phoneNumberMaxLenght: Int? {
        validation?.phoneNumberMaxLenght
    }

    weak var delegate: VFGTopUpStateInternalProtocol?
    init(
        delegate: VFGTopUpStateInternalProtocol?,
        initialTopDelegate: VFGTopUpProtocol?,
        customView: UIView?
    ) {
        self.delegate = delegate
        self.initialTopDelegate = initialTopDelegate
        self.validation = initialTopDelegate?.validateMobileNumber
        self.customView = customView
        setupLocalization()
        prepareChildAccounts()
    }

    func setupLocalization() {
        sectionTitle = VFGUser.shared.relatedAccount.isEmpty ?
            "top_up_someone_else_new_recipient_title".localized(bundle: Bundle.mva10Framework) :
            "top_up_someone_else_section_title".localized(bundle: Bundle.mva10Framework)
        nextButtonTitle = "top_up_someone_else_next_button_title".localized(bundle: Bundle.mva10Framework)
        newRecipentTitle = "top_up_someone_else_new_recipient_title".localized(bundle: Bundle.mva10Framework)
        textfieldPlaceHolder = "top_up_someone_else_new_recipient_placeholder".localized(bundle: Bundle.mva10Framework)
        textfieldHeaderTtitle = "top_up_someone_else_new_recipient_header_title".localized(
            bundle: Bundle.mva10Framework)
        textfieldErrorTitle = "top_up_someone_else_new_recipient_error_title".localized(bundle: Bundle.mva10Framework)
    }

    func prepareChildAccounts() {
        if VFGUser.shared.type == .payG {
            accounts.append(VFGAccount(
                name: "sub_tray_my_phone_title".localized(bundle: Bundle.mva10Framework),
                imageName: "phone_image",
                msisdn: initialTopDelegate?.model?.msisdn ?? ""))
        }
        if !VFGUser.shared.relatedAccount.isEmpty {
            accounts.append(contentsOf: VFGUser.shared.relatedAccount)
        }
    }
}

extension VFGTopUpSomeoneElseViewModel: VFQuickActionsModel {
    func closeQuickAction() {
        delegate?.dismiss()
    }

    func quickActionsProtocol(delegate: VFQuickActionsProtocol) {}

    var quickActionsTitle: String {
        "top_up_someone_else_quick_action_title".localized(bundle: Bundle.mva10Framework)
    }

    var quickActionsContentView: UIView {
        guard let topUpSomeoneElseView: VFGTopUpSomeoneElseView =
        VFGTopUpSomeoneElseView.loadXib(bundle: Bundle.mva10Framework) else {
            return UIView()
        }
        topUpSomeoneElseView.isOpenContactsGranted = isOpenContactsGranted
        topUpSomeoneElseView.someoneElseDelegate = self
        topUpSomeoneElseView.configure(with: self)
        return topUpSomeoneElseView
    }

    var quickActionsStyle: VFQuickActionsStyle {
        .white
    }
}

extension VFGTopUpSomeoneElseViewModel: VFGTopUpSomeoneElseProtocol {
    func navigateToInitial(childAccountIndex: Int) {
        if VFGUser.shared.type == .payG, childAccountIndex == 0 {
            topUpStatus = .topUpMine
        }
        delegate?.navigateToInitialTopUp(
            childAccount: accounts[childAccountIndex],
            topUpStatus: topUpStatus)
    }

    func navigateToInitialTopUp(contactNumber: String) {
        delegate?.navigateToInitialTopUp(contactNumber: contactNumber)
    }

    func nextAction(contactNumber: String) {
        delegate?.navigateToInitialTopUp(contactNumber: contactNumber)
    }

    func validateMobileNumber(number: String) -> Bool {
        if let mobileNumberValidator = validation {
            return mobileNumberValidator.validateMobileNumber(text: number)
        }
        return false
    }

    func shouldScroll(height: CGFloat) {
        delegate?.shouldScrollContent(height: height)
    }

    func contactButtonDidPress() {
        delegate?.contactButtonDidPress()
    }
}
