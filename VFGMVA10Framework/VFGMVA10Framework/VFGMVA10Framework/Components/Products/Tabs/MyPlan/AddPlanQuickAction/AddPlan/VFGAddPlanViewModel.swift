//
//  VFGAddPlanViewModel.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 7/5/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

class VFGAddPlanViewModel {
    var model: VFGAddPlanModelProtocol?
    weak var delegate: VFGAddPlanStateInternalProtocol?
    var isRecurring: Bool?
    var selectedPlanIndexPath: IndexPath?
    var quickActionViewTitle: String?

    init (
        with model: VFGAddPlanModelProtocol?,
        delegate: VFGAddPlanStateInternalProtocol?,
        quickActionViewTitle: String?
    ) {
        self.delegate = delegate
        self.model = model
        self.quickActionViewTitle = quickActionViewTitle
        DispatchQueue.main.async {
            self.delegate?.presentAddPlanView()
        }
    }
}

extension VFGAddPlanViewModel: VFGAddPlanViewProtocol {
    func confirmTapped(selectedPlanIndexPath: IndexPath, isRecurring: Bool, serviceType: String, with paymentCard: PaymentModelProtocol) {
        guard let amount = selectedAmount() else { return }
        delegate?.addPlanFinished(
            selectedPlanIndexPath: selectedPlanIndexPath,
            isRecurring: isRecurring,
            serviceType: serviceType,
            with: paymentCard,
            amount: amount
        )
    }

    func cancelTapped() {
        delegate?.dismissQuickAction()
    }

    func updateSelectedIndexPath(selectedPlanIndexPath: IndexPath?) {
        self.selectedPlanIndexPath = selectedPlanIndexPath
    }

    func selectedAmount() -> Double? {
        guard
            let selectedIndex = selectedPlanIndexPath,
            let selectedBundle = model?.dataBundles?[selectedIndex.row],
            let bundlePrice = selectedBundle.bundlePrice else {
            return nil
        }
        return Double(bundlePrice)
    }
}

extension VFGAddPlanViewModel: VFQuickActionsModel {
    func closeQuickAction() {
        delegate?.dismissQuickAction()
    }

    func quickActionsProtocol(delegate: VFQuickActionsProtocol) {}

    var quickActionsTitle: String {
        guard let quickActionViewTitle = quickActionViewTitle else {
            guard let model = model else {
                return ""
            }
            switch model.serviceType {
            case AddPlanType.data.rawValue:
                return "add_data_title".localized(bundle: Bundle.mva10Framework)
            case AddPlanType.sms.rawValue:
                return "add_sms_title".localized(bundle: Bundle.mva10Framework)
            default:
                return "soho_add_calls_title".localized(bundle: Bundle.mva10Framework)
            }
        }
        return quickActionViewTitle
    }

    var quickActionsContentView: UIView {
        guard let addPlanView: VFGAddPlanView = UIView.loadXib(bundle: Bundle.mva10Framework),
            let model = model else {
                return UIView()
        }
        addPlanView.configure(with: model)
        addPlanView.delegate = self
        addPlanView.isRecurring = isRecurring ?? false
        addPlanView.selectedPlanIndexPath = selectedPlanIndexPath
        return addPlanView
    }

    var quickActionsStyle: VFQuickActionsStyle {
        .white
    }
}
