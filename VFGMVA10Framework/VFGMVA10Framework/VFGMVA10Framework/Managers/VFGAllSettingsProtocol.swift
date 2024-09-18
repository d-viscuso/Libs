//
//  VFGAppSettingsProtocol.swift
//  VFGMVA10Group
//
//  Created by Mahmoud Amer on 4/18/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

public typealias RepositoryCompletion = ((_ result: [String: String]?, _ error: Error?) -> Void)
public typealias VFGComponentEntries = [String: VFGComponentEntry.Type]
public typealias VFGTrayItemsEntries = [String: VFGTrayItemProtocol.Type]
public typealias VFGActions = [String: () -> Void]

public typealias VFGAllSettingsProtocol = VFGAppSettingsProtocol &
    VFGDashboardProtocol & VFGTrayProtocol & VFGEIOProtocol &
    VFGTobiProtocol & VFGStateProtocol

/// Dashboard protocol.
public protocol VFGDashboardProtocol {
    /// Dashboard manager.
    var dashboardManager: VFGDashboardManager? { get }
    /// EIO model.
    var everythingIsOk: VFGEIOModelProtocol { get }
    /// *VFGComponentEntries* is a typealias for *[String: VFGComponentEntry.Type]*. *componentEntries* should return  a dictionary of all *componentId* of *VFGDashboardItem* and their corresponding card types.
    func componentEntries() -> VFGComponentEntries
    /// *VFGActions* is a typealias for *[String: () -> Void]*. *dashboardActions* should return a dictionary of all *actionId* of *VFGSubItem* and their corresponding actions.
    func dashboardActions() -> VFGActions
    func refreshContent(completion: @escaping () -> Void)
}

extension VFGDashboardProtocol {
    public func refreshContent(completion: () -> Void) {
        completion()
    }
}

extension VFGEmptySettingsProtocol where MainClass: VFGDashboardProtocol {
    var dashboardSettings: VFGDashboardProtocol {
        return shared
    }
}

/// Tray Protocol.
public protocol VFGTrayProtocol {
    /// Subtray data source.
    var subtrayDataSource: VFGSubtrayViewDataSource? { get }
    /// A method used to return tray item entries.
    /// - Returns: *VFGTrayItemsEntries* is a typealias for *[String: VFGTrayItemProtocol.Type]*.
    func trayItemsEntries() -> VFGTrayItemsEntries
    /// A method used to return tray actions that will occur when we press on each tray item.
    /// - Returns: *VFGActions* is a typealias for *[String: () -> Void]*.
    func trayActions() -> VFGActions
    /// A method used to return subtray actions that will occur when we press on each subtray item.
    /// - Parameters:
    ///    - type: Type of the subtray action.
    ///    - delegate: Subtray item action delegate.
    /// - Returns: *VFGActions* is a typealias for *[String: () -> Void]*.
    func subTrayItemsActions(
        _ type: VFGSubTrayActionType,
        _ delegate: VFGSubTrayItemActions?
    ) -> VFGActions
}

public extension VFGTrayProtocol {
    func subTrayItemsActions(
        _ type: VFGSubTrayActionType,
        _ delegate: VFGSubTrayItemActions?
    ) -> VFGActions {
        [:]
    }
}

/// Purchase protocol.
public protocol VFGPurchaseProtocol {
    /// Method to setup the purchase module.
    func setupPurchaseModule()
    /// A method used to return swap plan view controller.
    /// - Returns: *UIViewController* that represents *SwapPlanComparisonViewController*.
    func swapPlanComparisonViewController() -> UIViewController
}

extension VFGEmptySettingsProtocol where MainClass: VFGTrayProtocol {
    var traySettings: VFGTrayProtocol {
        return shared
    }
}

/// Everything is Ok protocol.
public protocol VFGEIOProtocol: AnyObject {
    /// A method used to return tray actions that will occur when we press on each everything is Ok item.
    /// - Returns: *VFGActions* is a typealias for *[String: () -> Void]*.
    func eiokActions() -> VFGActions
}

