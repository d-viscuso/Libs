//
//  VFMVA10SwitchAccountTheme.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 04/08/2022.
//

import UIKit
import VFGMVA10Foundation

class VFMVA10SwitchAccountTheme: NSObject, VFSwitchAccountTheme, UITableViewDataSource {
    /// *VFGSwitchAccountViewController* table view sections count
    lazy var numberOfSections = Mirror(reflecting: sections).children.count
    /// Currently selected account
    let selectedAccount: VFGAccount? = VFGUser.shared.selectedAccount()
    /// List of all accounts except for currently selected account
    lazy var otherAccounts: [VFGAccount] = {
        VFGUser.shared.accounts.filter { $0.name != selectedAccount?.name }
    }()

    /// *VFGSwitchAccountViewController* table view sections
    let sections = (selected: 0, others: 1)
    var headerHeight: Int {
        return 100
    }
    let cellHeight = 50

    var contentViewHeight: CGFloat {
        let headersHeight = headerHeight * numberOfSections
        let cellsHeight = cellHeight * VFGUser.shared.accounts.count

        return CGFloat(min(headersHeight + cellsHeight, Int(UIScreen.main.bounds.size.height * 0.6)))
    }

    let reuseIdentifiers = VFGSwitchAccountViewController.ReuseIdentifiers.self

    weak var switchAccountController: VFGSwitchAccountViewController?

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        CGFloat(headerHeight)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == sections.selected ? 1 : otherAccounts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifiers.accountCell.rawValue)
            as? VFGSwitchAccountTableViewCell else {
            return UITableViewCell()
        }
        cell.accessibilityIdentifier = "SAcellAtSection_\(indexPath.section)AtRow_\(indexPath.row)"
        if indexPath.section == sections.selected,
            let selectedAccount = selectedAccount {
            cell.configureCell(selectedAccount, isSelectedAccount: true)
        } else if indexPath.section == sections.others {
            cell.configureCell(otherAccounts[indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: reuseIdentifiers.accountHeader.rawValue)
            as? VFGSwitchAccountTableViewHeader else {
                return nil
        }

        if section == sections.selected {
            view.configureHeader("switch_account_quick_action_current_account_title".localized(bundle: .mva10Framework))
        } else if section == sections.others {
            view.configureHeader("switch_account_quick_action_other_accounts_title".localized(bundle: .mva10Framework))
        }

        return view
    }
}
extension VFMVA10SwitchAccountTheme: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section != sections.selected else {
            return
        }

        switchAccountController?.switchTo(account: otherAccounts[indexPath.row])
    }
}
