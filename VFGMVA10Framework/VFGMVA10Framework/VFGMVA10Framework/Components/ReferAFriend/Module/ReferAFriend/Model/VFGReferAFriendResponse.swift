//
//  VFGReferAFriendResponse.swift
//  VFGReferAFriend
//
//  Created by Mustafa Güneş on 19.01.2021.
//

import Foundation

/// Refer a friend response.
public struct VFGReferAFriendResponse: Codable {
    let promotionContent: PromotionContent
    public var termsAndConditionsTitle: String? = "refer_a_friend_read_terms_and_conditions"
        .localized(bundle: .mva10Framework)
    public var isTermsAndConditionsVisible = true

    enum CodingKeys: String, CodingKey {
        case promotionContent
        case termsAndConditionsTitle
    }

    public init(
        promotionContent: PromotionContent,
        termsAndConditionsTitle: String? = "refer_a_friend_read_terms_and_conditions"
            .localized(bundle: .mva10Framework),
        isTermsAndConditionsVisible: Bool = true
    ) {
        self.promotionContent = promotionContent
        self.termsAndConditionsTitle = termsAndConditionsTitle
        self.isTermsAndConditionsVisible = isTermsAndConditionsVisible
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        promotionContent = try container.decode(PromotionContent.self, forKey: .promotionContent)
        if let termsAndConditionsTitle = try? container.decode(String.self, forKey: .termsAndConditionsTitle) {
            self.termsAndConditionsTitle = termsAndConditionsTitle
        } else {
            termsAndConditionsTitle = "refer_a_friend_read_terms_and_conditions".localized(bundle: .mva10Framework)
        }
    }
}

// MARK: - PromotionContent
/// Promotion content.
public struct PromotionContent: Codable {
    /// Promotion URL.
    let promotionLink: String?
    /// Number of friends the user has referred.
    let activationCount: Int
    /// Title.
    let title: String?
    /// Button title.
    let buttonText: String?
    /// Promotion content description.
    let promotionContentDescription: String?
    /// Terms and conditions.
    let termsAndConditions: String?
    /// Image URL.
    let imageUrl: String?
    /// Referrals description.
    let activationCountTxt: String?
    /// Subtitle.
    let subtitle: String?
    /// Short link the user can copy and send.
    let shortlink: String?
    /// Referral list.
    let referralList: [ReferralList]?

    enum CodingKeys: String, CodingKey {
        case promotionLink, activationCount, title, buttonText
        case promotionContentDescription = "description"
        case termsAndConditions
        case imageUrl
        case activationCountTxt
        case subtitle, shortlink, referralList
    }
}

// MARK: - ReferralList
/// Referral list model.
public struct ReferralList: Codable {
    /// Referral name.
    let referralName: String?
    /// Referral Id.
    let referralId: String?
    /// Joining date.
    let joinDate: String?

    init(
        referralName: String? = nil,
        referralId: String? = nil,
        joinDate: String? = nil
    ) {
        self.referralName = referralName
        self.referralId = referralId
        self.joinDate = joinDate
    }
}

extension ReferralList: Equatable {
    public static func == (lhs: ReferralList, rhs: ReferralList) -> Bool {
        return lhs.referralName == rhs.referralName &&
            lhs.referralId == rhs.referralId &&
            lhs.joinDate == rhs.joinDate
    }
}
