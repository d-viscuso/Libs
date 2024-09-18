//
//  VFGMVA12HeaderViewModelProtocol.swift
//  VFGMVA10Framework
//
//  Created by Ihsan Kahramanoglu on 3.06.2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import UIKit

/// Enum for  MVA12 header types
public enum VFGMVA12DashboardHeaderType {
    case noAvatar
    case avatarWithImage
    case avatarWithUsername
}

/// MVA12 Dashboard header model protocol
public protocol VFGMVA12HeaderViewModelProtocol: AnyObject {
    /// Header view type for the main view above the dashboard cards
    var type: VFGMVA12DashboardHeaderType { get set }
    /// Header view height
    var headerViewHeight: CGFloat { get set }
    /// Header background ImageView
    var headerBackgroundImage: UIImage? { get set }
    /// Avatar image for header avatar
    var avatarImage: UIImage? { get set }
    /// Username to use the first initial as avatar
    var username: String { get set }
    /// Greeting message for header
    var welcomeMessage: String { get set }
    /// True if account action button is displayed
    var isAccountActionEnabled: Bool { get set }
    /// True if gradient background color is enabled
    var isGradientBackgroundColorEnabled: Bool { get set }
    /// Account action text
    var accountActionText: String { get set }
    /// See account action on header view
    var accountAction: () -> Void { get set }
    /// Avatar action on header view
    var avatarAction: () -> Void { get set }
    /// Menu items on right side of the header view
    var menuItems: [VFGMVA12HeaderMenuItemModelProtocol] { get set }
    /// - Returns:CustomHeaderModel for model type
    func getCustomHeaderModel(isLoading: Bool) -> VFGCustomHeaderModelProtocol?
}
