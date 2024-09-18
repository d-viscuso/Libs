//
//  ProductsAuthentication.swift
//  VFGMVA10Foundation
//
//  Created by Moustafa Hegazy on 15/03/2021.
//

import Foundation


/// keychain keys
private enum KeychainKeys {
    static let tokenKey: String      = "productToken"
    static let authObjectKey: String = "productAuthObject"
}

private let tokenExpirationOffset: Int = 30

private let authenticationHeaderKey = "Authorization"
private let authenticationHeaderValuePrefix = "Bearer "

/// `ProductsAuthentication` is designed primarily as a means of granting access to products resources.
public class ProductsAuthentication {
    // MARK: - Properties
    var authenticationObject: Authentication?
    var tokenObject: Token?
    var tokenArrivalDate: Date?
    var baseUrl: String?

    var secondsSince1970 = Int((Date().timeIntervalSince1970).rounded())

    static var keyChainPrefix: String = ""

    var networkClient: VFGNetworkClient?

    /// ProductsAuthentication class initializer.
    /// - Parameters:
    ///   - keyChainPrefix: A string object which represents the keychain prefix.
    ///   - baseUrl: A string object which represents the url of the endpoint at the server.
    public init(
        keyChainPrefix: String = "com.ProductsAuthentication.keyChainPrefix.default",
        baseUrl: String = "https://eu2-stagingref.api.vodafone.com"
    ) {
        ProductsAuthentication.keyChainPrefix = keyChainPrefix
        self.baseUrl = baseUrl
        refreshObjectsFromKeyChain()
        initNetworkClient()
    }

    private func initNetworkClient() {
        networkClient = VFGNetworkClient(baseURL: baseUrl ?? "")
        networkClient?.authClientProvider = self
    }

    private func generateToken(completion: @escaping AuthenticationManagerCompletion) {
        guard let authObject = authenticationObject else {
            VFGErrorLog("ERROR: Authentication object is nil")
            completion(nil, VFGAuthenticationError.authenticationObjectNil)
            return
        }
        AuthRequest.path = authObject.authenticationPathUrl ?? ""
        let getTokenRequest = AuthRequest.getProductAndServicesToken(authObject: authObject)
        _ = getTokenRequest.httpTask
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
extension ProductsAuthentication {
    private func loadTokenFromKeychain(key: String) -> Token? {
        guard let data = VFGKeyChainService.data(forKey: ProductsAuthentication.keyChainPrefix + key) else {
            return nil
        }
        return try? JSONDecoder().decode(Token.self, from: data)
    }

    private func saveTokenToKeychain(key: String, token: Token) {
        guard let data = try? JSONEncoder().encode(token) else { return }
        VFGKeyChainService.saveData(key: ProductsAuthentication.keyChainPrefix + key, value: data)
    }

    private func loadAuthObjectFromKeychain(key: String) -> Authentication? {
        guard let data = VFGKeyChainService.data(forKey: ProductsAuthentication.keyChainPrefix + key) else {
            return nil
        }
        return try? JSONDecoder().decode(Authentication.self, from: data)
    }

    private func saveAuthObjectToKeychain(key: String, token: Authentication?) {
        guard let data = try? JSONEncoder().encode(token) else { return }
        VFGKeyChainService.saveData(key: ProductsAuthentication.keyChainPrefix + key, value: data)
    }
}

extension ProductsAuthentication: AuthenticationManagerProtocol {
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
extension ProductsAuthentication: AuthTokenProvider {
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
extension ProductsAuthentication {
    /// A method used to check if the current user is authenticated or not.
    /// - Returns: A boolean value, if the current token is expired it will return false otherwise it will return true.
    public func isAuthenticated() -> Bool {
        guard let authObject = authenticationObject, let token = tokenObject else {
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
}
