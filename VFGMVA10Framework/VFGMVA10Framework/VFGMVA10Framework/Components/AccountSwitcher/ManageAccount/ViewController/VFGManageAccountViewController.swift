//
//  VFGManageAccountViewController.swift
//  VFGMVA10Framework
//
//  Created by Ayman Ata on 28/08/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

public class VFGManageAccountViewController: UIViewController {
    weak var quickActionDelegate: VFQuickActionsProtocol?
    private let headerViewIdentifier = "VFGSwitchAccountTableViewHeaderIdentifier"
    private let manageAccountCellIdentifier = "VFGManageAccountTableViewCellID"
    private let selectedAccount: VFGAccount? = VFGUser.shared.selectedAccount()
    private var tableViewHeightObserver: NSKeyValueObservation?
    private var accounts: [VFGAccount] = VFGUser.shared.accounts
    private let estimatedCellHeight: CGFloat = 200
    private let estimatedHeaderHeight: CGFloat = 48
    weak var manageAccountDelegate: VFGManageAccountDelegate?
    lazy public var quickActionsContentView: UIView = self.view

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!

    public init(_ accounts: [VFGAccount], delegate: VFGManageAccountDelegate? = nil) {
        super.init(nibName: String(describing: VFGManageAccountViewController.self), bundle: .mva10Framework)
        self.accounts = accounts
        self.manageAccountDelegate = delegate
    }

    public init() {
        super.init(nibName: String(describing: VFGManageAccountViewController.self), bundle: .mva10Framework)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViews()
        setUpUI()
    }

    private func registerTableViews() {
        tableView.delegate = self
        tableView.dataSource = self
        let headerView = UINib(
            nibName: String(describing: VFGSwitchAccountTableViewHeader.self), bundle: .mva10Framework)
        tableView.register(
            headerView,
            forHeaderFooterViewReuseIdentifier: headerViewIdentifier)
        let manageAccountCell = UINib(
            nibName: String(describing: VFGManageAccountTableViewCell.self),
            bundle: .mva10Framework)
        tableView.register(
            manageAccountCell,
            forCellReuseIdentifier: manageAccountCellIdentifier)
    }

    private func setUpUI() {
        tableView.estimatedRowHeight = estimatedCellHeight
        tableView.estimatedSectionHeaderHeight = estimatedHeaderHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        observeHeight()
        tableView.isScrollEnabled = true
        tableView.backgroundColor = .white
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
        let maxTopScreenMargin: CGFloat = 80
        let maxScreenheight = UIScreen.main.bounds.size.height - maxTopScreenMargin
        // This value is from the VFQuickActionsViewController header.
        let quickActionVCHeader: CGFloat = 80
        let maxTableHeight = maxScreenheight - quickActionVCHeader
        let height = CGFloat(min(tableContentHeight, maxTableHeight))
        self.tableViewHeightConstraint.constant = height
    }

    deinit {
        tableViewHeightObserver = nil
    }
}

// MARK: - Quick Action delegate methods and properties.
extension VFGManageAccountViewController: VFQuickActionsModel {
    public func quickActionsProtocol(delegate: VFQuickActionsProtocol) {
        self.quickActionDelegate = delegate
    }

    public func closeQuickAction() {
        quickActionDelegate?.closeQuickAction(completion: nil)
    }

    public var quickActionsTitle: String {
        "manage_account_screen_title".localized(bundle: .mva10Framework)
    }

    public var isScrollEnabled: Bool {
        false
    }

    public var quickActionsStyle: VFQuickActionsStyle {
        .white
    }
}

// MARK: - TableView data source functions.
extension VFGManageAccountViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: manageAccountCellIdentifier) as? VFGManageAccountTableViewCell
        else { return UITableViewCell() }
        let account = accounts[indexPath.row]
        let isLast = indexPath.row == accounts.count - 1
        cell.delegate = self
        cell.configureCell(account, isSelectedAccount: account == selectedAccount, isLastCell: isLast)
        return cell
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        accounts.count
    }
}

// MARK: - TableView delegate functions.
extension VFGManageAccountViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: headerViewIdentifier)
                as? VFGSwitchAccountTableViewHeader
        else { return nil }
        let headerTitle = "manage_account_header_title".localized(bundle: .mva10Framework)
        headerView.configureHeader(headerTitle, isMVA12: true)
        return headerView
    }
}

// MARK: - Manage accounts cell delegate functions.
extension VFGManageAccountViewController: VFGManageAccountTableViewCellDelegate {
    func editAddAccountName(_ account: VFGAccount?) {
        guard let account = account else { return }
        let editAccountManager = VFGUpdateAccountManager(account: account)
        editAccountManager.manageAccountDelegate = manageAccountDelegate
        quickActionDelegate?.closeQuickAction {
            VFQuickActionsViewController.presentQuickActionsViewController(with: editAccountManager)
        }
    }

    func removeAccount(_ account: VFGAccount?) {
        guard let account = account else { return }
        let removeAccountManager = VFGUpdateAccountManager(account: account, accountActionType: .remove)
        removeAccountManager.manageAccountDelegate = manageAccountDelegate
        quickActionDelegate?.closeQuickAction {
            VFQuickActionsViewController.presentQuickActionsViewController(with: removeAccountManager)
        }
    }

    func makeAccountDefault(_ account: VFGAccount?) {
    }
}
