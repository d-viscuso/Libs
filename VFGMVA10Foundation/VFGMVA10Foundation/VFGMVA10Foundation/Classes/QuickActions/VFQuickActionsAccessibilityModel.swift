//
//  VFQuickActionsAccessibilityModel.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 5/23/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// A struct that provides accessibility identifiers for many interfaces
public struct VFQuickActionsAccessibilityModel {
    public var mainView: String
    public var title: String
    public var closeButton: String
    public var backButton: String
    public var headerButton: String

    /// To set Accessibility identifiers for mainView, quick action title, close button, back button and header button
    public init(
        mainView: String = "quickActionMainView",
        title: String = "quickActionMainTitle",
        closeButton: String = "quickActionCloseButton",
        backButton: String = "quickActionBackButton",
        headerButton: String = "quickActionHeaderButton"
    ) {
        self.mainView = mainView
        self.title = title
        self.closeButton = closeButton
        self.backButton = backButton
        self.headerButton = headerButton
    }
}
