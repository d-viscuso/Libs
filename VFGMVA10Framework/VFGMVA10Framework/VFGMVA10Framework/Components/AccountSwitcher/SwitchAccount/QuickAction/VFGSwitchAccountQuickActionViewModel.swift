//
//  VFGSwitchAccountQuickActionViewModel.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 12/18/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Switch account quick action
public class VFGSwitchAccountQuickActionViewModel: VFQuickActionsModel {
    /// An instance of *VFGSwitchAccountViewController*
    var switchAccountViewController: VFGSwitchAccountViewController
    private var enableScrolling: Bool

    public var isScrollEnabled: Bool {
        return enableScrolling
    }

    public var quickActionsTitle: String = "switch_account_quick_action_title".localized(bundle: .mva10Framework)
    public var quickActionsStyle: VFQuickActionsStyle = .white
    /// Delegation for quick action operations
    weak var delegate: VFQuickActionsProtocol?
    public lazy var quickActionsContentView: UIView = switchAccountViewController.view
    /// *VFGSwitchAccountQuickActionViewModel* initializer
    /// - Parameters:
    ///    - delegate: Delegation for switch account operations
    ///    - dataSource: Data source for the switch account layout.
    ///    - manageAccountDelegate: Delegate for the manage account journey.
    public init(
        _ delegate: VFGSwitchAccountDelegate? = nil,
        themeType: VFSwitchAccount = .mva10,
        dataSource: VFGSwitchAccountDataSource? = nil,
        manageAccountDelegate: VFGManageAccountDelegate? = nil
    ) {
        let theme = themeType.buildTheme()
        switchAccountViewController = VFGSwitchAccountViewController(
            delegate: delegate,
            theme: theme,
            dataSource: dataSource,
            manageAccountDelegate: manageAccountDelegate)
        switchAccountViewController.themeType = themeType
        quickActionsTitle = themeType.title
        enableScrolling = themeType == .mva10
    }

    public func quickActionsProtocol(delegate: VFQuickActionsProtocol) {
        self.delegate = delegate
        switchAccountViewController.quickActionDelegate = delegate
    }

    public func closeQuickAction() {
        delegate?.closeQuickAction(completion: nil)
    }
}
