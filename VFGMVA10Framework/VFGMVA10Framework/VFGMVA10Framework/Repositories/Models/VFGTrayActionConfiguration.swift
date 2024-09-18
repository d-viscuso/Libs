//
//  VFGTrayActionConfiguration.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 08/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

/// Configuration for the Sub-Tray action button.
public struct VFGTrayActionConfiguration: Codable {
    /// Key to determine the which action will happen when we press on the button.
    public var subTrayActionKey: String?
    /// Title of the Sub-Tray action button.
    public var subTrayActionTitle: String?
    /// *VFGTrayActionConfiguration* initializer
    /// - Parameters:
    ///    - subTrayActionKey: Key to determine the which action will happen when we press on the button
    ///    - subTrayActionTitle: Title of the sub tray action button
    public init(
        subTrayActionKey: String?,
        subTrayActionTitle: String?
    ) {
        self.subTrayActionKey = subTrayActionKey
        self.subTrayActionTitle = subTrayActionTitle
    }

    enum CodingKeys: String, CodingKey {
        case subTrayActionKey
        case subTrayActionTitle
    }
}
