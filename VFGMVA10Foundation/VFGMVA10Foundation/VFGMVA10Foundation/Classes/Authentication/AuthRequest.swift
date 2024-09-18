//
//  AuthRequest.swift
//  VFGMVA10Foundation
//
//  Created by Esraa Eldaltony on 10/24/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
/// An enum which manages retrieve token for various scenarios.
public enum AuthRequest: VFGRequestProtocol {
    public static var base = "https://eu2-stagingref.api.vodafone.com"
    public static var path = "/v1/apixoauth2password/oauth2/token"

    case getToken(authObject: Authentication)
    case refreshToken(authObject: Authentication, refreshToken: String)
    case getSoftLoginToken(authObject: Authentication)
    case getProductAndServicesToken(authObject: Authentication)
    case getSohoToken(authObject: Authentication)

    /// The authentication request path.
    public var path: String {
        return AuthRequest.path
    }

    /// A set of request methods to indicate the desired action to be performed for a given resource.
    public var httpMethod: HTTPMethod {
        return .post
    }

    /// The HTTP tasks.
    public var httpTask: HTTPTask {
        var params: VFGParameters?
        var headers: VFGHTTPHeaders?
        var encodingType: VFGParameterEncoder = .jsonEncoding

        switch self {
        case .getToken(authObject: let object):
            params = [
                (RequestParameterKey.clientIDKey, object.clientID ?? VFGDxlConstants.shared.clientID),
                (RequestParameterKey.grantTypeKey, object.grantType ?? ""),
                (RequestParameterKey.usernameKey, object.username ?? ""),
                (RequestParameterKey.passwordKey, object.password ?? ""),
                (RequestParameterKey.scopeKey, object.scope ?? "")
            ]
            headers = [
                RequestHeaderKey.contentTypeKey: object.contentType ?? "application/x-www-form-urlencoded",
                RequestHeaderKey.countryCodeKey: object.countryCode ?? VFGDxlConstants.shared.countryCode,
                RequestHeaderKey.vftargetStub: object.vfTargetStub ?? "true"
            ]

        case let .refreshToken(authObject: object, refreshToken: refreshToken):
            headers = [RequestHeaderKey.vftargetStub: object.vfTargetStub ?? "true"]

            params = [
                (RequestParameterKey.grantTypeKey, "refresh_token"),
                (RequestParameterKey.clientIDKey, object.clientID ?? VFGDxlConstants.shared.clientID),
                (RequestParameterKey.scopeKey, object.scope ?? ""),
                (RequestParameterKey.refreshTokenKey, refreshToken)
            ]

        case .getSoftLoginToken(authObject: let object):
            params = [
                (RequestParameterKey.clientIDKey, object.clientID ?? VFGDxlConstants.shared.clientID),
                (RequestParameterKey.grantTypeKey, object.grantType ?? ""),
                (RequestParameterKey.codeKey, object.code ?? "")
            ]
            headers = [
                RequestHeaderKey.acceptKey: object.accept ?? "application/json",
                RequestHeaderKey.contentTypeKey: object.contentType ?? "application/x-www-form-urlencoded",
                RequestHeaderKey.acceptLanguageKey: object.acceptLanguage ?? "GR",
                RequestHeaderKey.vfEXTBPIDKey: object.vFEXTBPID ?? "TC01",
                RequestHeaderKey.vftargetStub: object.vfTargetStub ?? "true"
            ]

        case .getProductAndServicesToken(authObject: let object):
            AuthRequest.base = "https://eu2-stagingref.api.vodafone.com/"
            AuthRequest.path = "OAuth2PasswordGrant/v1/token"
            params = [
                (RequestParameterKey.grantTypeKey, object.grantType ?? ""),
                (RequestParameterKey.usernameKey, object.username ?? ""),
                (RequestParameterKey.passwordKey, object.password ?? ""),
                (RequestParameterKey.scopeKey, object.scope ?? "")
            ]
            headers = [
                RequestHeaderKey.authorizationKey: object.authorization ?? "",
                RequestHeaderKey.contentTypeKey: object.contentType ?? "application/x-www-form-urlencoded",
                RequestHeaderKey.countryCodeKey: object.countryCode ?? VFGDxlConstants.shared.countryCode
            ]
            encodingType = .bodyUrlEncoding

        case .getSohoToken(authObject: let object):
            AuthRequest.base = "https://eu2-stagingref.api.vodafone.com/"
            AuthRequest.path = "OAuth2TrustedLoginGrant/v1/token"
            params = [
                (RequestParameterKey.grantTypeKey, object.grantType ?? ""),
                (RequestParameterKey.loginHint, object.username ?? "")
            ]
            headers = [
                RequestHeaderKey.contentTypeKey: object.contentType ?? "application/x-www-form-urlencoded",
                RequestHeaderKey.countryCodeKey: object.countryCode ?? "EU",
                RequestHeaderKey.vfProject: object.vfProject ?? "SoHo",
                RequestHeaderKey.vfTargetEnvironment: object.vfTargetEnvironment ?? "dev",
                RequestHeaderKey.authorizationKey: object.authorization ?? ""
            ]
            encodingType = .bodyUrlEncoding
        }

        return .requestWithParametersAndHeaders(
            bodyParameters: params,
            bodyEncoding: encodingType,
            urlParameters: nil,
            extraHeaders: headers)
    }

    /// The HTTP request header.
    public var headers: VFGHTTPHeaders? {
        return [:]
    }

    /// The flag that checks if authentication request is needed, default value is false.
    public var isAuthenticationNeededRequest: Bool? {
        return false
    }

    /// The constants used to specify interaction with the cached responses.
    public var cachePolicy: VFGCachePolicy {
        return .reloadIgnoringLocalAndRemoteCacheData
    }
}

/// A string enum which holds authentication errors.
public enum VFGAuthenticationError: String, Error {
    case authenticationObjectNil = "Authentication Object is nil"
    case authenticationObjectOrTokenNil = "Authentication Object is nil or there's not saved token"
}
