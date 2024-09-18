//
//  VFMVA12SwitchAccountTheme.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 04/08/2022.
//

import UIKit
import VFGMVA10Foundation

class VFMVA12SwitchAccountTheme: NSObject, VFSwitchAccountTheme, UITableViewDataSource {
    /// List of all accounts
    lazy var accounts: [VFGAccount] = {
        VFGUser.shared.accounts
    }()

    /// Currently selected account
    let selectedAccount: VFGAccount? = VFGUser.shared.selectedAccount()

    weak var switchAccountController: VFGSwitchAccountViewController?

    var headerHeight: Int {
        accounts.count == 1 ? 0 : 48
    }

    let estimatedFooterHeight = 144.0

    let reuseIdentifiers = VFGSwitchAccountViewController.ReuseIdentifiers.self

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        CGFloat(headerHeight)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return estimatedFooterHeight
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifiers.mva12AccountCell.rawValue)
            as? VFGMVA12SwitchAccountCell else {
            return UITableViewCell()
        }
        cell.accessibilityIdentifier = "SAcellAtSection_\(indexPath.section)AtRow_\(indexPath.row)"
        let account = accounts[indexPath.row]
        if account.name == selectedAccount?.name && accounts.count > 1 {
            cell.configureCell(account, isSelectedAccount: true)
        } else {
            cell.configureCell(VFGUser.shared.accounts[indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let view = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: reuseIdentifiers.accountHeader.rawValue)
                as? VFGSwitchAccountTableViewHeader,
            accounts.count > 1
        else { return nil }
        let headerTitle = "switch_account_quick_action_header_title".localized(bundle: .mva10Framework)
        view.configureHeader(headerTitle, isMVA12: true)
        return view
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: reuseIdentifiers.accountFooter.rawValue)
                as? VFGSwitchAccountTableViewFooter else {
            return nil
        }
        view.backgroundColor = .white
        view.manageButtonDidTap = { [weak self] in
            self?.switchAccountController?.manageButtonDidTap()
        }
        view.addAccountButtonDidTap = { [weak self] in
            self?.switchAccountController?.addAccountButtonDidTap()
        }
        view.logOutButtonDidTap = { [weak self] in
            self?.switchAccountController?.logOutButtonDidTap()
        }
        view.configure(self.switchAccountController?.dataSource)
        return view
    }
}
extension VFMVA12SwitchAccountTheme: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switchAccountController?.switchTo(account: accounts[indexPath.row])
    }
}
extension VFMVA12SwitchAccountTheme {
    func setupViews() {
        switchAccountController?.cancelButton.isHidden = true
        switchAccountController?.addAccountButton.isHidden = true
        switchAccountController?.tableView.estimatedRowHeight = 100
        switchAccountController?.tableView.rowHeight = UITableView.automaticDimension
        switchAccountController?.stackviewTopConstraint.constant = accounts.count == 1 ? -35 : 0
        switchAccountController?.observeHeight()
        switchAccountController?.tableView.isScrollEnabled = true
        switchAccountController?.tableView.backgroundColor = .white
    }
}
