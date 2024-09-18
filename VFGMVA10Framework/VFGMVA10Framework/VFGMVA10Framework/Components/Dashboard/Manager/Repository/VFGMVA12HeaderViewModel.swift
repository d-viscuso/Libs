//
//  VFGMVA12HeaderViewModel.swift
//  VFGMVA10Framework
//
//  Created by Ihsan Kahramanoglu on 6.06.2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
import UIKit

public class VFGMVA12HeaderViewModel: VFGMVA12HeaderViewModelProtocol {
    /// Header view type for the main view above the dashboard cards
    public var type: VFGMVA12DashboardHeaderType
    /// Header view height
    public var headerViewHeight: CGFloat
    /// Header background ImageView
    public var headerBackgroundImage: UIImage?
    /// Avatar image for header avatar
    public var avatarImage: UIImage?
    /// Username to use the first initial as avatar
    public var username: String
    /// Greeting message for header
    public var welcomeMessage: String
    /// True if account action button is displayed
    public var isAccountActionEnabled: Bool
    /// True if gradient background color is enabled
    public var isGradientBackgroundColorEnabled: Bool
    /// Account action text
    public var accountActionText: String
    /// See account action on header view
    public var accountAction: () -> Void
    /// Avatar action on header view
    public var avatarAction: () -> Void
    /// Menu items on right side of the header view
    public var menuItems: [VFGMVA12HeaderMenuItemModelProtocol]

    public init(
        type: VFGMVA12DashboardHeaderType,
        headerViewHeight: CGFloat,
        avatarImage: UIImage? = nil,
        headerBackgroundImage: UIImage? = VFGFrameworkAsset.Image.bgHeaderView,
        username: String = "",
        welcomeMessage: String,
        menuItems: [VFGMVA12HeaderMenuItemModelProtocol] = []
    ) {
        self.type = type
        self.headerViewHeight = headerViewHeight
        self.avatarImage = avatarImage
        self.headerBackgroundImage = headerBackgroundImage
        self.welcomeMessage = welcomeMessage
        self.menuItems = menuItems

        // Get only the uppercased first letter of avatar text
        var usernameInitial = username
        if username.count > 1 {
            usernameInitial = String(username[username.startIndex]).uppercased()
        }
        self.username = usernameInitial

        // Get only the first two menu items for display
        var updatedMenuItems: [VFGMVA12HeaderMenuItemModelProtocol] = menuItems
        if menuItems.count > 2 {
            updatedMenuItems = Array(menuItems[0 ..< 2])
        }
        self.menuItems = updatedMenuItems

        // Account actions are disabled by default
        isAccountActionEnabled = false
        isGradientBackgroundColorEnabled = false
        accountActionText = ""
        accountAction = {}
        avatarAction = {}
    }

    public func setAccountAction(
        accountActionText: String,
        accountAction: @escaping () -> Void
    ) {
        isAccountActionEnabled = true
        self.accountActionText = accountActionText
        self.accountAction = accountAction
    }

    public func resetAccountAction() {
        isAccountActionEnabled = false
        accountActionText = ""
        accountAction = {}
    }

    public func setAvatarAction(
        avatarAction: @escaping () -> Void
    ) {
        self.avatarAction = avatarAction
    }

    public func getCustomHeaderModel(isLoading: Bool = false) -> VFGCustomHeaderModelProtocol? {
        guard let headerView = getHeaderView(isLoading: isLoading) else { return nil }

        let customHeaderModel = VFGCustomHeaderModel(
            headerViewContainer: headerView,
            floatingViewContainer: nil,
            headerContainerHeight: headerViewHeight,
            minHeaderContainerHeight: 0,
            floatingContainerHeight: nil)

        return customHeaderModel
    }

    private func getHeaderView(isLoading: Bool) -> UIView? {
        if isLoading, let headerView: VFGMVA12HeaderShimmerView = UIView.loadXib(bundle: .mva10Framework) {
            return headerView
        }
        if let headerView: VFGMVA12HeaderView = UIView.loadXib(bundle: .mva10Framework) {
            headerView.setHeaderViewModel(self)
            return headerView
        }
        return nil
    }
}
