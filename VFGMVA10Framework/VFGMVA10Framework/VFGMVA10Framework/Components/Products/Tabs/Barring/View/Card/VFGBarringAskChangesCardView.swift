//
//  VFGBarringAskChangesCardView.swift
//  VFGMVA10Framework
//
//  Created by Trachani, Vasiliki, Vodafone on 20/5/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// Barring ask changes card view.
class VFGBarringAskChangesCardView: VFQuickActionsModel {
    weak var delegate: VFQuickActionsProtocol?
    var permissionViewModel: VFGBarringItemViewModel?
    var confirmAction: () -> Void
    var titlesModel: VFGTitlesModel?

    init(
        confirmAction: @escaping () -> Void,
        permissionViewModel: VFGBarringItemViewModel?
    ) {
        self.confirmAction = confirmAction
        self.permissionViewModel = permissionViewModel
    }

    public var quickActionsTitle: String {
        return "barring_ask_changes_title".localized(bundle: .mva10Framework)
    }

    public var quickActionsStyle: VFQuickActionsStyle {
        .white
    }

    public var isCloseButtonHidden: Bool {
        true
    }

    public var quickActionsContentView: UIView {
        guard let confirmationView: VFGTwoActionsView = UIView.loadXib(bundle: Bundle.foundation) else {
            return UIView()
        }
        confirmationView.delegate = self
        configureConfirmationView(confirmationView)
        return confirmationView
    }

    func configureConfirmationView(_ confirmationView: VFGTwoActionsView) {
        let description = permissionViewModel?.askChangesViewModel?.description
        let moreDetails = permissionViewModel?.askChangesViewModel?.moreDetails
        let primaryButtonTitle = "barring_ask_changes_confirmation_button".localized(bundle: .mva10Framework)
        let secondaryButtonTitle =
        "barring_ask_changes_cancel_button".localized(bundle: .mva10Framework)
        titlesModel = VFGTitlesModel(
            description: description,
            moreDetails: moreDetails,
            primaryButtonTitle: primaryButtonTitle,
            secondaryButtonTitle: secondaryButtonTitle)
        let titlesFont = VFGTitlesFontModel(
            titleFont: .vodafoneBold(16),
            descriptionFont: .vodafoneLite(24),
            moreDetailsFont: .vodafoneRegular(16))
        let accessibilityModel = VFGTwoActionsAccessibilityModel(
            primaryButton: "PCconfirmationButton",
            secondaryButton: "PCcancelButton")
        confirmationView.configure(
            viewStyle: .white,
            titlesModel: titlesModel ?? VFGTitlesModel(primaryButtonTitle: ""),
            titlesFontModel: titlesFont,
            accessibilityIDsModel: accessibilityModel)
    }

    public func quickActionsProtocol(delegate: VFQuickActionsProtocol) {
        self.delegate = delegate
    }

    public func closeQuickAction() {
        delegate?.closeQuickAction(completion: nil)
    }
}

extension VFGBarringAskChangesCardView: VFGTwoActionsViewProtocol {
    public func primaryButtonAction() {
        delegate?.closeQuickAction {
            self.confirmAction()
        }
    }

    public func secondaryButtonAction() {
        delegate?.closeQuickAction(completion: nil)
    }
}
