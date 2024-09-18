//
//  PrivacySettingsModel.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 13/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

public struct PrivacySettingsModel: Codable {
    let header: String
    let contents: [PrivacySettingsContentModel]
}

public struct PrivacySettingsContentModel: Codable {
    let id, title, description: String
    let actionIcon, actionTitle, actionKey: String
    let actionIconDescription: String?
}
