//
//  VFGBadgesTracker.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 11/15/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

/// A delegate protocol that manages changes in badge view,
/// including badge updates.
public protocol VFGBadgesTrackerDelegate: AnyObject {
    /// Notify the delegate once the badge view is updated.
    /// - Parameters:
    ///   - badgeID: Current updated badge view ID.
    ///   - model: Current updated badge view model.
    func notifyBadgeDidUpdate(with badgeID: String, model: BadgeModel)
}

/// A tracker that is responsible for keeping track of badges values and updating values at any given point.
open class VFGBadgesTracker {
    /// A shared instance of the *VFGBadgesTracker*.
    public static let shared = VFGBadgesTracker()
    /// A delegate of type *VFGBadgesTrackerDelegate*.
    public weak var delegate: VFGBadgesTrackerDelegate?
    var badgesValues: [String: BadgeModel] = [:]

    private init() {}

    /// A method used to update badge values at any given point by providing
    /// badge ID and and updated model object.
    /// - Parameters:
    ///   - badgeID: An ID that represent the badge you want to update.
    ///   - model: An updated model object.
    public func updateBadge(with badgeID: String, model: BadgeModel) {
        VFGBadgesTracker.shared.badgesValues[badgeID] = model
        NotificationCenter.default.post(
            name: .VFGBadgesTrackerID,
            object: self,
            userInfo: badgesValues
        )
        delegate?.notifyBadgeDidUpdate(with: badgeID, model: model)
    }
}
