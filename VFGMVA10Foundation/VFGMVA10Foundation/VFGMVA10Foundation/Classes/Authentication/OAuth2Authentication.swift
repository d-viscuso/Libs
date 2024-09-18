//
//  AuthenticationManagerProtocol.swift
//  VFGDataAccess
//
//  Created by Shimaa Magdi on 7/25/17.
//  Copyright © 2017 VFG. All rights reserved.
//
import Foundation

/// Request Parameters
public enum RequestParameterKey {
    static let grantTypeKey: String = "grant_type"
    static let clientIDKey: String = "client_id"
    static let clientSecretKey: String = "client_secret"
    static let scopeKey: String = "scope"
    static let usernameKey: String = "username"
    static let passwordKey: String = "password"
    static let refreshTokenKey: String = "refresh_token"
    // login authentication
    static let codeKey: String = "code"
    // SOHO
    static let loginHint: String = "login_hint"
}
/// Request Headers
public enum RequestHeaderKey {
    static let contentTypeKey: String = "Content-Type"
    static let countryCodeKey: String = "vf-country-code"
    static let vftargetStub: String = "vf-target-stub"
    // login authentication
    static let acceptKey: String = "Accept"
    static let acceptLanguageKey: String = "Accept-Language"
    static let vfEXTBPIDKey: String = "VF_EXT_BP_ID"
    // product and services
    static let authorizationKey: String = "Authorization"
    // SOHO
    static let vfProject: String = "vf-project"
    static let vfTargetEnvironment: String = "vf-target-environment"
}
/// keychain keys
private enum KeychainKeys {
    static let tokenKey: String      = "token"
    static let authObjectKey: String = "authObject"
}

private let tokenExpirationOffset: Int = 30

private let authenticationHeaderKey = "Authorization"
private let authenticationHeaderValuePrefix = "Bearer "

/// `OAuth2Authentication` is designed primarily as a means of granting access to a set of resources, for example, remote APIs or user’s data.
/// OAuth 2.0 uses Access Tokens. An Access Token is a piece of data that represents the authorization to access resources on behalf of the end-user.
public class OAuth2Authentication {
    // MARK: - Properties
    var authenticationObject: Authentication?
    var tokenObject: Token?
    var tokenArrivalDate: Date?

    var secondsSince1970 = Int((Date().timeIntervalSince1970).rounded())

    static var keyChainPrefix: String = ""

    var networkClient: VFGNetworkClient?

    /// OAuth2Authentication class initializer.
    /// - Parameter keyChainPrefix: A string object which represents the keychain prefix.
    public init(keyChainPrefix: String = "com.OAuth2Authentication.keyChainPrefix.default") {
        OAuth2Authentication.keyChainPrefix = keyChainPrefix
        refreshObjectsFromKeyChain()
        initNetworkClient()
    }

    private func initNetworkClient() {
        networkClient = VFGNetworkClient(baseURL: AuthRequest.base)
        networkClient?.authClientProvider = self
    }

