//
//  VFGProductsDXLConstants.swift
//  VFGMVA10Foundation
//
//  Created by Moustafa Hegazy on 16/03/2021.
//

import Foundation

/// A singleton class which holds a default values used in configuring header and parameters of products requests.
public class VFGProductsDXLConstants {
    public static let shared = VFGProductsDXLConstants()
    private init() {}

    /// The base url of the endpoint at the server.
    public var baseUrl = "https://eu2-stagingref.api.vodafone.com"
    /// The authentication path url which follow the base url.
    public var authenticationPathUrl = "/OAuth2PasswordGrant/v1/token"
    /// The client id.
    public var clientID = "0KlAsrVaURa3DGnqrVWBI9jLlZ7HQJAv"
    /// The country code.
    public var countryCode = "EU"
    /// The grant type that refers to the way an application gets an access token.
    /// OAuth 2.0 defines several grant types, including the Password grant.
    /// OAuth 2.0 extensions can also define new grant types.
    public var grantType = "password"
    /// Indicates which content types, expressed as MIME types, the client is able to understand.
    public var accept = "application/json"
    /// The natural language and locale that the client prefers.
    public var acceptLanguage = "en"
    /// The original media type of the resource.
    public var contentType = "application/x-www-form-urlencoded"
    /// The scope which the client is asking that the authorization server generate an access token within.
    public var scope = "PRODUCTS_AND_SERVICES_ALL DIGITAL_PRODUCT_RECOMMENDATION_ALL"
    /// The authorization token used to provide credentials that authenticate a user agent with a server.
    public var authorizationToken = "Basic MEtsQXNyVmFVUmEzREducXJWV0JJOWpMbFo3SFFKQXY6QW4zNWdrYmNkZWcwTUd1TQ=="
}
