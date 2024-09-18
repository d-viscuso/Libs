//
//  VFGPlanCellUIModel.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 5/23/21.
//

import Foundation

struct VFGPlanCellUIModel {
    let id, name: String
    let imageURL: String?
    let price: VFGUpgradePlanModel.Price?
    let subscriptions: [VFGUpgradePlanModel.Subscription]?
    let isRecommended: Bool
    var isExpanded = false
    var isChoosable = true
}
