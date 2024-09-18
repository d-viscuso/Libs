//
//  VFGDashboardSections.swift
//  mva10
//
//  Created by Mahmoud Amer on 12/25/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

/// Dashboard sections.
public struct VFGDashboardSections: Codable {
    /// Array of *VFGDashboardSection* each item represents a section in dasgboard.
    public var sections: [VFGDashboardSection]?
}

/// Dashboard section.
public struct VFGDashboardSection: Codable {
    /// Type of the dashboard section: dashboard, discover or none.
    public let type: String
    /// Section title.
    public let title: String
    /// Array of *VFGDashboardItem* each item represents a sub item element inside the same section.
    public var items: [VFGDashboardItem]?
}

/// Dashboard item.
public struct VFGDashboardItem: Codable {
    /// Component Id.
    public let componentId: String
    /// Component action Id.
    public let itemActionId: String?
    /// Dictionary for error in case loading dashboard item data failed
    public var error: [String: Any]?
    /// Dictionary for dashboard item data
    var metaData: [String: Any]?

    enum CodingKeys: CodingKey {
        case componentId
        case metaData
        case itemActionId
        case error
    }
    /// *VFGDashboardItem* initializer
    /// - Parameters:
    ///    - componentId: Component Id
    ///    - metaData: Dictionary for dashboard item data
    ///    - itemActionId: Component action Id
    ///    - error: Dictionary for error in case loading dashboard item data failed
    public init(
        componentId: String,
        metaData: [String: Any]? = nil,
        itemActionId: String? = nil,
        error: [String: Any]? = nil
    ) {
        self.componentId = componentId
        self.metaData = metaData
        self.itemActionId = itemActionId
        self.error = error
    }
    /// *VFGDashboardItem* initializer
    /// Decode a value of the given type for the given key
    /// - Parameters:
    ///    - decoder: A type to decode values from *CodingKeys*
    /// - Throws: Error if failed
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.componentId = try container.decode(String.self, forKey: .componentId)
        self.metaData = try? container.decode([String: Any].self, forKey: .metaData)
        self.itemActionId = try? container.decode(String.self, forKey: .itemActionId)
        self.error = try? container.decode([String: Any].self, forKey: .error)
    }
    /// Encode the given value for the given key
    /// - Parameters:
    ///    - encoder: A type to encode values into *CodingKeys*
    /// - Throws: Error if failed
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.componentId, forKey: .componentId)
    }
}

/// Sub item model used for related app cells or grouped items view.
public struct VFGSubItem: Codable {
    /// App title.
    public let title: String?
    /// App icon name in assets.
    public let icon: String?
    /// App Id, used to open the app store on the wanted app if it was not installed of the users device.
    public let appId: String?
    /// App Schema, should be added to *Info.plist* file as well.
    public let appSchema: String?
    /// Action Id.
    public let actionId: String?
    /// App link in device if it's installed, will make the action to open the app, if the app is not installed will make the action to open the app store on the apps page.
    public let link: String?
    /// Initial badge value.
    public var initialBadgeValue: Int?
    /// Badge Id.
    public var badgeId: String?

    public init(title: String?, icon: String?, appId: String?, appSchema: String?, actionId: String?, link: String?, initialBadgeValue: Int? = nil, badgeId: String? = nil) {
        self.title = title
        self.icon = icon
        self.appId = appId
        self.appSchema = appSchema
        self.actionId = actionId
        self.link = link
        self.initialBadgeValue = initialBadgeValue
        self.badgeId = badgeId
    }
}
