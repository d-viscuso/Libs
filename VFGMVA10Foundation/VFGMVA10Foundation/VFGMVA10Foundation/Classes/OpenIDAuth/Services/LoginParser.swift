//
//  LoginParser.swift
//  VFGMVA10Foundation
//
//  Created by Hussein Gamal on 06/06/2019.
//

import Foundation

protocol ParserProtocol {
    func parse(rawData: NSDictionary) -> Any?
}

class TokenResponseParser: ParserProtocol {
    func parse(rawData: NSDictionary) -> Any? {
        guard let accessToken = rawData["access_token"] as? String else { return nil } // Required
        guard let tokenType = rawData["token_type"] as? String  else { return nil } // Required
        let refreshToken = rawData["refresh_token"] as? String
        let idToken = rawData["id_token"] as? String
        var expiresIn: Date?
        if let expires = rawData["expires_in"] as? Int {
            expiresIn = Date(timeIntervalSinceNow: Double(expires))
        }

        return TokenResponse(
            accessToken: accessToken,
            tokenType: tokenType,
            refreshToken: refreshToken,
            idToken: idToken,
            expiresIn: expiresIn)
    }
}

class OpenIdConfigurationParser: ParserProtocol {
    func parse(rawData: NSDictionary) -> Any? {
        let issuer = rawData["issuer"] as? String
        let authorizationEndpoint = rawData["authorization_endpoint"] as? String
        let tokenEndpoint = rawData["token_endpoint"] as? String
        let userInfoEndpoint = rawData["userinfo_endpoint"] as? String
        let revocationEndpoint = rawData["revocation_endpoint"] as? String
        let jwksUri = rawData["jwks_uri"] as? String
        let responseTypesSupported = rawData["response_types_supported"] as? [String]
        let grantTypesSupported = rawData["grant_types_supported"] as? [String]
        let subjectTypesSupported = rawData["subject_types_supported"] as? [String]
        let idTokenSigningAlgValuesSupported = rawData["id_token_signing_alg_values_supported"] as? [String]
        let keyName = "token_endpoint_auth_signing_alg_values_supported"
        let tokenEndpointAlgValuesSupported = rawData[keyName] as? [String]
        let uiLocalesSupported = rawData["ui_locales_supported"] as? [String]
        let claimsSupported = rawData["claims_supported"] as? [String]

        return OpenIDConfiguration(
            issuer: issuer,
            authorizationEndpoint: authorizationEndpoint,
            tokenEndpoint: tokenEndpoint,
            userInfoEndpoint: userInfoEndpoint,
            revocationEndpoint: revocationEndpoint,
            jwksUri: jwksUri,
            responseTypesSupported: responseTypesSupported,
            grantTypesSupported: grantTypesSupported,
            subjectTypesSupported: subjectTypesSupported,
            idTokenSigningAlgValuesSupported: idTokenSigningAlgValuesSupported,
            tokenEndpointAuthValuesSupported: tokenEndpointAlgValuesSupported,
            uiLocalesSupported: uiLocalesSupported,
            claimsSupported: claimsSupported)
    }
}

class ErrorParser: ParserProtocol {
    func parse(rawData: NSDictionary) -> Any? {
        guard let error = rawData["error"] as? String else { return nil } // Required
        return VFGLoginError(rawValue: error)
    }
}
