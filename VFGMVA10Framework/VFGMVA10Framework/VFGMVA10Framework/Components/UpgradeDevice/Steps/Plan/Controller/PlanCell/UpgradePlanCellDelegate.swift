//
//  UpgradePlanCellDelegate.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 6/8/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

public protocol UpgradePlanCellDelegate: AnyObject {
    func planHeaderViewButtonDidPress(for indexPath: IndexPath, isExpanded: Bool)
    func recommendedInfoButtonDidPress()
    func choosePlanButtonDidPress(for indexPath: IndexPath)
}

extension UpgradePlanCellDelegate {
    func recommendedInfoButtonDidPress() {}
    func choosePlanButtonDidPress(for indexPath: IndexPath) {}
}
