//
//  Token.swift
//  VFGDataAccess
//
//  Created by Shimaa Magdi on 7/25/17.
//  Copyright © 2017 VFG. All rights reserved.
//

import Foundation

/// A class which represents a piece of data that represents the authorization to access resources on behalf of the end-user.
public class Token: JSONEncoder, Codable {
    public private(set) var accessToken: String?
    public private(set) var userData: UserData?
    var expirationTime: String?
    var tokenType: String?
    var jws: String?
    var refreshToken: String?
    var refreshTokenExpirationTime: String?

    enum CodingKeys: String, CodingKey {
        case accessToken    = "access_token"
        case expirationTime = "expires_at"
        case tokenType      = "token_type"
        case jws
        case refreshToken   = "refresh_token"
        case refreshTokenExpirationTime = "refresh_token_expires"
        case userData = "userInfo"
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container
            .decodeIfPresent(String.self, forKey: .accessToken)
        expirationTime = try container
            .decodeIfPresent(String.self, forKey: .expirationTime)
        tokenType = try container
            .decodeIfPresent(String.self, forKey: .tokenType)
        jws = try container
            .decodeIfPresent(String.self, forKey: .jws)
        refreshToken = try container
            .decodeIfPresent(String.self, forKey: .refreshToken)
        refreshTokenExpirationTime = try container
            .decodeIfPresent(String.self, forKey: .refreshTokenExpirationTime)
        userData = try container.decodeIfPresent(UserData.self, forKey: .userData)
    }
}

/// A struct model that represents the user data.
public struct UserData: Codable {
    public var msisdn: [String]
    var cli: [String]
    var basicAccess: [String]

    enum CodingKeys: String, CodingKey {
        case msisdn
        case cli
        case basicAccess = "ba"
    }
}
