//
//  VFGAnalyticsProvider.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed ELMeseery on 6/19/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

/// `AnalyticsProvider` is abstract analytics provider that can be e.g.(Tealium, GoogleAnalytics, Smapi, Drift...).
public protocol VFGAnalyticsProvider {
    /// Provider identifier
    var identifier: String { get set }
    /// Method used to handle views tracking logic
    func trackView(_ view: String, parameters: [String: Any]?)
    /// Method used to handle events tracking logic
    func trackEvent(_ event: String, parameters: [String: Any]?)
}
