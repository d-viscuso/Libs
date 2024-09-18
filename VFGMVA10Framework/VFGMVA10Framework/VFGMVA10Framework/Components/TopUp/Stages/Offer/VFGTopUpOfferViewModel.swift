//
//  VFGTopUpOfferViewModel.swift
//  VFGMVA10Framework
//
//  Created by Salma Ashour on 1/19/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

class VFGTopUpOfferViewModel {
    weak var topUpDelegate: VFGTopUpProtocol?
    weak var delegate: VFGTopUpStateInternalProtocol?
    var selectedAmount = 0.0

    var sectionTitle = ""
    var subTitle = ""
    var buttonTitle = ""

    func getUserName() -> String? {
        return topUpDelegate?.model?.relatedParty?.first?.name
    }

    init (topUpDelegate: VFGTopUpProtocol?, delegate: VFGTopUpStateInternalProtocol?, selectedAmount: Double) {
        self.selectedAmount = selectedAmount
        self.topUpDelegate = topUpDelegate
        self.delegate = delegate
        self.setLocalizedUIElementContent()
        DispatchQueue.main.async {
            self.delegate?.topUpOfferDidPresent()
        }
    }

    private func setLocalizedUIElementContent() {
        guard let topupModel = topUpDelegate?.model else {
            return
        }

        let buttonTitleArgs =
            [
                (String(topupModel.minOfferAmount ?? 0)),
                topupModel.currency ?? ""
            ]
        buttonTitle = String(
            format: "top_up_quick_action_offer_button".localized(bundle: Bundle.mva10Framework),
            arguments: buttonTitleArgs)
        let currency = topupModel.currency ?? ""
        let minOfferAmount = String(topupModel.minOfferAmount ?? 0)
        let dataAmount = String(topupModel.dataOfferAmount ?? 0)
        let dataUnit = topupModel.dataUnit ?? ""
        let offerAmount = String(topupModel.offerAmount ?? 0)
        let offerDescription = topupModel.offerDescription?.localized(bundle: .mva10Framework) ?? ""
        let sectionTitleArgs =
            [
                minOfferAmount,
                currency,
                dataAmount,
                dataUnit,
                offerDescription,
                offerAmount,
                currency
            ]
        sectionTitle = String(
            format: "top_up_quick_action_offer".localized(bundle: Bundle.mva10Framework),
            arguments: sectionTitleArgs)
        subTitle = "top_up_quick_action_offer_end".localized(bundle: Bundle.mva10Framework)
    }

    func topupOffer() {
        delegate?.topUpOfferDidFinish(
            topUpValue: topUpDelegate?.model?.offerAmount,
            withOffer: true)
    }
}

extension VFGTopUpOfferViewModel: VFGTopUpOfferProtocol {
    func topUpClicked() {
        topupOffer()
    }

    func noOfferClicked() {
        delegate?.noOfferDidFinish(topUpValue: nil, withOffer: false)
    }
}

extension VFGTopUpOfferViewModel: VFQuickActionsModel {
    func closeQuickAction() {
        delegate?.dismiss()
    }

    func quickActionsProtocol(delegate: VFQuickActionsProtocol) {}

    var quickActionsTitle: String {
        "top_up_quick_action_main_title".localized(bundle: Bundle.mva10Framework)
    }

    var quickActionsContentView: UIView {
        guard let topupActionView: VFGTopUpOfferView =
            VFGTopUpOfferView.loadXib(bundle: Bundle.mva10Framework), let topUpModel = topUpDelegate
        else {
            return UIView()
        }

        topupActionView.configure(with: topUpModel, viewModel: self)
        topupActionView.delegate = self

        return topupActionView
    }
    var quickActionsStyle: VFQuickActionsStyle {
        .white
    }
}
