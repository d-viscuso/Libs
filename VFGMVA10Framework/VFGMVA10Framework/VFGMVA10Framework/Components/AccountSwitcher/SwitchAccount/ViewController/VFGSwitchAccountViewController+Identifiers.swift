//
//  VFGSwitchAccountViewController+Identifiers.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 12/19/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

extension VFGSwitchAccountViewController {
    enum NibNames: String {
        case cell = "VFGSwitchAccountTableViewCell"
        case mva12cell = "VFGMVA12SwitchAccountCell"
        case header = "VFGSwitchAccountTableViewHeader"
        case footer = "VFGSwitchAccountTableViewFooter"
        case viewController = "VFGSwitchAccountViewController"
    }

    enum ReuseIdentifiers: String {
        case accountCell
        case mva12AccountCell
        case accountHeader
        case accountFooter
    }
}
