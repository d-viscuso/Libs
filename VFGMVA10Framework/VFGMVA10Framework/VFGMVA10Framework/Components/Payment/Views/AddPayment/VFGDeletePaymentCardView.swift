//
//  VFGDeletePaymentCardView.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 9/27/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class VFGDeletePaymentCardView: VFQuickActionsModel {
    weak var delegate: VFQuickActionsProtocol?
    var cardName = ""
    var deleteAction: () -> Void
    var titlesModel: VFGTitlesModel?
    private let bottomMargin: CGFloat = 25

    init(
        deleteAction: @escaping () -> Void,
        cardName: String
    ) {
        self.deleteAction = deleteAction
        self.cardName = cardName
    }

    public var quickActionsTitle: String { "" }
    public var quickActionsStyle: VFQuickActionsStyle {
        return .white
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
        let title = String(
            format: "payment_add_form_title_toggle".localized(bundle: .mva10Framework),
            cardName)
        let moreDetails = "payment_add_form_description_toggle".localized(bundle: .mva10Framework)
        let primaryButtonTitle = "payment_delete_form_delete_button".localized(bundle: .mva10Framework)
        let secondaryButtonTitle =
            "payment_delete_form_keep_card_button".localized(bundle: .mva10Framework)
        let iconImage = UIImage.VFGWarning.medium
        titlesModel = VFGTitlesModel(
            title: title,
            moreDetails: moreDetails,
            primaryButtonTitle: primaryButtonTitle,
            secondaryButtonTitle: secondaryButtonTitle)
        let titlesFont = VFGTitlesFontModel(titleFont: .vodafoneBold(18))
        let titlesAlignment = VFGTitlesAlignmentModel(
            titleAlignment: .center,
            moreDetailsAlignment: .center)
        confirmationView.configure(
            viewStyle: .white,
            bottomMargin: bottomMargin,
            iconImage: iconImage,
            titlesModel: titlesModel ?? VFGTitlesModel(primaryButtonTitle: ""),
            titlesFontModel: titlesFont,
            titlesAlignmentModel: titlesAlignment)
    }

    public func quickActionsProtocol(delegate: VFQuickActionsProtocol) {
        self.delegate = delegate
    }

    public func closeQuickAction() {
        delegate?.closeQuickAction(completion: nil)
    }
}

extension VFGDeletePaymentCardView: VFGTwoActionsViewProtocol {
    public func primaryButtonAction() {
        delegate?.closeQuickAction(completion: nil)
        deleteAction()
    }

    public func secondaryButtonAction() {
        delegate?.closeQuickAction(completion: nil)
    }
}
