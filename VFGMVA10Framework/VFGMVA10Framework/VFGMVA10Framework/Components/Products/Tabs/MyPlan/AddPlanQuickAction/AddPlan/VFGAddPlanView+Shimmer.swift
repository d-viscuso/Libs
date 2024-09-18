//
//  VFGAddPlanView+Shimmer.swift
//  VFGMVA10Framework
//
//  Created by Moataz Akram on 11/09/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGAddPlanView {
    func showShimmer() {
        if let topViewController = UIApplication.topViewController() as? VFQuickActionsViewController {
            topViewController.view.isUserInteractionEnabled = false
        }
        addPlanShimmerView = AddPlanShimmerView()
        addPlanShimmerView?.frame = bounds
        addPlanShimmerView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addPlanShimmerView?.startShimmer()
        guard let addPlanShimmerView = addPlanShimmerView else {
            return
        }
        addSubview(addPlanShimmerView)
    }

    func hideShimmer() {
        if let topViewController = UIApplication.topViewController() as? VFQuickActionsViewController {
            topViewController.view.isUserInteractionEnabled = true
        }
        addPlanShimmerView?.stopShimmer()
    }
}
