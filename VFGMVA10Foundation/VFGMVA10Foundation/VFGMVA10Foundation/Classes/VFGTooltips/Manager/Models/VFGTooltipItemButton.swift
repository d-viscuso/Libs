//
//  VFGTooltipItemButton.swift
//  VFGMVA10Group
//
//  Created by Yahya Saddiq on 17/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

/// Tooltip's button model
public struct VFGTooltipItemButton {
    public let title: String
    var onPress: (() -> Void)?

    /// Tooltip button initializer
    /// - Parameters:
    ///    - title: Button title.
    ///    - onPress: On button press action.
    public init(title: String, onPress: (() -> Void)? = nil) {
        self.title = title
        self.onPress = onPress
    }
}
