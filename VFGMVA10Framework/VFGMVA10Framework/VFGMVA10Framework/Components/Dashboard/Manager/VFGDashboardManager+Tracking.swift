//
//  VFGDashboardManager+Tracking.swift
//  VFGMVA10Framework
//
//  Created by Giovanni Romaniello on 30/08/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation


extension VFGDashboardManager {
    /// Action to track users data.
    /// - Parameters:
    ///     - event: Event that you eant to track.
    ///     - eventLabel: Event label.
    ///     - billAmount: Bill amount if the user is a payM suer.
    ///     - billDate: Bill date if the user is a payM suer.
    ///     - data: Dictionary of *[String: String]?* that you want add to your tracking parameters for this event .
    public static func trackAction(
        event: String,
        eventLabel: String,
        billAmount: String? = nil,
        billDate: String? = nil,
        data: [String: String]? = nil
    ) {
        let journeyType = JourneyType.dashboard.rawValue

        var parameters: [String: String] = [
            VFGAnalyticsKeys.journeyType: journeyType,
            VFGAnalyticsKeys.pageName: journeyType + " PAYM",
            VFGAnalyticsKeys.pageSection: journeyType,
            VFGAnalyticsKeys.eventAction: EventAction.swipe.rawValue,
            VFGAnalyticsKeys.eventCategory: EventCategory.carousel.rawValue,
            VFGAnalyticsKeys.eventLabel: eventLabel
        ]

        if billAmount != nil {
            parameters["visitor_bill_amount_current_active"] = billAmount
        }

        if billDate != nil {
            parameters["visitor_bill_date_due_current_active"] = billDate
        }

        parameters[
            "visitor_login_status"
        ] = "analytics_framework_visitor_login_status".localized(bundle: .mva10Framework)

        if let data = data {
            for key in data.keys {
                parameters[key] = data[key]
            }
        }

        analyticsManager.trackEvent(event: event, parameters: parameters, bundle: .mva10Framework)
    }
    /// View action to track users data
    /// - Parameters:
    ///     - billAmount: Bill amount if the user is a payM user
    ///     - data: Dictionary of *[String: String]?* that you want add to your tracking parameters for this event
    public static func trackView(
        billAmount: String,
        data: [String: String]? = nil
    ) {
        let journeyType = JourneyType.dashboard.rawValue

        var parameters: [String: String] = [
            VFGAnalyticsKeys.journeyType: journeyType,
            VFGAnalyticsKeys.pageName: journeyType + " PAYM",
            VFGAnalyticsKeys.pageSection: journeyType
        ]

        parameters["visitor_bill_amount_current_active"] = billAmount
        parameters[
            "visitor_login_status"
        ] = "analytics_framework_visitor_login_status".localized(bundle: .mva10Framework)

        if let data = data {
            for key in data.keys {
                parameters[key] = data[key]
            }
        }

        analyticsManager.trackView(parameters: parameters, bundle: .mva10Framework)
    }
}
