//
//  ProductsManager.swift
//  VFGMVA10Framework
//
//  Created by Moataz Akram on 15/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

class ProductsManager {
    private init() {}
    private static let journeyType = "analytics_framework_journey_type_product_and_services".localized(
        bundle: .mva10Framework
    )
    public static var analyticsManager = VFGAnalyticsManager.self
    public class func trackView(pageName: String) {
        let parameters: [String: Any] = [
            VFGAnalyticsKeys.pageName: pageName,
            VFGAnalyticsKeys.journeyType: journeyType
        ]
        analyticsManager.trackView( parameters: parameters, bundle: .mva10Framework)
    }
    /// Analytics track action section
    /// - Parameters:
    ///    - eventLabel: Current event name
    ///    - pageName: Name of the page that is being tracked
    public class func trackEvent(eventName: String, eventLabel: String, pageName: String) {
        let parameters: [String: Any] = [
            VFGAnalyticsKeys.pageName: "analytics_framework_product_and_service_page_section"
                .localized(bundle: .mva10Framework) + ":" + eventName,
            VFGAnalyticsKeys.journeyType: journeyType,
            VFGAnalyticsKeys.eventAction: EventAction.onClick.rawValue,
            VFGAnalyticsKeys.eventCategory: "Tab",
            VFGAnalyticsKeys.pageSection: "analytics_framework_product_and_service_page_section"
                .localized(bundle: .mva10Framework) + ":" + eventName,
            VFGAnalyticsKeys.eventLabel: eventLabel,
            "page_channel": "analytics_framework_product_and_service_page_channel"
                .localized(bundle: .mva10Framework),
            "page_locale": "analytics_framework_product_and_service_locale"
                .localized(bundle: .mva10Framework)
        ]
        analyticsManager.trackEvent(
            parameters: parameters,
            bundle: .mva10Framework
        )
    }
}
