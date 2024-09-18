//
//  VFGReferAFriendSuccessViewModel.swift
//  VFGReferAFriend
//
//  Created by Mustafa Güneş on 29.01.2021.
//

import VFGMVA10Foundation

/// Refer a friend success view model.
public class VFGReferAFriendSuccessViewModel: VFGReferAFriendSuccessViewModelProtocol {
    /// Analytics manager.
    public static var analyticsManager = VFGAnalyticsManager.self
    static let journeyType = "analytics_framework_page_name_refer_a_friend_success".localized(bundle: .mva10Framework)

    // MARK: - Init
    public init() {}

    // MARK: - Protocols
    public var name: String?
    public var description: String?
    public var referralsModel: VFGReferAFriendResponse?
    public var inviteType: VFGReferAFriendInviteType = .referAFriend

    public func create(
        with name: String?,
        description: String?,
        model: VFGReferAFriendResponse?,
        inviteType: VFGReferAFriendInviteType
    ) {
        self.name = name
        self.description = description
        self.referralsModel = model
        self.inviteType = inviteType
    }

    /// Action to track users data.
    /// - Parameters:
    ///     - event: Event that you eant to track.
    ///     - eventLabel: Event label.
    public static func trackAction(event: String, eventLabel: String, pageName: String) {
        let parameters: [String: String] = [
            VFGAnalyticsKeys.journeyType: journeyType,
            VFGAnalyticsKeys.pageName: pageName,
            VFGAnalyticsKeys.eventLabel: eventLabel,
            VFGAnalyticsKeys.eventAction: EventAction.onClick.rawValue,
            VFGAnalyticsKeys.eventCategory: EventCategory.button.rawValue
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
