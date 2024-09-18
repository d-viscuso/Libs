//
//  VFGReferAFriendTermsViewModel.swift
//  VFGReferAFriend
//
//  Created by Mustafa Güneş on 27.01.2021.
//

import VFGMVA10Foundation

/// Refer a friend terms view model.
class VFGReferAFriendTermsViewModel: VFGReferAFriendTermsViewModelProtocol {
    /// Analytics manager.
    public static var analyticsManager = VFGAnalyticsManager.self
    static let journeyType = "analytics_framework_page_name_refer_a_friend_terms".localized(bundle: .mva10Framework)

    // MARK: - Init
    public init() {}

    // MARK: - Protocol
    var termsText: String?

    func create(with text: String?) {
        self.termsText = text
    }

    /// View action to track users data
    /// - Parameters:
    ///     - billAmount: Bill amount if the user is a payM user
    ///     - data: Dictionary of *[String: String]?* that you want add to your tracking parameters for this event
    public static func trackView(pageName: String) {
        let parameters: [String: String] = [
            VFGAnalyticsKeys.journeyType: journeyType,
            VFGAnalyticsKeys.pageName: pageName
        ]

        analyticsManager.trackView(parameters: parameters, bundle: .mva10Framework)
    }
}
