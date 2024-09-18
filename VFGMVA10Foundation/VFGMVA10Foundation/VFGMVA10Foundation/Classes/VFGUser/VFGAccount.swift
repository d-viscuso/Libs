//
//  VFGAccount.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 12/15/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// `VFGAccount` is a class to manage following up with user account.
open class VFGAccount: Codable {
    public var name: String
    public var imageName: String?
    public var msisdn: String
    public var type: VFGUserType?
    public var accountId: String?

    /// Creates new instance by using the given parameters.
    /// - Parameters:
    ///   - name: Name of the user.
    ///   - imageName: Image name of the user image.
    ///   - msisdn:The MSISDN number of the user.
    ///   - type: Type of the user, it is PayM by default.
    ///   - id: Unique id for this account.
    public init(name: String, imageName: String? = nil, msisdn: String = "", type: VFGUserType = .payM, accountId: String? = nil) {
        self.name = name
        self.imageName = imageName
        self.msisdn = msisdn
        self.type = type
        self.accountId = accountId ?? String(Date().timeIntervalSinceReferenceDate) + name + msisdn
    }

    enum CodingKeys: CodingKey {
        case name
        case imageName
        case msisdn
        case type
        case accountId
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(name, forKey: .name)
        try? container.encode(imageName, forKey: .imageName)
        try? container.encode(msisdn, forKey: .msisdn)
        try? container.encode(type, forKey: .type)
        try? container.encode(accountId, forKey: .accountId)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.imageName = try? container.decode(String.self, forKey: .imageName)
        self.msisdn = try container.decode(String.self, forKey: .msisdn)
        self.type = try? container.decode(VFGUserType.self, forKey: .type)
        self.accountId = try? container.decode(String.self, forKey: .accountId)
        accountId = accountId ?? (String(Date().timeIntervalSinceReferenceDate) + name + msisdn)
    }
}

extension VFGAccount: Equatable {
    public static func == (lhs: VFGAccount, rhs: VFGAccount) -> Bool {
        lhs.name == rhs.name &&
        lhs.imageName == rhs.imageName &&
        lhs.msisdn == rhs.msisdn &&
        lhs.type == rhs.type &&
        lhs.accountId == rhs.accountId
    }
}