    private func generateToken(completion: @escaping AuthenticationManagerCompletion) {
        guard let authObject = authenticationObject else {
            VFGErrorLog("ERROR: Authentication object is nil")
            completion(nil, VFGAuthenticationError.authenticationObjectNil)
            return
        }
        AuthRequest.path = authObject.authenticationPathUrl ?? ""
        let getTokenRequest = AuthRequest.getToken(authObject: authObject)
        networkClient?.executeData(
            request: getTokenRequest,
            model: Token.self) { [weak self] result in
            guard let self = self else {
                completion(nil, VFGNetworkError.authFailed)
                return
            }
            switch result {
            case .success(let token):
                self.saveTokenToKeychain(key: KeychainKeys.tokenKey, token: token)
                completion(token, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }

    private func generateSoftLoginToken(completion: @escaping AuthenticationManagerCompletion) {
        guard let authObject = authenticationObject else {
            VFGErrorLog("ERROR: Authentication object is nil")
            completion(nil, VFGAuthenticationError.authenticationObjectNil)
            return
        }
        AuthRequest.path = authObject.authenticationPathUrl ?? ""
        let getTokenRequest = AuthRequest.getSoftLoginToken(authObject: authObject)
        networkClient?.executeData(
            request: getTokenRequest,
            model: Token.self) { [weak self] result in
            guard let self = self else {
                completion(nil, VFGNetworkError.authFailed)
                return
            }
            switch result {
            case .success(let token):
                self.saveTokenToKeychain(key: KeychainKeys.tokenKey, token: token)
                completion(token, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }

    /// A method which is used to updated current access token.
    /// - Parameter completion: A closure which gets called once the new token is generated and saved to keychain.
    func updateToken(completion: @escaping AuthenticationManagerCompletion) {
        guard let authObject = authenticationObject, let token = tokenObject else {
            VFGErrorLog("ERROR: Authentication object or Token object is nil")
            completion(nil, VFGAuthenticationError.authenticationObjectOrTokenNil)
            return
        }
        AuthRequest.path = authObject.authenticationPathUrl ?? ""
        let refreshTokenRequest = AuthRequest.refreshToken(
            authObject: authObject,
            refreshToken: token.refreshToken ?? "")
        networkClient?.executeData(request: refreshTokenRequest, model: Token.self) { [weak self] result in
            guard let self = self else {
                completion(nil, VFGNetworkError.authFailed)
                return
            }
            switch result {
            case .success(let token):
                self.saveTokenToKeychain(key: KeychainKeys.tokenKey, token: token)
                completion(token, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }

    private func isTokenExpired(tokenExpirationTime: String) -> Bool {
        let currentDate = secondsSince1970 + tokenExpirationOffset
        if let tokenExpirationInteger = Int(tokenExpirationTime) {
            if tokenExpirationInteger > currentDate {
                return false
            }
        }
        return true
    }

    /// A method used to validate authentication object by make sure that clientID, grantType and countryCode are not nil.
    /// - Returns: A boolean value, if any of clientID, grantType or countryCode is nil it will return true otherwise it will return false.
    func validateAuthObj() -> Bool {
        guard let authenticationObject = authenticationObject else {
            return false
        }
        if authenticationObject.clientID != nil &&
            authenticationObject.grantType != nil &&
            authenticationObject.countryCode != nil {
            return true
        }
        return false
    }

    /// A method used to refresh both authentication object and token object.
    func refreshObjectsFromKeyChain() {
        authenticationObject = loadAuthObjectFromKeychain(key: KeychainKeys.authObjectKey)
        tokenObject = loadTokenFromKeychain(key: KeychainKeys.tokenKey)
    }
}

// saving to KeyChain
extension OAuth2Authentication {
    private func loadTokenFromKeychain(key: String) -> Token? {
        guard let data = VFGKeyChainService.data(forKey: OAuth2Authentication.keyChainPrefix + key) else {
            return nil
        }
        return try? JSONDecoder().decode(Token.self, from: data)
    }

    private func saveTokenToKeychain(key: String, token: Token) {
        guard let data = try? JSONEncoder().encode(token) else { return }
        VFGKeyChainService.saveData(key: OAuth2Authentication.keyChainPrefix + key, value: data)
    }

    private func loadAuthObjectFromKeychain(key: String) -> Authentication? {
        guard let data = VFGKeyChainService.data(forKey: OAuth2Authentication.keyChainPrefix + key) else {
            return nil
        }
        return try? JSONDecoder().decode(Authentication.self, from: data)
    }

    private func saveAuthObjectToKeychain(key: String, token: Authentication?) {
        guard let data = try? JSONEncoder().encode(token) else { return }
        VFGKeyChainService.saveData(key: OAuth2Authentication.keyChainPrefix + key, value: data)
    }
}

extension OAuth2Authentication: AuthenticationManagerProtocol {
    /// A method used to generate a new access token.
    /// - Parameter closure: A closure which gets called once the new token is generated and saved to keychain.
    func getToken(closure: @escaping AuthenticationManagerCompletion) {
        if validateAuthObj() {
            generateToken(completion: closure)
        } else {
            closure(nil, VFGAuthenticationError.authenticationObjectNil)
        }
    }

    /// A method used to refresh current access token.
    /// - Parameter closure: A closure which gets called once the token is generated or updated and saved to keychain.
    func refreshToken(closure: @escaping AuthenticationManagerCompletion) {
        if validateAuthObj() {
            // is refresh token expired
            if isTokenExpired(tokenExpirationTime: tokenObject?.refreshTokenExpirationTime ?? "0") {
                generateToken(completion: closure)
            } else {
                updateToken(completion: closure)
            }
        } else {
            closure(nil, VFGAuthenticationError.authenticationObjectNil)
        }
    }
}

// this protocol with be used by the network layer to use the authentication token when needed.
extension OAuth2Authentication: AuthTokenProvider {
    public func requestAuthToken(closure: @escaping Success) {
        refreshObjectsFromKeyChain()
        getTokenData { token, error in
            if error != nil {
                closure(nil, error)
            } else {
                guard let accessToken = token?.accessToken else {
                    closure(nil, VFGNetworkError.authFailed)
                    return
                }
                closure([authenticationHeaderKey: authenticationHeaderValuePrefix + accessToken], nil)
            }
        }
    }
}

// market calls these methods on start using OAuth2Authentication object
extension OAuth2Authentication {
    /// A method used to check if the current user is authenticated or not.
    /// - Returns: A boolean value, if the current token is expired it will return false otherwise it will return true.
    public func isAuthenticated() -> Bool {
        guard let authObject = authenticationObject,
            let token = tokenObject else {
                return false
        }

        if isTokenExpired(tokenExpirationTime: token.expirationTime ?? "0") {
            if isTokenExpired(tokenExpirationTime: token.refreshTokenExpirationTime ?? "0") {
                return false
            }
        }
        authenticationObject = authObject
        tokenObject = token
        return true
    }

    /// A method used to sign in by saving authentication object to the keychain and generate a new token.
    /// - Parameters:
    ///   - authenticationObject: An object of type *Authentication*.
    ///   - failure: A closure which gets invoked when generate a new token failed.
    public func signInRequested(authenticationObject: Authentication?, failure: @escaping (Error?) -> Void) {
        saveAuthObjectToKeychain(key: KeychainKeys.authObjectKey, token: authenticationObject)
        refreshObjectsFromKeyChain()
        getTokenData { _, error in
            if error != nil {
                failure(error)
            }
        }
    }

    private func getTokenData(closure: @escaping AuthenticationManagerCompletion) {
        let token = tokenObject
        if token != nil {
            // is accessToken expired
            if isTokenExpired(tokenExpirationTime: token?.expirationTime ?? "0") {
                refreshToken { token, error in
                    if error != nil {
                        closure(nil, error)
                    } else {
                        closure(token, nil)
                    }
                }
            } else {
                closure(token, nil)
            }
        } else {
            getToken { token, error in
                if error != nil {
                    closure(nil, error)
                } else {
                    closure(token, nil)
                }
            }
        }
    }

    /// A method used to sign in by saving authentication object to the keychain and generate a new soft login token.
    /// - Parameters:
    ///   - authenticationObject: An object of type *Authentication*.
    ///   - failure: A closure which gets invoked when generate a new token failed.
    public func softLoginRequested(authenticationObject: Authentication?, failure: @escaping (Error?) -> Void) {
        saveAuthObjectToKeychain(key: KeychainKeys.authObjectKey, token: authenticationObject)
        refreshObjectsFromKeyChain()
        generateSoftLoginToken { _, error in
            if error != nil {
                failure(error)
            }
        }
    }

    /// A method used to generate soft login token.
    /// - Parameter closure: A closure which gets invoked once the soft login is generated.
    public func requestSoftLoginAuthentication(closure: @escaping Success) {
        if validateAuthObj() {
            generateSoftLoginToken { token, error in
                if error != nil {
                    closure(nil, error)
                } else {
                    closure(
                        [authenticationHeaderKey: authenticationHeaderValuePrefix + (token?.accessToken ?? "")],
                        nil)
                }
            }
        } else {
            closure(nil, VFGAuthenticationError.authenticationObjectNil)
        }
    }
}

// market calls these methods to retrive some token data
extension OAuth2Authentication {
    /// A method used to retrieve the user MSISDIN.
    /// - Parameter key: A string object which represents the key that is used with keychain prefix to retrieve data from keychain service.
    /// - Returns: A string object which represents the user MSISDIN.
    static public func getMSISDIN(key: String) -> String? {
        guard let data = VFGKeyChainService.data(forKey: OAuth2Authentication.keyChainPrefix + key) else {
            return nil
        }
        let tokenObj = try? JSONDecoder().decode(Token.self, from: data)
        if tokenObj != nil, !(tokenObj?.userData?.msisdn.isEmpty ?? true) {
            return tokenObj?.userData?.msisdn.first
        }
        return nil
    }
}
