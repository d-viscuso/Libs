//
//  ProductSwitcherCardModel.swift
//  VFGMVA10Framework
//
//  Created by Tuncel, Pelin, Vodafone on 8/15/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

/// Product Switcher card model
public struct ProductSwitcherCardModel {
    /// Cards to be displayed in products and services
    var cards: [ProductSwitcherCardItemModel]?
    /// If true then address filter tabs will be shown
    var isAddressFilterEnabled = false
    /// If true then search bar will be shown
    var isSearchEnabled = false
    /// If true then category filter tabs will be shown
    var isCategoryFilterEnabled = false
    /// If true then edit name button will be displayed on all items
    var isEditNameEnabled = false
    /// If true then starred button will be displayed on all items
    var isStarredEnabled = false

    public init(
        cards: [ProductSwitcherCardItemModel],
        isAddressFilterEnabled: Bool = false,
        isSearchEnabled: Bool = false,
        isCategoryFilterEnabled: Bool = false,
        isEditNameEnabled: Bool = false,
        isStarredEnabled: Bool = false
    ) {
        self.cards = cards
        self.isAddressFilterEnabled = isAddressFilterEnabled
        self.isSearchEnabled = isSearchEnabled
        self.isCategoryFilterEnabled = isCategoryFilterEnabled
        self.isEditNameEnabled = isEditNameEnabled
        self.isStarredEnabled = isStarredEnabled
    }
}

/// Product Switcher card item model
public struct ProductSwitcherCardItemModel {
    /// Content model from DXL response for the card item
    var contentModel: ProductSwitcherModel
    /// Subtitle for product or service
    var subtitle: NSMutableAttributedString?
    /// Product or service type
    var type: ProductSwitcherCardItemContentType = .usage
    /// Product or service's content items
    var contentItems: [ProductSwitcherContentItem]
    /// Edit action for the card
    var editAction: () -> Void
    /// Starred action for the card
    var starredAction: () -> Void
    /// If true then starred button will be selected
    var isStarred = false
    /// First CTA button action
    var firstCTAAction: () -> Void
    /// Second CTA button action
    var secondCTAAction: (() -> Void)?

    public init(
        contentModel: ProductSwitcherModel,
        contentItems: [ProductSwitcherContentItem],
        subtitle: NSMutableAttributedString?,
        editAction: @escaping () -> Void,
        starredAction: @escaping () -> Void = { },
        isStarred: Bool = false,
        firstCTAAction: @escaping () -> Void,
        secondCTAAction: (() -> Void)?
    ) {
        self.contentModel = contentModel
        self.contentItems = contentItems
        self.subtitle = subtitle
        self.editAction = editAction
        self.starredAction = starredAction
        self.isStarred = isStarred
        self.firstCTAAction = firstCTAAction
        self.secondCTAAction = secondCTAAction
        if let type = ProductSwitcherCardItemContentType(rawValue: contentModel.type) {
            self.type = type
        }
    }
}

/// Product Switcher card item type
public enum ProductSwitcherCardItemContentType: String {
    case usage
    case service
    case credit
}
/// Products and services content item
public struct ProductSwitcherContentItem {
    /// Icon of the content
    var icon: UIImage?
    /// Title of the content
    var title: String?
    /// Description of the content
    var desc: String?
    /// Description of the content
    var descStatus: String?
    /// Usage ratio for the content
    var progressRatio: Float?
    /// Desc attributed for the content
    var descAttributedString: NSAttributedString?
    /// Type attributed for the content
    var type: ProductSwitcherCardItemContentType = .usage

    public init(
        icon: UIImage?,
        title: String?,
        desc: String?,
        descStatus: String? = nil,
        progressRatio: Float?,
        descAttributedString: NSAttributedString? = nil,
        type: ProductSwitcherCardItemContentType = .usage
    ) {
        self.icon = icon
        self.title = title
        self.desc = desc
        self.descStatus = descStatus
        self.progressRatio = progressRatio
        self.descAttributedString = descAttributedString
        self.type = type
    }
}

/// Product switcher localization enum
public enum ProductSwitcherLocalize: String {
    case all
    public var localizedString: String {
        switch self {
        case .all:
            return "product_switcher_category_filter_all".localized(bundle: .mva10Framework)
        }
    }
}
