//
//  VFQuickActionsEventsManager.swift
//  VFGMVA10Foundation
//
//  Created by Amr Koritem on 31/05/2022.
//

public protocol VFQuickActionsEventsProtocol: AnyObject {
    func getActionEvent(for actionType: VFQuickActionTypes) -> VFQuickActionsEvent?
}

public enum VFQuickActionTypes {
    case dismiss
    case back
    case header
}

public struct VFQuickActionsEvent {
    let journeyType: JourneyType
    let event: String
    let eventLabel: String
}

/// A manager to handle quick action screen analytics events
public enum VFQuickActionsEventsManager {
    /// An instance of *VFGAnalyticsManager* to handle tealium analytics
    public static var analyticsManager = VFGAnalyticsManager.self

    /// Action to track users data.
    /// - Parameters:
    ///     - journeyType: Journey type.
    ///     - event: Event that you eant to track.
    ///     - eventLabel: Event label.
    public static func trackAction(
        journeyType: JourneyType,
        event: String,
        eventLabel: String
    ) {
        let parameters: [String: String] = [
            VFGAnalyticsKeys.journeyType: journeyType.rawValue,
            VFGAnalyticsKeys.eventAction: EventAction.onClick.rawValue,
            VFGAnalyticsKeys.eventCategory: EventCategory.button.rawValue,
            VFGAnalyticsKeys.eventLabel: eventLabel,
            VFGAnalyticsKeys.pageName: journeyType.rawValue
        ]

        analyticsManager.trackEvent(event: event, parameters: parameters, bundle: .foundation)
    }
}
