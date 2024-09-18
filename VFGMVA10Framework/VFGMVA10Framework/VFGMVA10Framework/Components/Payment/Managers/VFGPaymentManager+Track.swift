//
//  VFGPaymentManager+Track.swift
//  VFGMVA10Framework
//
//  Created by Moataz Akram on 11/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

extension VFGPaymentManager {
    private static let journeyType = "analytics_framework_journey_type_payment_methods".localized(
        bundle: .mva10Framework
    )
    public static var analyticsManager = VFGAnalyticsManager.self
    public class func trackView(pageName: String) {
        let parameters: [String: String] = [
            VFGAnalyticsKeys.pageName: pageName,
            VFGAnalyticsKeys.journeyType: journeyType
        ]
        analyticsManager.trackView( parameters: parameters, bundle: .mva10Framework)
    }
}
