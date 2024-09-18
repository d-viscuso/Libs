//
//  VFGReferAFriendMapperProtocol.swift
//  VFGMVA10Framework
//
//  Created by Abdullah Soylemez on 6.05.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// Refer a friend mapper protocol.
public protocol VFGReferAFriendMapperProtocol {
    /// Method that returns the referral response.
    /// - Parameters:
    ///     - promotionResponse: *ReferAFriendPromotionResponse?*.
    ///     - privacyResponse: *ReferAFriendPrivacyResponse?*.
    ///     - partyResponse: *ReferAFriendPartyResponse?*.
    ///     - cmsResponse: *ReferAFriendCMSResponse?*.
    func createResponseModel(
        using promotionResponse: ReferAFriendPromotionResponse?,
        privacyResponse: ReferAFriendPrivacyResponse?,
        partyResponse: ReferAFriendPartyResponse?,
        cmsResponse: ReferAFriendCMSResponse?
    ) -> VFGReferAFriendResponse?
}
