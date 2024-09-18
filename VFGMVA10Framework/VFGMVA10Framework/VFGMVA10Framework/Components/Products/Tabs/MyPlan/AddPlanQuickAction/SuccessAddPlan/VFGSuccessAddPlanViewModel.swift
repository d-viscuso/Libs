//
//  VFGSuccessAddPlanViewModel.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 7/5/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

class VFGSuccessAddPlanViewModel {
    var model: VFGAddPlanModelProtocol?
    weak var delegate: VFGAddPlanStateInternalProtocol?
    weak var quickActionDelegate: VFQuickActionsProtocol?
    var selectedPlanIndex: Int

    var sectionTitle = ""
    var subTitle = ""
    var buttonTitle = ""
    var quickActionViewTitle: String?
    var successAddPlanStrings: VFGSuccessAddPlanModel?

    init(
        with model: VFGAddPlanModelProtocol?,
        delegate: VFGAddPlanStateInternalProtocol?,
        selectedPlanIndex: Int,
        quickActionViewTitle: String?,
        successAddPlanStrings: VFGSuccessAddPlanModel? = nil
    ) {
        self.selectedPlanIndex = selectedPlanIndex
        self.model = model
        self.delegate = delegate
        self.quickActionViewTitle = quickActionViewTitle
        self.successAddPlanStrings = successAddPlanStrings
        setLocalizedUIElementContent()
        DispatchQueue.main.async {
            self.delegate?.presentSucccessView()
        }
    }

    private func setLocalizedUIElementContent() {
        setContentWithCloseAndSuccessful()
        setSubTitleWithBanalaceAndData()
    }

    func setSubTitleWithBanalaceAndData() {
        guard let model = model else {
            return
        }
        let amount = String(model.dataBundles?[selectedPlanIndex].bundleAmount ?? 0)
        let modelUnit = model.dataBundles?[selectedPlanIndex].dataUnit ?? ""
        let service = model.serviceType
        guard let successAddPlanStrings = successAddPlanStrings else {
            switch service {
            case AddPlanType.data.rawValue:
                subTitle = String(
                    format: "add_data_payment_success_message".localized(bundle: Bundle.mva10Framework),
                    arguments: [amount, modelUnit])
            default:
                subTitle = String(
                    format: "add_sms_payment_success_message".localized(bundle: Bundle.mva10Framework),
                    arguments: [amount, modelUnit])
            }
            return
        }
        subTitle = String(
            format: successAddPlanStrings.subTitle ?? "",
            arguments: [amount, modelUnit])
    }

    func setContentWithCloseAndSuccessful() {
        guard let successAddPlanStrings = successAddPlanStrings else {
        guard let model = model else {
            return
        }
        let service = model.serviceType
        switch service {
        case AddPlanType.data.rawValue:
            buttonTitle = "add_data_payment_success_return_button_title".localized(bundle: Bundle.mva10Framework)
            sectionTitle = "add_data_payment_success_title".localized(bundle: Bundle.mva10Framework)
        default:
            buttonTitle = "add_sms_payment_success_return_button_title".localized(bundle: Bundle.mva10Framework)
            sectionTitle = "add_sms_payment_success_title".localized(bundle: Bundle.mva10Framework)
        }
            return
        }
        buttonTitle = successAddPlanStrings.buttonTitle ?? ""
        sectionTitle = successAddPlanStrings.mainTitle ?? ""
    }
}

extension VFGSuccessAddPlanViewModel: VFQuickActionsModel {
    var isCloseButtonHidden: Bool { true }

    func closeQuickAction() {
        delegate?.dismissQuickAction()
    }

    func quickActionsProtocol(delegate: VFQuickActionsProtocol) {}

    var quickActionsTitle: String {
        guard let quickActionViewTitle = quickActionViewTitle  else {
            guard let model = model else {
                return ""
            }
            let service = model.serviceType
            switch service {
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
        guard let topupActionView: VFGSuccessAddPlanView =
            VFGSuccessAddPlanView.loadXib(bundle: Bundle.mva10Framework) else {
                return UIView()
        }
        topupActionView.delegate = delegate
        topupActionView.configure(with: self)
        return topupActionView
    }

    var quickActionsStyle: VFQuickActionsStyle {
        guard let backGroundColor = UIColor.lightBackground, let textColor = UIColor.primaryTextColor else {
            return .white
        }
        return .custom(backGroundColor: backGroundColor, textColor: textColor)
    }
}
