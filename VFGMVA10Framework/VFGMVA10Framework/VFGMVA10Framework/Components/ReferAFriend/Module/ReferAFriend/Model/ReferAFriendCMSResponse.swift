//
//  ReferAFriendCMSResponse.swift
//  VFGMVA10Framework
//
//  Created by Abdullah Soylemez on 6.05.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// Refer a friend CMS response.
public struct ReferAFriendCMSResponse: Codable {
    /// Id.
    let id: String?
    /// Button title.
    let buttonText: String?
    /// Campaign description.
    let cmsDescription: String?
    /// Image URL.
    let imageUrl: String?
    /// Referrals description.
    let activationCountText: String?

    enum CodingKeys: String, CodingKey {
        case id
        case buttonText
        case cmsDescription = "description"
        case imageUrl
        case activationCountText
    }
}
