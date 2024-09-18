//
//  OpenIDConfiguration.swift
//  VFGMVA10Foundation
//
//  Created by Hussein Gamal on 06/06/2019.
//

import Foundation

struct OpenIDConfiguration {
    let issuer: String?
    let authorizationEndpoint: String?
    let tokenEndpoint: String?
    let userInfoEndpoint: String?
    let revocationEndpoint: String?
    let jwksUri: String?
    let responseTypesSupported: [String]?
    let grantTypesSupported: [String]?
    let subjectTypesSupported: [String]?
    let idTokenSigningAlgValuesSupported: [String]?
    let tokenEndpointAuthValuesSupported: [String]?
    let uiLocalesSupported: [String]?
    let claimsSupported: [String]?
}
