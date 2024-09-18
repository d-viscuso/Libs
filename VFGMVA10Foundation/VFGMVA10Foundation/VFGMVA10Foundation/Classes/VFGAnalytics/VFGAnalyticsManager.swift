//
//  VFGAnalyticsManager.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed ELMeseery on 6/19/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation


/// `AnalyticsManager` is a class taking care of managing your different analytics providers.
/// No matter how many providers you use, it will take care of configuring every one of them
/// and notifying them on every event you wish to track within your app
open class VFGAnalyticsManager {
    var providers: [VFGAnalyticsProvider]
    private let queue: OperationQueue
    static var shared = VFGAnalyticsManager()

    private init() {
        providers = []
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .background
    }

    /// A method used to add different analytics providers
    /// After adding analytics provider it takes care of configure and notify it on every event
    /// - Parameters:
    ///   - providers: A list of analytics provider
    ///   - completion: A closure that gets invoked after add analytics providers
    public class func add(_ providers: [VFGAnalyticsProvider], completion: (() -> Void)? = nil) {
        VFGAnalyticsManager.shared.add(providers, completion: completion)
    }

    private func add(_ providers: [VFGAnalyticsProvider], completion: (() -> Void)? = nil) {
        queue.addOperation { [weak self] in
            guard let `self` = self else { return }
            self.providers.append(contentsOf: providers)
            completion?()
        }
    }

    /// A method used to remove subscribed provider from analytics providers list
    /// - Parameters:
    ///   - provider: Analytics provider object you wish to remove
    ///   - completion: A closure that gets invoked after remove an analytics provider
    public class func remove(_ provider: VFGAnalyticsProvider, completion: (() -> Void)? = nil) {
        VFGAnalyticsManager.shared.remove(provider, completion: completion)
    }

    private func remove(_ provider: VFGAnalyticsProvider, completion: (() -> Void)? = nil) {
        queue.addOperation { [weak self] in
            guard let `self` = self else { return }
            self.providers.removeAll { $0.identifier == provider.identifier }
            completion?()
        }
    }

    /// A method used to stop all analytics events.
    /// This will clear the list of providers therefore not allowing analytics to be sent
    /// - Parameter completion: A closure that gets invoked after reset analytics providers list
    public class func reset(completion: (() -> Void)? = nil) {
        VFGAnalyticsManager.shared.reset(completion: completion)
    }

    private func reset(completion: (() -> Void)? = nil) {
        queue.addOperation { [weak self] in
            guard let `self` = self else { return }
            self.providers.removeAll()
            completion?()
        }
    }

    fileprivate static func setupComponentParameters(_ finalParameters: inout [String: Any], _ bundle: Bundle) {
        finalParameters["component_owner"] = "OnePlatform"
        finalParameters["component_name"] = bundle.applicationName.lowercased()
            .replacingOccurrences(of: "vfgmva10", with: "")
        finalParameters["component_version"] = bundle.appShortVersion
    }

    /// A method used to receive analytics view events and allows you to send them to any tag manager
    /// - Parameters:
    ///   - event: An analytics view event
    ///   - parameters: Any editional parameters you send to notify tag manager
    ///   - bundle: A bundle object used to extract data, including component name and component version
    ///   - completion: A closure that gets invoked after sending an event
    open class func trackView(
        event: String = "page_view",
        parameters: [String: Any] = [:],
        bundle: Bundle?,
        completion: (() -> Void)? = nil
    ) {
        var finalParameters = parameters
        if let bundle = bundle,
            Bundle.allVFGBundles.contains(bundle) {
            setupComponentParameters(&finalParameters, bundle)
        }
        VFGAnalyticsManager.shared.track(
            event: event,
            parameters: finalParameters,
            isViewEvent: true,
            completion: completion)
    }

    /// A method used to receive analytics ui interactions events and allows you to send them to any tag manager.
    /// - Parameters:
    ///   - event: An analytics ui interaction event
    ///   - parameters: Any editional parameters you send to notify tag manager
    ///   - bundle: A bundle object used to extract data, including component name and component version
    ///   - completion: A closure that gets invoked after sending an event
    open class func trackEvent(
        event: String = "ui-interaction",
        parameters: [String: Any] = [:],
        bundle: Bundle? = nil,
        completion: (() -> Void)? = nil
    ) {
        var finalParameters = parameters
        if let bundle = bundle,
            Bundle.allVFGBundles.contains(bundle) {
            setupComponentParameters(&finalParameters, bundle)
        }
        VFGAnalyticsManager.shared.track(event: event, parameters: finalParameters, completion: completion)
    }

    private func track(event: String, parameters: [String: Any]? = nil, isViewEvent: Bool = false, completion: (() -> Void)? = nil) {
        guard !providers.isEmpty else {
            VFGErrorLog("Unable to track - no available providers")
            completion?()
            return
        }
        queue.addOperation { [weak self] in
            guard let `self` = self else { return }
            var finalParameters: [String: Any] = [:]
            parameters?.forEach { parameter in
                var newValue = parameter.value
                if let value = parameter.value as? String {
                    newValue = value.localized()
                } else if let value = parameter.value as? [String] {
                    newValue = value.map { $0.localized() }
                }
                finalParameters[parameter.key] = newValue
            }
            self.providers.forEach { provider in
                if isViewEvent {
                    provider.trackView(event, parameters: finalParameters)
                } else {
                    provider.trackEvent(event, parameters: finalParameters)
                }
            }
            completion?()
        }
    }
}

public enum JourneyType: String {
    case onboarding = "Onboarding"
    case dashboard = "Dashboard"
    case login = "Login"
    case logout = "Logout"
    case billing = "Billing"
    case discover = "Discover"
}

public enum EventAction: String {
    case onClick = "OnClick"
    case onScroll = "OnScroll"
    case swipe = "Swipe"
}

public enum EventCategory: String {
    case button = "Button"
    case carousel = "Carousel"
    case card = "Card"
}
