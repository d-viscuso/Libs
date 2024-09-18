//
//  VFGReferAFriendMapper.swift
//  VFGMVA10Framework
//
//  Created by Abdullah Soylemez on 6.05.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// Refer a friend mapper.
public class VFGReferAFriendMapper: VFGReferAFriendMapperProtocol {
    public init() {}

    public func createResponseModel(
        using promotionResponse: ReferAFriendPromotionResponse?,
        privacyResponse: ReferAFriendPrivacyResponse?,
        partyResponse: ReferAFriendPartyResponse?,
        cmsResponse: ReferAFriendCMSResponse?
    ) -> VFGReferAFriendResponse? {
        let referralList: [ReferralList]? = partyResponse?.relatedParty?.map {
            ReferralList(referralName: $0.name, referralId: $0.id)
        }
        let promotionContent = PromotionContent(
            promotionLink: promotionResponse?.href,
            activationCount: referralList?.count ?? 0,
            title: promotionResponse?.name,
            buttonText: cmsResponse?.buttonText,
            promotionContentDescription: cmsResponse?.cmsDescription,
            termsAndConditions: privacyResponse?.href,
            imageUrl: cmsResponse?.imageUrl,
            activationCountTxt: cmsResponse?.activationCountText,
            subtitle: promotionResponse?.description,
            shortlink: promotionResponse?.href,
            referralList: referralList
        )
        return VFGReferAFriendResponse(promotionContent: promotionContent)
    }
}
