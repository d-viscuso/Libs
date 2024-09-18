//
//  VFGSubTrayItem.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 08/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Sub tray data model
public class VFGSubTrayItem: Codable {
    /// Sub-Tray item ID.
    public var itemID: String?
    /// Phone number if the Sub-Tray item has a phone number.
    public var phoneNumber: String?
    /// Title of the Sub-Tray item.
    public var title: String?
    /// Subtitle in case of no badge, or with badge but without *itemSubTitleWithBadge* or *itemSubtitleWithBadgeCountOne*.
    var subTitle: String?
    /// Subtitle in case of badge and the counter is more than one, and when the counter is one and there's no *itemSubtitleWithBadgeCountOne*.
    var itemSubTitleWithBadge: String?
    /// Subtitle in case of badge with counter of one.
    var itemSubtitleWithBadgeCountOne: String?
    /// Icon name in assets.
    var imageName: String?
    /// Category of the vertical Sub-Tray view *VFGVerticalSubTrayViewTabCategoryUIModel*
    var category: String?
    /// Key to determine the which action will happen when we press on the Sub-Tray item.
    var trayActionKey: String?
    /// Specific action that is linked to specific trayActionKey via VFGActions.
    var trayAction: (() -> Void)?
    /// Badge ID that we use to update the badge on the icon.
    var badge: String?
    /// Boolean that is responsible for showing the default image icon (a star shape in the top-right corner of the cell) on the Sub-Tray cell, default is false.
    public var isDefault: Bool? = false
    /// Boolean that is responsible for showing and hiding the badge icon on the Sub-Tray view, default is true.
    var showBadge: Bool? = true
    /// Animation type that could be applied to the Sub-Tray image.
    var imageViewAnimation: VFGAnimationType?
    /// Sub-Tray image data to get image in case *imageName* weren't found
    var imageData: Data?
    /// Sub-Tray image.
    var image: UIImage? {
        let image: UIImage?
        if let imageName = imageName {
            image = UIImage.image(named: imageName)
            return image
        } else if let imageData = imageData {
            image = UIImage(data: imageData)
            return image
        }
        return nil
    }
    /// Text on the customize button.
    var customizeText: String?
    /// Key to determine the which action will happen when we press on the button on the Sub-Tray item.
    var customizeActionKey: String?
    /// List of expanded item model.
    var expandedItems: [VFGSubTrayExpandedItemModel]?
    /// Key to determine the which action will happen when we press on of the expanded items.
    var expandedItemActionKey: String?
    /// Determine if sub tray has banner view or not
    var hasBanner: Bool?
    /// Sub tray description
    var description: String?
    /// *VFGSubTrayItem* initializer
    /// - Parameters:
    ///    - itemID: Sub-Tray item ID
    ///    - phoneNumber: Phone number if the Sub-Tray item has a phone number
    ///    - title: Title of the Sub-Tray item
    ///    - subTitle: Subtitle in case of no badge, or with badge but without *itemSubTitleWithBadge* or *itemSubtitleWithBadgeCountOne*
    ///    - itemSubTitleWithBadge: Subtitle in case of badge and the counter is more than one, and when the counter is one and there's no *itemSubtitleWithBadgeCountOne*
    ///    - itemSubtitleWithBadgeCountOne: Subtitle in case of badge with counter of one
    ///    - imageName: Icon name in assets
    ///    - category: Category of the vertical Sub-Tray view *VFGVerticalSubTrayViewTabCategoryUIModel*
    ///    - trayActionKey: Key to determine the which action will happen when we press on the Sub-Tray item
    ///    - trayAction: Specific action that is linked to specific trayActionKey via VFGActions
    ///    - badge: Badge ID that we use to update the badge on the icon
    ///    - isDefault: Boolean that is responsible for showing the default image icon (a star shape in the top-right corner of the cell) on the Sub-Tray cell, default is false
    ///    - showBadge: Boolean that is responsible for showing and hiding the badge icon on the Sub-Tray view, default is true
    ///    - imageViewAnimation: Animation type that could be applied to the Sub-Tray image
    ///    - customizeText: Text on the customize button
    ///    - customizeActionKey: Key to determine the which action will happen when we press on the button on the Sub-Tray item
    ///    - expandedItems: List of expanded item model
    ///    - expandedItemActionKey: Key to determine the which action will happen when we press on of the expanded items
    ///    - hasBanner: Determine if sub tray has banner view or not
    ///    - description: Sub tray description
    public init(
        itemID: String? = nil,
        phoneNumber: String? = nil,
        title: String? = nil,
        subTitle: String? = nil,
        itemSubTitleWithBadge: String? = nil,
        itemSubtitleWithBadgeCountOne: String? = nil,
        imageName: String? = nil,
        imageData: Data? = nil,
        category: String? = nil,
        trayActionKey: String? = nil,
        trayAction: (() -> Void)? = nil,
        badge: String? = nil,
        isDefault: Bool? = false,
        showBadge: Bool,
        imageViewAnimation: VFGAnimationType? = nil,
        customizeText: String? = nil,
        customizeActionKey: String? = nil,
        expandedItems: [VFGSubTrayExpandedItemModel]? = nil,
        expandedItemActionKey: String? = nil,
        hasBanner: Bool = false,
        description: String? = nil
    ) {
        self.itemID = itemID
        self.phoneNumber = phoneNumber
        self.title = title
        self.subTitle = subTitle
        self.itemSubTitleWithBadge = itemSubTitleWithBadge
        self.itemSubtitleWithBadgeCountOne = itemSubtitleWithBadgeCountOne
        self.imageName = imageName
        self.imageData = imageData
        self.category = category
        self.trayActionKey = trayActionKey
        self.trayAction = trayAction
        self.badge = badge
        self.isDefault = isDefault
        self.showBadge = showBadge
        self.imageViewAnimation = imageViewAnimation
        self.customizeText = customizeText
        self.customizeActionKey = customizeActionKey
        self.expandedItems = expandedItems
        self.expandedItemActionKey = expandedItemActionKey
        self.hasBanner = hasBanner
        self.description = description
    }

