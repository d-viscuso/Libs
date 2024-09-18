//
//  Authentication.swift
//  VFGDataAccess
//
//  Created by Mohamed Magdy on 7/25/17.
//  Copyright © 2017 VFG. All rights reserved.
//

import Foundation

/// A struct model which holds the authentication data.
/// The `Authentication`model  is used to hundle header and parameters of requesting a token.
public struct Authentication: Codable {
    // MARK: - Properties
    private(set) var authenticationBaseUrl: String?
    private(set) var authenticationPathUrl: String?
    private(set) var clientID: String?
    private(set) var scope: String?
    private(set) var username: String?
    private(set) var password: String?
    private(set) var countryCode: String?
    private(set) var vfTargetStub: String?
    private(set) var grantType: String?
    private(set) var contentType: String?

    // for login authentication
    private(set) var accept: String?
    private(set) var acceptLanguage: String?
    private(set) var vFEXTBPID: String?
    private(set) var code: String?

    // for product and services token
    private(set) var authorization: String?

    // for Soho
    private(set) var vfProject: String?
    private(set) var vfTargetEnvironment: String?
    // MARK: - Init

    /// Authentication struct initializer.
    /// - Parameters:
    ///   - authenticationBaseUrl: A string object which represents the url of the endpoint at the server.
    ///   - authenticationPathUrl: A string object which represents the authentication path url which follow the base url.
    ///   - clientID: A string object which represents the client id.
    ///   - scope: A string object indicates the scope which the client is asking that the authorization server generate an access token within.
    ///   - username: A string object which represents the user name.
    ///   - password: A string object which represents the password.
    ///   - countryCode: A string object which represents the country code.
    ///   - vfTargetStub: A string object which represents a flag when enabled it uses the target stub.
    ///   - grantType: A string object which refers to the way an application gets an access token.
    ///   OAuth 2.0 defines several grant types, including the Password grant.
    ///   OAuth 2.0 extensions can also define new grant types.
    ///   - contentType: A string object which represents the original media type of the resource.
    ///   - authorization: A string object used to provide credentials that authenticate a user agent with a server.
    ///   - vfProject: A string object which represents the current project type, the default value is `nil`.
    ///   - vfTargetEnvironment: A string object which represents the target environment type, including the dev environment, the default value is `nil`.
    public init(
        authenticationBaseUrl: String?,
        authenticationPathUrl: String?,
        clientID: String?,
        scope: String?,
        username: String?,
        password: String?,
        countryCode: String?,
        vfTargetStub: String?,
        grantType: String?,
        contentType: String?,
        authorization: String? = nil,
        vfProject: String? = nil,
        vfTargetEnvironment: String? = nil
    ) {
        self.authenticationBaseUrl = authenticationBaseUrl
        self.authenticationPathUrl = authenticationPathUrl
        self.clientID = clientID
        self.scope = scope
        self.username = username
        self.password = password
        self.countryCode = countryCode
        self.vfTargetStub = vfTargetStub
        self.grantType = grantType
        self.contentType = contentType
        self.authorization = authorization
        self.vfProject = vfProject
        self.vfTargetEnvironment = vfTargetEnvironment
    }

    /// Authentication struct initializer for login authentication
    /// - Parameters:
    ///   - authenticationBaseUrl: A string object which represents the base authentication url.
    ///   - authenticationPathUrl: A string object which represents the authentication path url which follow the base url.
    ///   - grantType: A string object which represents the grant type (ex. "password", "authorization_code" ...etc).
    ///   - clientID: A string object which represents the client id.
    ///   - accept: A string object indicates which content types, expressed as MIME types, the client is able to understand.
    ///   - acceptLanguage: A string object indicates the natural language and locale that the client prefers.
    ///   - vFEXTBPID: A string object which represents an external identifier.
    ///   - countryCode: A string object which represents the country code.
    ///   - vfTargetStub: A string object which represents the name of target JSON stub.
    ///   - contentType: A string object which represents the original media type of the resource.
    ///   - code: A string object which represents the login authentication code.
    public init(
        authenticationBaseUrl: String?,
        authenticationPathUrl: String?,
        grantType: String,
        clientID: String,
        accept: String,
        acceptLanguage: String,
        vFEXTBPID: String?,
        countryCode: String?,
        vfTargetStub: String?,
        contentType: String?,
        code: String
    ) {
        self.authenticationBaseUrl = authenticationBaseUrl
        self.authenticationPathUrl = authenticationPathUrl
        self.clientID = clientID
        self.grantType = grantType
        self.accept = accept
        self.acceptLanguage = acceptLanguage
        self.vFEXTBPID = vFEXTBPID
        self.countryCode = countryCode
        self.vfTargetStub = vfTargetStub
        self.contentType = contentType
        self.code = code
        self.scope = ""
        self.username = ""
        self.password = ""
    }
}
