//
//  ReferAFriendViewModel.swift
//  VFGReferAFriend
//
//  Created by Mustafa Güneş on 13.01.2021.
//

import VFGMVA10Foundation

/// Refer a friend view model.
public class VFGReferAFriendViewModel: VFGReferAFriendViewModelProtocol {
    // MARK: - Protocol
    public var inviteType: VFGReferAFriendInviteType = .referAFriend
    public var referralsModel: VFGReferAFriendResponse?
    /// Analytics manager.
    public static var analyticsManager = VFGAnalyticsManager.self
    static let journeyType = "analytics_framework_page_name_refer_a_friend".localized(bundle: .mva10Framework)

    public func create(with model: VFGReferAFriendResponse?, inviteType: VFGReferAFriendInviteType) {
        self.referralsModel = model
        self.inviteType = inviteType
    }

    // MARK: - Init
    public init() {}

    /// Action to track users data.
    /// - Parameters:
    ///     - event: Event that you eant to track.
    ///     - eventLabel: Event label.
    public static func trackAction(event: String, eventLabel: String, pageName: String) {
        let parameters: [String: String] = [
            VFGAnalyticsKeys.journeyType: journeyType,
            VFGAnalyticsKeys.pageName: pageName,
            VFGAnalyticsKeys.eventAction: EventAction.onClick.rawValue,
            VFGAnalyticsKeys.eventCategory: EventCategory.button.rawValue,
            VFGAnalyticsKeys.eventLabel: eventLabel
        ]

        analyticsManager.trackEvent(event: event, parameters: parameters, bundle: .mva10Framework)
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
