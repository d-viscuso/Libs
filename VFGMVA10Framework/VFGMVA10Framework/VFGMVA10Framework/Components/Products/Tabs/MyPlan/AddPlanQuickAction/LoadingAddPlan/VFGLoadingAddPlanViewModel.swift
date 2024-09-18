//
//  VFGLoadingAddPlanViewModel.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 7/5/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

class VFGLoadingAddPlanViewModel {
    weak var delegate: VFGAddPlanStateInternalProtocol?
    var model: VFGAddPlanModelProtocol?
    var subTitle = ""
    var paymentMethodTitle = ""
    var buttonTitle = ""
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
            self.delegate?.presentLoadingView()
        }
    }
}

extension VFGLoadingAddPlanViewModel: VFQuickActionsModel {
    func closeQuickAction() {
        delegate?.dismissQuickAction()
    }

    func quickActionsProtocol(delegate: VFQuickActionsProtocol) {}

    var quickActionsTitle: String {
        guard let quickActionViewTitleLoad = quickActionViewTitle else {
            guard let modelLoad = model else {
                return ""
            }
            let service = modelLoad.serviceType
            switch service {
            case AddPlanType.data.rawValue:
                return "add_data_title".localized(bundle: Bundle.mva10Framework)
            case AddPlanType.sms.rawValue:
                return "add_sms_title".localized(bundle: Bundle.mva10Framework)
            default:
                return "soho_add_calls_title".localized(bundle: Bundle.mva10Framework)
            }
        }
        return quickActionViewTitleLoad
    }

    var quickActionsContentView: UIView {
        guard let loadingAddPlanView: VFGLoadingAddPlanView =
            VFGLoadingAddPlanView.loadXib(bundle: Bundle.mva10Framework) else {
                return UIView()
        }
        loadingAddPlanView.configure()
        return loadingAddPlanView
    }

    var quickActionsStyle: VFQuickActionsStyle {
        .white
    }
}
