//
//  VFGSubTrayItem+Equatable.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 24/10/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

extension VFGSubTrayItem: Equatable {
    /// Checks for equality
    /// - Parameters:
    ///    - lhs: Sub tray data model
    ///    - rhs: Sub tray data model
    /// - Returns: True if all comparisons matched and false if not
    public static func == (lhs: VFGSubTrayItem, rhs: VFGSubTrayItem) -> Bool {
        return
            lhs.itemID == rhs.itemID &&
            lhs.phoneNumber == rhs.phoneNumber &&
            lhs.title == rhs.title &&
            lhs.subTitle == rhs.subTitle &&
            lhs.itemSubTitleWithBadge == rhs.itemSubTitleWithBadge &&
            lhs.itemSubtitleWithBadgeCountOne == rhs.itemSubtitleWithBadgeCountOne &&
            lhs.imageName == rhs.imageName &&
            lhs.category == rhs.category &&
            lhs.trayActionKey == rhs.trayActionKey &&
            lhs.badge == rhs.badge &&
            lhs.showBadge == rhs.showBadge &&
            lhs.imageViewAnimation == rhs.imageViewAnimation &&
            lhs.image == rhs.image &&
            lhs.customizeText == rhs.customizeText &&
            lhs.customizeActionKey == rhs.customizeActionKey &&
            lhs.expandedItemActionKey == rhs.expandedItemActionKey
    }
}
