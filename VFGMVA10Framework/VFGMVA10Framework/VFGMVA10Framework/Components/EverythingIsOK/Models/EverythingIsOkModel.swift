//
//  EverythingIsOkModel.swift
//  VFGMVA10
//
//  Created by Mohamed Mahmoud Zaki on 2/26/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

/// EIO Model 
public class EverythingIsOkModel: Codable {
    public var checks: [CheckItem]?
    public var greeting: String?
    public var username: String?
    public var title: String?

    enum CodingKeys: String, CodingKey {
        case greeting
        case username
        case title
        case checks
    }

    public init() {}

    public init(checks: [CheckItem]?, greeting: String?, username: String?, title: String?) {
        self.checks = checks
        self.greeting = greeting
        self.username = username
        self.title = title
    }
}
