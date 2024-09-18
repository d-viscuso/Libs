//
//  VFMVA12SwitchAccountBuilder.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 04/08/2022.
//

import VFGMVA10Foundation
protocol VFSwitchAccountTheme {
    var switchAccountController: VFGSwitchAccountViewController? { get set }
    func setupViews()
}

public enum VFSwitchAccount {
    case mva10
    case mva12

    func buildTheme() -> VFSwitchAccountTheme {
        switch self {
        case .mva12:
            return VFMVA12SwitchAccountTheme()
        default:
            return VFMVA10SwitchAccountTheme()
        }
    }
}
extension VFSwitchAccount {
    var title: String {
        switch self {
        case .mva10:
            return "switch_account_quick_action_title".localized(bundle: .mva10Framework)
        case .mva12:
            if VFGUser.shared.accounts.count > 1 {
                return "switch_account_quick_action_more_account_title".localized(bundle: .mva10Framework)
            } else {
                return "switch_account_quick_action_one_account_title".localized(bundle: .mva10Framework)
            }
        }
    }
}
