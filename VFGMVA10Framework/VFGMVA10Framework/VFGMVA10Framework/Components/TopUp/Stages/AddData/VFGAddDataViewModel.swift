//
//  VFGAddDataViewModel.swift
//  VFGMVA10Framework
//
//  Created by Salma Ashour on 1/14/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

class VFGAddDataViewModel {
    weak var topUpDelegate: VFGTopUpProtocol?
    weak var delegate: VFGTopUpStateInternalProtocol?
    var selectedAmount = 0.0
    func getUserName() -> String? {
        return topUpDelegate?.model?.relatedParty?.first?.name
    }

    init (
        topUpDelegate: VFGTopUpProtocol?,
        delegate: VFGTopUpStateInternalProtocol?,
        selectedAmount: Double
    ) {
        self.selectedAmount = selectedAmount
        self.delegate = delegate
        self.topUpDelegate = topUpDelegate
        DispatchQueue.main.async {
            self.delegate?.addDataViewDidPresent()
        }
    }
}

extension VFGAddDataViewModel: VFGAddDataProtocol {
    func backButtonDidPress() {
        delegate?.backButtonDidPress()
    }

    func acceptDataButtonDidPress() {
        delegate?.acceptDataButtonDidPress(
            topUpValue: topUpDelegate?.model?.dataOfferAmount,
            withOffer: topUpDelegate?.model?.offerAmount != nil)
    }

    func declineDataButtonDidPress() {
        delegate?.declineDataButtonDidPress(
            topUpValue: nil,
            withOffer: topUpDelegate?.model?.offerAmount != nil)
    }
}

extension VFGAddDataViewModel: VFQuickActionsModel {
    func closeQuickAction() {
        delegate?.dismiss()
    }

    var quickActionsStyle: VFQuickActionsStyle {
        .white
    }
    func quickActionsProtocol(delegate: VFQuickActionsProtocol) {}

    var quickActionsTitle: String {
        "top_up_quick_action_main_title".localized(bundle: Bundle.mva10Framework)
    }

    var quickActionsContentView: UIView {
        guard let addDataView: VFGAddDataView =
            VFGAddDataView.loadXib(bundle: Bundle.mva10Framework),
            let topUpModel = topUpDelegate
        else {
            return UIView()
        }
        addDataView.configure(with: topUpModel, selectedAmount: Int(selectedAmount))
        addDataView.delegate = self

        return addDataView
    }
}
