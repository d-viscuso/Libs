//
//  AppSettingsManager.swift
//  VFGMVA10Framework
//
//  Created by Moataz Akram on 11/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
/// App settings screens manager
class AppSettingsManager {
    private init() {}
    private static let journeyType = "analytics_framework_journey_type_app_settings".localized(bundle: .mva10Framework)
    /// Analytic manager for *AppSettingsManager*
    public static var analyticsManager = VFGAnalyticsManager.self
    /// Analytics track view action
    /// - Parameters:
    ///    - pageName: Name of the page that is being tracked
    public class func trackView(pageName: String) {
        let parameters: [String: String] = [
            VFGAnalyticsKeys.pageName: pageName,
            VFGAnalyticsKeys.journeyType: journeyType
        ]
        analyticsManager.trackView(parameters: parameters, bundle: .mva10Framework)
    }
    /// Analytics track action
    /// - Parameters:
    ///    - eventLabel: Current event name
    ///    - pageName: Name of the page that is being tracked
    public class func trackAction(eventLabel: String, pageName: String) {
        let parameters: [String: String] = [
            VFGAnalyticsKeys.pageName: pageName,
            VFGAnalyticsKeys.eventLabel: eventLabel,
            VFGAnalyticsKeys.journeyType: journeyType
        ]
        analyticsManager.trackEvent(parameters: parameters)
    }
}
