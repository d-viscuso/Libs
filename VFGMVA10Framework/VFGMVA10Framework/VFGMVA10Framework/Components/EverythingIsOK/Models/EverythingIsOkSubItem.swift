//
//  EverythingIsOkSubItem.swift
//  VFGMVA10
//
//  Created by Mahmoud Amer on 3/19/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

/// EIO Sub Item Model 
public class EverythingIsOkSubItem: Codable {
    public var subItemId: String?
    public var title: String?
    public var status: EIOStatus? {
        didSet {
            if self.status != oldValue {
                oldStatus = oldValue
            } else {
                oldStatus = self.status
            }
        }
    }
    public var description: String?
    public var actionTitle: String?
    public var oldStatus: EIOStatus?

    enum CodingKeys: String, CodingKey {
        case subItemId = "id"
        case title
        case status
        case description
        case actionTitle
    }

    public init() {}

    public init(subItemId: String?, title: String?, status: EIOStatus?, description: String?, actionTitle: String?, oldStatus: EIOStatus?) {
        self.subItemId = subItemId
        self.title = title
        self.status = status
        self.description = description
        self.actionTitle = actionTitle
        self.oldStatus = oldStatus
    }
}
