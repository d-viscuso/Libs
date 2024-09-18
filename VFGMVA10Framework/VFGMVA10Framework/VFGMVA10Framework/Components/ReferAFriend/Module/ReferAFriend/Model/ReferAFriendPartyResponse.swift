//
//  ReferAFriendPartyResponse.swift
//  VFGMVA10Framework
//
//  Created by Abdullah Soylemez on 6.05.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

// MARK: - ReferAFriendPartyResponse
/// Refer a friend party response model.
public struct ReferAFriendPartyResponse: Codable {
    /// Id
    let id: String?
    /// List of related parties.
    let relatedParty: [ReferAFriendRelatedParty]?
}

// MARK: - ReferAFriendRelatedParty
/// Refer a friend related party model.
public struct ReferAFriendRelatedParty: Codable {
    /// Id.
    let id: String?
    /// Name.
    let name: String?
    /// Role.
    let role: String?
}