extension VFGEmptySettingsProtocol where MainClass: VFGEIOProtocol {
    var eioSettings: VFGEIOProtocol {
        return shared
    }
}

/// Tobi protocol.
public protocol VFGTobiProtocol: AnyObject {
    /// A method used to return the state of tobi if enabled or not.
    /// - Returns: *Bool* that is true if tobi is enabled or false if tobi is not enabled, default is false.
    func isTOBIEnabled() -> Bool
    /// A method used to return tobi help view controller.
    /// - Parameters:
    ///    - forViewController: Name of view controller where you open tobi's help from.
    /// - Returns: *UIViewController* where you implement tobi's help.
    func helpViewController(for forViewController: String) -> UIViewController?
}

extension VFGEmptySettingsProtocol where MainClass: VFGTobiProtocol {
    var tobiSettings: VFGTobiProtocol {
        return shared
    }
}

/// State protocol.
public protocol VFGStateProtocol: AnyObject {
    /// State manager.
    var stateManager: StateManager { get }
    /// List of application's flow states.
    var appFlowStates: [AppStateDelegate] { get }
    /// Content state.
    var contentState: VFGContentState { get set }
}

extension VFGEmptySettingsProtocol where MainClass: VFGStateProtocol {
    var stateSettings: VFGStateProtocol {
        return shared
    }
}

/// Application settings protocol.
public protocol VFGAppSettingsProtocol: AnyObject {
    /// Boolean that determines whether shaking application is enabled or not.
    var shakingEnabled: Bool { get set }
    /// Method used to initialize the application.
    /// - Parameters:
    ///    - onCompletion: *(() -> Void)*.
    func initializeApp(onCompletion: @escaping (() -> Void))
    /// Method to present message center view controller.
    func presentMessageCenterViewController()
    /// Method to present message center view controller.
    func presentMessageCenterViewController(notificationMessageId: String?)
    /// Method to present application settings.
    func presentSettings()
    /// Method to reset the application.
    func resetApp()
}

/// Empty settings protocol.
extension VFGEmptySettingsProtocol where MainClass: VFGAppSettingsProtocol {
    var appSettings: VFGAppSettingsProtocol {
        return shared
    }
}

public protocol VFGEmptySettingsProtocol: AnyObject {
    // Don't Add any properties here, this protocol is not an existential.
    // Can't be used as a type
    associatedtype MainClass
    var shared: MainClass { get }
}

public extension VFGDashboardProtocol {
    var targetComponentEntries: VFGComponentEntries {
        var shimmerdEntries = VFGComponentEntries()
        let components: [String: VFGComponentEntry.Type] = [
            "load-component-usage-card": DashboradUsageShimmerdCard.self,
            "load-component-second-card": DashboardSecondShimmerdCard.self,
            "load-component-my-offer-card": DashboardThirdShimmerdCard.self,
            "load-component-top-up-card": DashboardFourthShimmerdCard.self,
            "load_upgrade_component": VFGUpgradeShimmerdCard.self
        ]
        let mva12Components: [String: VFGComponentEntry.Type] = [
            "load-component-scrollable-card": VFGScrollableCardShimmerdCard.self,
            "load-component-stories-card": VFGStoriesShimmerdCard.self,
            "load-component-highlight-card": VFGHighlightShimmerdCard.self,
            "load-component-category-card": VFGCategoryShimmerdCard.self,
            "load-component-horizontal-discover-card": VFGHorizontalDiscoverShimmerCard.self
        ]
        shimmerdEntries = componentEntries()
        shimmerdEntries.merge(components) { _, new in new }
        shimmerdEntries.merge(mva12Components) { _, new in new }
        return shimmerdEntries
    }
}

public extension VFGAppSettingsProtocol {
    func presentMessageCenterViewController() {
        presentMessageCenterViewController(notificationMessageId: nil)
    }
    func presentMessageCenterViewController(notificationMessageId: String?) {}
    func resetApp() {}

    func configure(onCompletion: @escaping (() -> Void)) {
        initializeApp {
            onCompletion()
        }
    }
}


public extension VFGTobiProtocol {
    func isTOBIEnabled() -> Bool {
        return false
    }
}
