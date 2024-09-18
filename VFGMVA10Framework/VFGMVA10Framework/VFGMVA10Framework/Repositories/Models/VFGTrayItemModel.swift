//
//  VFGTrayItemModel.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 08/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// Main Tray Item Model.
public struct VFGTrayItemModel: Codable {
    /// Tray title.
    public var identifier: String?
    /// Tray title.
    public var title: String?
    /// Tray icon name in assets.
    var iconName: String?
    /// Sub-Tray JSON file name.
    public var subTrayID: String?
    /// Sub-Tray title.
    public var subTrayTitle: String?
    /// Sub-Tray subtitle.
    public var subTraySubtitle: String?
    /// Sub-Tray title in case of zero Sub-Tray items.
    public var subTrayEmptyTitle: String?
    /// Key to determine the which action will happen when we press on Tray item.
    var trayActionKey: String?
    /// Specific action that is linked to specific trayActionKey via VFGActions.
    var trayAction: (() -> Void)?
    /// Configuration for the Sub-Tray action button, if nil the button won't appear.
    public var actionConfiguration: VFGTrayActionConfiguration?
    /// Badge ID that we use to update the badge on the icon.
    var badge: String?
    /// Tray image data to get image in case *iconName* weren't found
    var imageData: Data?
    var isSelected = Dynamic<Bool>(false)
    var icon: UIImage? {
        let image: UIImage?
        if let iconName = iconName {
            image = UIImage.image(named: iconName)
            return image
        } else if let imageData = imageData {
            image = UIImage(data: imageData)
            return image
        }
        return nil
    }
    /// Boolean to determine if the sub tray is expandable or not.
    public var isExpandedTrayEnabled: Bool?
    /// Tray configuration in case of expanded tray.
    public var expandedTrayConfiguration: VFGTrayItemModelConfiguration?
    /// Tray configuration for the business overview case.
    public var businessOverviewConfigurations: BusinessOverviewConfigurations?
    /// Search bar configurations, if the number of  *itemCountThreshold* is smaller than the number of Sub-Tray items the search bar will disappear.
    public var searchConfigurations: VFGTraySearchConfiguration?
    /// Boolean to add customize button below subTray item in case of vertical (expandable) Sub-Tray.
    public var isSubTrayItemCustomizable: Bool?
    /// *VFGTrayItemModel* initializer
    /// - Parameters:
    ///    - title: Tray title
    ///    - iconName: Tray icon name in assets
    ///    - subTrayID: Sub tray JSON file name
    ///    - subTrayTitle: Sub tray title
    ///    - subTraySubtitle: Sub tray subtitle
    ///    - subTrayEmptyTitle: Sub tray title in case of zero sub tray items
    ///    - trayActionKey: Key to determine the which action will happen when we press on tray item
    ///    - trayAction: Specific action that is linked to specific *trayActionKey* via *VFGActions*
    ///    - actionConfiguration: Configuration for the sub tray action button, if nil the button won't appear
    ///    - badge: Badge ID that we use to update the badge on the icon
    ///    - imageData: Tray image data to get image in case *iconName* weren't found
    ///    - isExpandedTrayEnabled: Boolean to determine if the sub tray is expandable or not.
    ///    - expandedTrayConfiguration: Tray configuration in case of expanded tray
    ///    - businessOverviewConfigurations: Tray configuration for the business overview case
    ///    - searchConfigurations: Search bar configurations, if the number of  *itemCountThreshold* is smaller than the number of sub tray items the search bar will disappear
    ///    - isSubTrayItemCustomizable: Boolean to add customize button below sub tray item in case of vertical (expandable) sub tray
    public init(
        identifier: String? = nil,
        title: String? = nil,
        iconName: String? = nil,
        subTrayID: String? = nil,
        subTrayTitle: String? = nil,
        subTraySubtitle: String? = nil,
        subTrayEmptyTitle: String? = nil,
        trayActionKey: String? = nil,
        trayAction: (() -> Void)? = nil,
        actionConfiguration: VFGTrayActionConfiguration? = nil,
        badge: String? = nil,
        imageData: Data? = nil,
        isExpandedTrayEnabled: Bool = false,
        expandedTrayConfiguration: VFGTrayItemModelConfiguration? = nil,
        businessOverviewConfigurations: BusinessOverviewConfigurations? = nil,
        searchConfigurations: VFGTraySearchConfiguration? = nil,
        isSubTrayItemCustomizable: Bool? = nil
    ) {
        self.identifier = identifier
        self.title = title
        self.iconName = iconName
        self.subTrayID = subTrayID
        self.subTrayTitle = subTrayTitle
        self.subTraySubtitle = subTraySubtitle
        self.subTrayEmptyTitle = subTrayEmptyTitle
        self.trayActionKey = trayActionKey
        self.trayAction = trayAction
        self.actionConfiguration = actionConfiguration
        self.badge = badge
        self.imageData = imageData
        self.isExpandedTrayEnabled = isExpandedTrayEnabled
        self.expandedTrayConfiguration = expandedTrayConfiguration
        self.businessOverviewConfigurations = businessOverviewConfigurations
        self.searchConfigurations = searchConfigurations
        self.isSubTrayItemCustomizable = isSubTrayItemCustomizable
    }

