//
//  ProductSwitcherDXLResponse.swift
//  VFGMVA10Framework
//
//  Created by Loodos on 9/2/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

/// Product Switcher DXL model
public struct ProductSwitcherDXLResponse: Codable {
    /// Products and services items to be displayed
    public var isAddressFilterEnabled: Bool?
    public var isSearchEnabled: Bool?
    public var isCategoryFilterEnabled: Bool?
    public var isEditNameEnabled: Bool?
    public var cards: [ProductSwitcherModel]?
}

/// Product Switcher model
public struct ProductSwitcherModel: Codable {
    /// Id of the product or the service
    public var id: String
    /// Image of the product or the service
    public var image: String
    /// Name of the product or the service given by user
    public var name: String?
    /// Title of the product or service
    public var title: String
    /// Subtitle of the product or service
    public var subtitle: String?
    /// Address of the product or service
    public var address: String?
    /// Category of the product or service
    public var category: String?

    /// Product or service type
    public var type: String
    /// Product or service items/contents
    public var items: [ProductSwitcherContentModel]

    /// Product or service status color representation
    public var statusColor: String?
    /// Product or service status text
    public var statusText: String?

    /// Product or service first cta button
    public var firstCTAButton: ProductSwitcherCTAButtonModel
    /// Product or service second cta button
    public var secondCTAButton: ProductSwitcherCTAButtonModel?
    /// init
    public init(
        id: String,
        image: String,
        name: String? = nil,
        title: String,
        subtitle: String? = nil,
        address: String? = nil,
        category: String? = nil,
        type: String,
        items: [ProductSwitcherContentModel],
        statusColor: String? = nil,
        statusText: String? = nil,
        firstCTAButton: ProductSwitcherCTAButtonModel,
        secondCTAButton: ProductSwitcherCTAButtonModel? = nil
    ) {
        self.id = id
        self.image = image
        self.name = name
        self.title = title
        self.subtitle = subtitle
        self.address = address
        self.category = category
        self.type = type
        self.items = items
        self.statusColor = statusColor
        self.statusText = statusText
        self.firstCTAButton = firstCTAButton
        self.secondCTAButton = secondCTAButton
    }
}

/// Product Switcher content model
public struct ProductSwitcherContentModel: Codable {
    /// Icon for the product or service content
    public var icon: String
    /// Title of the product or service content
    public var title: String
    /// Description of the product or service
    public var desc: String
    /// Progress ratio for usage of the product or service
    public var progressRatio: Float?
    /// init
    public init(icon: String, title: String, desc: String, progressRatio: Float? = nil) {
        self.icon = icon
        self.title = title
        self.desc = desc
        self.progressRatio = progressRatio
    }
}

/// Product Switcher cta button model
public struct ProductSwitcherCTAButtonModel: Codable {
    /// CTA text for the button
    public var text: String
    /// HEX color for button's text color
    public var textColor: String?
    /// HEX color for button's background color
    public var backgroundColor: String?
    /// HEX color for button's border color
    public var borderColor: String?
    /// init
    public init(text: String, textColor: String? = nil, backgroundColor: String? = nil, borderColor: String? = nil) {
        self.text = text
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
    }
}
