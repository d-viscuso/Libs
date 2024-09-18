//
//  VFGMVA12HeaderMenuItemModel.swift
//  VFGMVA10Framework
//
//  Created by Ihsan Kahramanoglu on 9.06.2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import UIKit

public class VFGMVA12HeaderMenuItemModel: VFGMVA12HeaderMenuItemModelProtocol {
    /// Click action for menu item on header view
    public var clickAction: () -> Void
    /// Image identifier for menu item on header view it can be an assets name or URL
    public var imageIdentifier: String?
    /// Badge count
    public var badgeCount: Int
    /// Badge count
    public var badgeId: String
    /// Badge Custom Text
    public var badgeCustomText: String?

    public init(
        imageIdentifier: String?,
        clickAction: @escaping () -> Void,
        badgeCount: Int = 0,
        badgeId: String = "HeaderViewMenuItemBadgeId",
        badgeCustomText: String = ""
    ) {
        self.imageIdentifier = imageIdentifier
        self.clickAction = clickAction
        self.badgeCount = badgeCount
        self.badgeId = badgeId
        self.badgeCustomText = badgeCustomText
    }
}