    enum CodingKeys: String, CodingKey {
        case identifier
        case title
        case iconName = "icon"
        case subTrayID
        case trayActionKey
        case badge
        case imageData
        case subTrayTitle
        case subTraySubtitle
        case subTrayEmptyTitle
        case isExpandedTrayEnabled
        case expandedTrayConfiguration = "expandedTrayConfig"
        case actionConfiguration
        case businessOverviewConfigurations
        case searchConfigurations = "searchTrayConfig"
        case isSubTrayItemCustomizable
    }
    /// Main tray item model configuration
    public struct VFGTrayItemModelConfiguration: Codable {
        /// Determine if tray has categories or not
        public var isCategoriesEnabled: Bool?
        /// Number of items
        public var itemCountThreshold: Int?
        /// Number of categories
        public var categoriesCountThreshold: Int?
        /// *VFGTrayItemModelConfiguration* initializer
        /// - Parameters:
        ///    - isCategoriesEnabled: Determine if tray has categories or not
        ///    - itemCountThreshold: Number of items
        ///    - categoriesCountThreshold: Number of categories
        public init(
            isCategoriesEnabled: Bool?,
            itemCountThreshold: Int?,
            categoriesCountThreshold: Int?
        ) {
            self.isCategoriesEnabled = isCategoriesEnabled
            self.itemCountThreshold = itemCountThreshold
            self.categoriesCountThreshold = categoriesCountThreshold
        }
    }

/// Tray configuration in the case of business view.
    public struct BusinessOverviewConfigurations: Codable {
        /// Sub-Tray subtitle.
        public var businessTitle: String?
        /// Button text.
        public var buttonText: String?
        /// Key to detrmine the which action will happen when we press on Tray item.
        public var buttonActionKey: String?
        /// Icon name in assets.
        public var businessIcon: String?
        /// Number of the users that appear next to *businessTitle*.
        public var numberOfUsers: String?

        enum CodingKeys: String, CodingKey {
            case businessTitle = "businessTitleKey"
            case buttonText = "buttonTextKey"
            case buttonActionKey
            case businessIcon
            case numberOfUsers
        }
        /// *BusinessOverviewConfigurations* initializer
        /// - Parameters:
        ///    - businessTitle: Sub tray subtitle
        ///    - buttonText: Button text
        ///    - buttonActionKey: Key to determine the which action will happen when we press on Tray item
        ///    - businessIcon: Icon name in assets
        ///    - numberOfUsers: Number of the users that appear next to *businessTitle*
        public init(
            businessTitle: String?,
            buttonText: String?,
            buttonActionKey: String?,
            businessIcon: String?,
            numberOfUsers: String?
        ) {
            self.businessTitle = businessTitle
            self.buttonText = buttonText
            self.buttonActionKey = buttonActionKey
            self.businessIcon = businessIcon
            self.numberOfUsers = numberOfUsers
        }
    }
    /// Tray configuration in the case of search bar
    public struct VFGTraySearchConfiguration: Codable {
        /// Number of items
        public var itemCountThreshold: Int?
        /// *VFGTraySearchConfiguration* initializer
        /// - Parameters:
        ///    - itemCountThreshold: Number of items
        public init(itemCountThreshold: Int?) {
            self.itemCountThreshold = itemCountThreshold
        }

        enum CodingKeys: String, CodingKey {
            case itemCountThreshold
        }
    }
}

extension VFGTrayItemModel {
    /// A dictionary to hold some of tray configurations
    public var trayConfigurations: [String: Any] {
        var configurations: [String: Any] = [:]
        configurations["isExpandedTrayEnabled"] = isExpandedTrayEnabled
        configurations["expandedTrayConfiguration"] = expandedTrayConfiguration
        configurations["businessOverviewConfigurations"] = businessOverviewConfigurations
        configurations["searchConfigurations"] = searchConfigurations
        configurations["isSubTrayItemCustomizable"] = isSubTrayItemCustomizable
        return configurations
    }

    func executeAction(_ actions: VFGActions? = VFGManagerFramework.trayDelegate?.trayActions()) {
        if let actionId = trayActionKey {
            guard let action = actions?[actionId] else {
                VFGDebugLog("no action defined with id:\(actionId)")
                return
            }
            action()
        } else if let action = trayAction {
            action()
        }
    }

    func hasAction() -> Bool {
        return (trayActionKey != nil) || (trayAction != nil)
    }
}