    enum CodingKeys: String, CodingKey {
        case itemID
        case phoneNumber
        case title = "itemTitle"
        case subTitle = "itemSubTitle"
        case itemSubTitleWithBadge
        case imageName = "itemImage"
        case imageData
        case category = "itemCategory"
        case trayActionKey
        case badge
        case isDefault
        case showBadge
        case imageViewAnimation
        case itemSubtitleWithBadgeCountOne
        case customizeText = "itemCustomizeText"
        case customizeActionKey = "itemCustomizeActionKey"
        case expandedItems
        case expandedItemActionKey
        case hasBanner
        case description = "itemDescription"
    }
}

extension VFGSubTrayItem {
    var formattedSubTitle: String? {
        switch badge {
        case SubTrayBadge.paymentMethods.rawValue where (VFGPaymentManager.paymentProvider?.numberOfCards ?? 0) > 0:
            guard let numberOfCards = VFGPaymentManager.paymentProvider?.numberOfCards else {
                return ""
            }

            if numberOfCards == 1 {
                return itemSubtitleWithBadgeCountOne?.localized(bundle: .mva10Framework)
            } else if numberOfCards > 0,
                let subTitleWithCounter = itemSubTitleWithBadge?.localized() {
                return String(format: subTitleWithCounter, "\(numberOfCards)")
            }
        case SubTrayBadge.addresses.rawValue:
            guard let model = VFGMyAddressManager.myAddress else {
                return subTitle?.localized(bundle: .mva10Framework)
            }
            var addressString = "\(model.houseNumber) \(model.streetName), "
            addressString += "\(model.city) \(model.postcode), "
            addressString += "\(model.country)"
            return addressString

        case  SubTrayBadge.myOrders.rawValue:
            return getMyOrdersSubTitle()

        default:
            return subTitle?.localized(bundle: .mva10Framework)
        }
        return nil
    }

    private func getMyOrdersSubTitle() -> String {
        let noOrderInProgress = "sub_tray_my_orders_subtitle_no_order".localized(bundle: .mva10Framework)

        guard let numberOfInProgressOrders = VFGMyOrdersManager.shared.dataProvider?.numberOfInProgressOrders else {
            return noOrderInProgress
        }

        if numberOfInProgressOrders == 1 {
            let subtitleWithOneBadge = itemSubtitleWithBadgeCountOne?.localized(bundle: .mva10Framework) ?? ""
            return String(format: subtitleWithOneBadge, "\(numberOfInProgressOrders)")
        } else if numberOfInProgressOrders > 1 {
            let subTitleWithCounter = itemSubTitleWithBadge?.localized(bundle: .mva10Framework) ?? ""
            return String(format: subTitleWithCounter, "\(numberOfInProgressOrders)")
        }

        return noOrderInProgress
    }
}

extension VFGSubTrayItem {
    var hasExpandedItems: Bool {
        return !expandedItems.isEmptyOrNil
    }

    var isExpandableItem: Bool {
        return expandedItems != nil
    }
}
