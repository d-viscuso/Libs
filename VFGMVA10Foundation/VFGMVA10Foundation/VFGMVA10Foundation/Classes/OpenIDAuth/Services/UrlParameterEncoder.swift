//
//  UrlParameterEncoder.swift
//  VFGMVA10Foundation
//
//  Created by Hussein Gamal on 11/06/2019.
//

import Foundation

class UrlParameterEncoder {
    func getRequest(
        request: inout NSMutableURLRequest,
        credential: LoginCredential,
        configuration: VFGTokenRequestConfiguration
    ) {
        let components = NSURLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: configuration.grantType),
            URLQueryItem(name: "client_id", value: configuration.clientId),
            URLQueryItem(name: "client_secret", value: configuration.clientSecret),
            URLQueryItem(name: "scope", value: configuration.scope),
            URLQueryItem(name: "username", value: credential.username),
            URLQueryItem(name: "password", value: credential.password)
        ]
        if let query = components.query {
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = [ "Content-Type": "application/x-www-form-urlencoded"]
            request.httpBody = query.data(using: .utf8)
        }
    }
}
