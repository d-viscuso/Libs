//
//  CostBreakdownQuickActionModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 24/10/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

public class CostBreakdownQuickActionModel {
    weak var delegate: VFQuickActionsProtocol?
    var device: ChooseDeviceModel.Device?
    var plan: VFGUpgradePlanModel.Plan?

    public init(
        device: ChooseDeviceModel.Device?,
        plan: VFGUpgradePlanModel.Plan? = nil
    ) {
        self.device = device
        self.plan = plan
    }
}

extension CostBreakdownQuickActionModel: VFQuickActionsModel {
    public var quickActionsTitle: String {
        return "device_upgrade_cost_breakdown_modal_title".localized(bundle: .mva10Framework)
    }

    public var quickActionsStyle: VFQuickActionsStyle {
        return .white
    }

    public var quickActionsContentView: UIView {
        guard let costBreakdownView: VFGCostBreakdownView = UIView.loadXib(bundle: .mva10Framework) else {
            return UIView()
        }
        costBreakdownView.setup(
            device: device,
            plan: plan
        )
        return costBreakdownView
    }

    public func closeQuickAction() {
        delegate?.closeQuickAction(completion: nil)
    }

    public func quickActionsProtocol(delegate: VFQuickActionsProtocol) {
        self.delegate = delegate
    }
}
