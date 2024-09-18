//
//  VFGStoryManager.swift
//  VFGStory
//
//  Created by Mithat Samet Kaskara on 10.02.2021.
//

import Foundation
import VFGMVA10Foundation
/// Delegation protocol for *VFGStoryManager*
public protocol VFGStoryManagerProtocol: AnyObject {
    /// *VFGStoryManager* data provider
    var dataProvider: VFGStoryDataProviderProtocol? { get }
    /// *VFGStoryManager* story content button action
    var storyContentButtonTapped: ((Story) -> Void)? { get }
}
/// Stories journey manager
public class VFGStoryManager: VFGStoryManagerProtocol {
    public var dataProvider: VFGStoryDataProviderProtocol?
    public var storyContentButtonTapped: ((Story) -> Void)?
    /// An instance for *VFGAnalyticsManager* to perform analytics tracking
    public static var analyticsManager = VFGAnalyticsManager.self
    /// *VFGStoryManager* initializer
    /// - Parameters:
    ///    - dataProvider: *VFGStoryManager* data provider
    ///    - storyContentButtonTapped: *VFGStoryManager* story content button action
    public init(
        dataProvider: VFGStoryDataProviderProtocol? = nil,
        storyContentButtonTapped: ((Story) -> Void)? = nil
    ) {
        self.dataProvider = dataProvider
        self.storyContentButtonTapped = storyContentButtonTapped
    }
}
// MARK: Tealium analytics track functions
extension VFGStoryManager {
    /// Responsible for tealium analytics track
    /// - Parameters:
    ///    - screenName: Current screen name parameter for tealium analytics track
    ///    - pageSection: Current page section parameter for tealium analytics track
    ///    - completion: Optional closure to handle more tealium analytics operations
    static func trackView(screenName: String, parameters: [String: String]?, completion: (() -> Void)? = nil) {
        VFGStoryManager.analyticsManager.trackView(
            event: screenName,
            parameters: parameters ?? [:],
            bundle: .mva10Framework,
            completion: completion
        )
    }
    /// Responsible for tealium analytics track
    /// - Parameters:
    ///    - screenName: Current screen name parameter for tealium analytics track
    ///    - pageSection: Any editional parameters you send to notify tag manager
    ///    - completion: Optional closure to handle more tealium analytics operations
    static func trackEvent(screenName: String, parameters: [String: String]?, completion: (() -> Void)? = nil) {
        VFGStoryManager.analyticsManager.trackEvent(
            event: screenName,
            parameters: parameters ?? [:],
            bundle: .mva10Framework,
            completion: completion
        )
    }
}
