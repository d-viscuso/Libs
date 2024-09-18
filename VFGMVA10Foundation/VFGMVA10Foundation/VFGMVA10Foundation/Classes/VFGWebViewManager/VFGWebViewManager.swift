//
//  VFGWebViewManager.swift
//  VFGMVA10Foundation
//
//  Created by Moataz Akram on 16/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

class VFGWebViewManager {
    private init() {}
    private static let pageName = "Web Page"
    public static var analyticsManager = VFGAnalyticsManager.self
    public class func trackView() {
        let parameters: [String: String] = [
            VFGAnalyticsKeys.pageName: pageName,
            VFGAnalyticsKeys.journeyType: pageName
        ]
        analyticsManager.trackView( parameters: parameters, bundle: .foundation)
    }
}
