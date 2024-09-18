//
//  VFGBaseStepsViewControllerProtocol+Upgrade.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 23/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

public protocol VFGBaseUpgradeStepsViewControllerProtocol: VFGBaseStepsViewControllerProtocol {
    var onPriceChange: ((Any) -> Void)? { get set }
    var onStepStatusChange: ((VFGStepStatus) -> Void)? { get set }
    var status: VFGStepStatus { get set }
}
