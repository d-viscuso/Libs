//
//  EverythingIsOkCheckItemModel.swift
//  VFGMVA10
//
//  Created by Mohamed Mahmoud Zaki on 3/6/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

/// Check Items Model 
public class CheckItem: Codable {
    public var itemId: String?
    public var title: String?
    public var status: EIOStatus?
    public var subItems: [EverythingIsOkSubItem]?
    public var icon: String?

    enum CodingKeys: String, CodingKey {
        case itemId = "id"
        case title
        case status
        case subItems
        case icon
    }

    public init() {}

    public init (itemId: String?, title: String?, status: EIOStatus?, subItems: [EverythingIsOkSubItem]?, icon: String?) {
        self.itemId = itemId
        self.title = title
        self.status = status
        self.subItems = subItems
        self.icon = icon
    }
}
