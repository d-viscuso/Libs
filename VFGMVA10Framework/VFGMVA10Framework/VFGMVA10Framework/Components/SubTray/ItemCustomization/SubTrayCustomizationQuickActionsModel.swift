//
//  SubTrayCustomizationQuickActionsModel.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 21/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Quick action with confirmation view for sub tray customization changes made
class SubTrayCustomizationQuickActionsModel: VFQuickActionsModel {
    var quickActionsTitle = "sub_tray_verification_overlay_title".localized(bundle: .mva10Framework)
    /// A protocol that manages user interactions with quick actions, including reload, close and scrolling
    weak var delegate: VFQuickActionsProtocol?
    /// A view that appear on quick action to display text (title - description - more detail ) , an image and two action buttons
    var confirmationView: VFGTwoActionsView?
    /// Two actions view protocol that used for action delegation
    weak var confirmationViewDelegate: VFGTwoActionsViewProtocol?
    var quickActionsStyle: VFQuickActionsStyle {
        return .white
    }
    /// *confirmationView* description text
    var confirmationText = ""

    var quickActionsContentView: UIView {
        confirmationView = VFGTwoActionsView.loadXib(bundle: .foundation)
        guard let confirmationView = confirmationView else {
            return UIView()
        }
        configureConfirmationView()
        confirmationView.delegate = confirmationViewDelegate
        return confirmationView
    }
    /// *SubTrayCustomizationQuickActionsModel* initializer
    /// - Parameters:
    ///    - confirmationText: *confirmationView* description text
    ///    - confirmationViewDelegate: Two actions view protocol that used for action delegation
    init(confirmationText: String, confirmationViewDelegate: VFGTwoActionsViewProtocol?) {
        self.confirmationText = confirmationText
        self.confirmationViewDelegate = confirmationViewDelegate
    }

    private func configureConfirmationView() {
        guard let confirmationView = confirmationView else { return }
        let description = confirmationText
        let moreDetails = "sub_tray_verification_receive_sms".localized(bundle: .mva10Framework)
        let primaryButtonTitle = "sub_tray_verification_overlay_primary_button".localized(bundle: .mva10Framework)
        let secondaryButtonTitle = "sub_tray_verification_overlay_secondary_button".localized(bundle: .mva10Framework)
        let titlesModel = VFGTitlesModel(
            description: description,
            moreDetails: moreDetails,
            primaryButtonTitle: primaryButtonTitle,
            secondaryButtonTitle: secondaryButtonTitle)
        let titlesFont = VFGTitlesFontModel(descriptionFont: .vodafoneLite(25))
        confirmationView.configure(
            viewStyle: .white,
            titlesModel: titlesModel,
            titlesFontModel: titlesFont)
    }

    func quickActionsProtocol(delegate: VFQuickActionsProtocol) {
        self.delegate = delegate
    }

    func closeQuickAction() {
        delegate?.closeQuickAction(completion: nil)
    }
}
