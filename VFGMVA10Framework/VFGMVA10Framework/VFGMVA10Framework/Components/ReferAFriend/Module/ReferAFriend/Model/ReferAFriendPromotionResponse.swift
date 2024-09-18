//
//  ReferAFriendPromotionResponse.swift
//  VFGMVA10Framework
//
//  Created by Abdullah Soylemez on 6.05.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// Refer a friend promotion response.
public struct ReferAFriendPromotionResponse: Codable {
    /// Id.
    let id: String?
    /// Reference link.
    let href: String?
    /// Description.
    let description: String?
    /// Name.
    let name: String?
    /// Invitation type.
    let type: String?
}
