//
//  TokenResponse.swift
//  VFGMVA10Foundation
//
//  Created by Hussein Gamal on 06/06/2019.
//

import Foundation

struct TokenResponse: Codable {
    let accessToken: String?
    let tokenType: String?
    let refreshToken: String?
    let idToken: String?
    let expiresIn: Date?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case idToken = "id_token"
        case expiresIn = "expires_in"
    }
}
