//
//  VFGSwitchAccountViewController.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 12/18/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
import UIKit
/// View controller to present available account for current user to switch between them
class VFGSwitchAccountViewController: UIViewController {
    @IBOutlet weak var mainStackBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainStackHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackviewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addAccountButton: VFGButton!
    @IBOutlet weak var cancelButton: VFGButton!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    /// Delegation for quick action operations
    weak var quickActionDelegate: VFQuickActionsProtocol?
    /// Delegation for switch account operations
    weak var delegate: VFGSwitchAccountDelegate?
    weak var manageAccountDelegate: VFGManageAccountDelegate?
    var dataSource: VFGSwitchAccountDataSource?
    var tableViewHeightObserver: NSKeyValueObservation?
    var theme: VFSwitchAccountTheme?
    var themeType: VFSwitchAccount?

    /// *VFGSwitchAccountViewController* initializer
    /// - Parameters:
    ///    - delegate: Delegation for switch account operations
    ///    - theme: Theme of the switch account either MVA10 or MVA12.
    ///    - dataSource: Data source for the switch account layout.
    ///    - manageAccountDelegate: Delegate for the manage account journey.
    init(
        delegate: VFGSwitchAccountDelegate?,
        theme: VFSwitchAccountTheme,
        dataSource: VFGSwitchAccountDataSource? = nil,
        manageAccountDelegate: VFGManageAccountDelegate? = nil
    ) {
        super.init(nibName: NibNames.viewController.rawValue, bundle: .mva10Framework)
        self.theme = theme
        self.theme?.switchAccountController = self
        loadViewIfNeeded()
        tableView.dataSource = self.theme as? UITableViewDataSource
        tableView.delegate = self.theme as? UITableViewDelegate
        tableView.reloadData()
        self.delegate = delegate
        self.dataSource = dataSource
        self.manageAccountDelegate = manageAccountDelegate
        tableView.accessibilityIdentifier = "SAtable"
        registerTableViews()

        cancelButton.titleLabel?.font = .vodafoneRegular(18)
        setupVoiceOverAccessibility()
        theme.setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    /// *VFGSwitchAccountViewController* table view registeration
    func registerTableViews() {
        let accountCell = UINib(nibName: NibNames.cell.rawValue, bundle: .mva10Framework)
        let mva12AccountCell = UINib(nibName: NibNames.mva12cell.rawValue, bundle: .mva10Framework)
        tableView.register(accountCell, forCellReuseIdentifier: ReuseIdentifiers.accountCell.rawValue)
        tableView.register(mva12AccountCell, forCellReuseIdentifier: ReuseIdentifiers.mva12AccountCell.rawValue)

        let headerView = UINib(nibName: NibNames.header.rawValue, bundle: .mva10Framework)
        tableView.register(
            headerView,
            forHeaderFooterViewReuseIdentifier: ReuseIdentifiers.accountHeader.rawValue
        )
        let footerView = UINib(nibName: NibNames.footer.rawValue, bundle: .mva10Framework)
        tableView.register(
            footerView,
            forHeaderFooterViewReuseIdentifier: ReuseIdentifiers.accountFooter.rawValue
        )
    }

    @IBAction func addAccountButtonDidPress(_ sender: Any) {
        delegate?.addAccountActionHandler?()
    }

    @IBAction func cancelButtonDidPress(_ sender: Any) {
        cancelButtonAction()
    }

    @objc func cancelButtonAction() {
        quickActionDelegate?.closeQuickAction(completion: nil)
    }

    func manageButtonDidTap() {
        quickActionDelegate?.closeQuickAction { [weak self] in
            guard let self else { return }
            if self.delegate?.manageAccountsActionHandler != nil {
                self.delegate?.manageAccountsActionHandler?()
            } else {
                self.openManageAccountScreen()
            }
        }
    }

    func addAccountButtonDidTap() {
        quickActionDelegate?.closeQuickAction { [weak self] in
            guard let self = self else { return }
            self.delegate?.addAccountActionHandler?()
        }
    }

    /// log out
    func logOutButtonDidTap() {
        let logoutConfirmationVC = VFGLogoutConfirmationViewController(
            delegate: delegate,
            themeType: themeType ?? .mva12,
            dataSource: dataSource
        )
        logoutConfirmationVC.modalPresentationStyle = .overFullScreen
        quickActionDelegate?.closeQuickAction {
            UIApplication.topViewController()?.present(logoutConfirmationVC, animated: true)
        }
    }

    /// Change current account
    /// - Parameters:
    ///    - account: Selected account to switch to
    func switchTo(account: VFGAccount) {
        delegate?.switchAccountWillStart(for: account)
        VFGUser.shared.switchTo(account: account) { [weak self] in
            guard let self = self else {
                return
            }

            self.delegate?.switchAccountDidComplete(for: account)
        }
    }

    func observeHeight() {
        tableViewHeightObserver = tableView.observe(\.contentSize, options: [.new]) { [weak self]_, change in
            guard
                let self = self,
                let newContentHeight = change.newValue?.height
            else { return }

            self.setViewHeight(with: newContentHeight)
            self.view.layoutIfNeeded()
            self.parent?.view.layoutIfNeeded()
        }
    }

    private func setViewHeight(with tableContentHeight: CGFloat) {
        let maxScreenheight = UIScreen.main.bounds.size.height - 120
        // This value is from the VFQuickActionsViewController header.
        let quickActionVCHeader: CGFloat = 80
        let cancelButtonHeight = cancelButton.isHidden ? 0 : cancelButton.frame.height
        let addAccountButtonHeight = addAccountButton.isHidden ? 0 : addAccountButton.frame.height
        let maxTableHeight = maxScreenheight - (quickActionVCHeader + cancelButtonHeight + addAccountButtonHeight)
        let height = CGFloat(min(tableContentHeight, maxTableHeight))
        self.tableViewHeightConstraint.constant = height
    }

    private func openManageAccountScreen() {
        let manageAccountVC = VFGManageAccountViewController(VFGUser.shared.accounts, delegate: manageAccountDelegate)
        VFQuickActionsViewController.presentQuickActionsViewController(with: manageAccountVC)
    }

    deinit {
        tableViewHeightObserver = nil
    }
}
