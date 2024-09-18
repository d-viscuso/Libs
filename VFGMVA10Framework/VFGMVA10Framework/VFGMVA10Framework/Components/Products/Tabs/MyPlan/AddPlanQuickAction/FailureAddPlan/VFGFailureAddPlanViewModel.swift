//
//  VFGFailureAddPlanViewModel.swift
//  VFGMVA10Framework
//
//  Created by Hamsa Hassan on 7/26/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

class VFGFailureAddPlanViewModel {
    weak var delegate: VFGAddPlanStateInternalProtocol?
    var model: VFGAddPlanModelProtocol?

    var sectionTitle = ""
    var subTitle = ""
    var buttonTitle = ""
    var cancelButtonTitle = ""
    var titles: VFGFailureAddPlanModel?
    var quickActionViewTitle: String?

    init (
        with model: VFGAddPlanModelProtocol?,
        delegate: VFGAddPlanStateInternalProtocol?,
        titles: VFGFailureAddPlanModel?,
        quickActionViewTitle: String?
    ) {
        self.model = model
        self.delegate = delegate
        self.quickActionViewTitle = quickActionViewTitle
        if let titles = titles {
            self.titles = titles
        } else {
            setupContentLabels()
        }
        DispatchQueue.main.async {
            self.delegate?.presentFailureView()
        }
    }

    func setupContentLabels() {
        guard let model = model else {
            return
        }
        let service = model.serviceType
        switch service {
        case AddPlanType.data.rawValue:
            sectionTitle = String(format: "add_sms_payment_failure_title".localized(bundle: Bundle.mva10Framework))
            subTitle = String(format: "add_sms_payment_failure_message".localized(bundle: Bundle.mva10Framework))
            buttonTitle = String(format:
                "add_sms_payment_failure_try_again_button_title".localized(bundle: Bundle.mva10Framework))
        default:
            sectionTitle = String(format: "add_data_payment_failure_title".localized(bundle: Bundle.mva10Framework))
            subTitle = String(format:
                "add_data_payment_failure_message".localized(bundle: Bundle.mva10Framework))
            buttonTitle = String(format:
                "add_data_payment_failure_try_again_button_title".localized(bundle: Bundle.mva10Framework))
        }
    titles = VFGFailureAddPlanModel(
        mainTitle: sectionTitle,
        subTitle: subTitle,
        tryAgainButtonTitle: buttonTitle)
    }
}

extension VFGFailureAddPlanViewModel: VFQuickActionsModel {
    func closeQuickAction() {
        delegate?.dismissQuickAction()
    }

    func quickActionsProtocol(delegate: VFQuickActionsProtocol) {}

    var quickActionsTitle: String {
        guard let quickActionViewTitleFail = quickActionViewTitle else {
            guard let modelFail = model else {
                return ""
            }
            let service = modelFail.serviceType
            switch service {
            case AddPlanType.data.rawValue:
                return "add_data_title".localized(bundle: Bundle.mva10Framework)
            case AddPlanType.sms.rawValue:
                return "add_sms_title".localized(bundle: Bundle.mva10Framework)
            default:
                return "soho_add_calls_title".localized(bundle: Bundle.mva10Framework)
            }
        }
        return quickActionViewTitleFail
    }

    var quickActionsContentView: UIView {
        guard let failureAddPlanView: VFGFailureAddPlanView =
            VFGFailureAddPlanView.loadXib(bundle: Bundle.mva10Framework) else {
                return UIView()
        }
        failureAddPlanView.delegate = delegate
        failureAddPlanView.configure(with: titles)
        return failureAddPlanView
    }

    var quickActionsStyle: VFQuickActionsStyle {
        .white
    }
}
