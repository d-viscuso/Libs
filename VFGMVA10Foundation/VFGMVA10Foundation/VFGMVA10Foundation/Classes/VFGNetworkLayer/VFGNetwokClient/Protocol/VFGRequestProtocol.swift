//
//  VFGRequestProtocol.swift
//  VFGMVA10Foundation
//
//  Created by Atta Amed on 10/23/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

public typealias VFGParameters = [(key: String, value: Any)]
public typealias VFGHTTPHeaders = [String: String]
public typealias VFGCachePolicy = URLRequest.CachePolicy

/// An enum which is used to set the HTTP data type of our requests.
public enum DataType {
    case json
    case data
}

/// Network Generic EndPoint protocol used By business layer to create network Requests.
public protocol VFGRequestProtocol {
    /// The relative Endpoint path added to baseUrl
    var path: String { get }
    /// The HTTP request method
    var httpMethod: HTTPMethod { get }
    /// Http task create encoded data sent as the message body of a request, such as for an HTTP POST request or
    /// inline in case of HTTP GET request (default: .request)
    var httpTask: HTTPTask { get }
    /// A dictionary containing all the request’s HTTP header fields related to such endPoint(default: nil)
    var headers: VFGHTTPHeaders? { get }
    /// authentication Flag if exist in protocol network client may ask auth layer to provide new auth token
    var isAuthenticationNeededRequest: Bool? { get }
    /// The constants enum used to specify interaction with the cached responses.
    /** Specifies that the caching logic defined in the protocol implementation, if any, is
        used for a particular URL load request. This is the default policy
        for URL load requests.*/
    var cachePolicy: VFGCachePolicy { get }
}

extension VFGRequestProtocol {
    // internal hash for network foundation so that it can cancel your request
    internal var hash: Int {
        var hasher = Hasher()
        hasher.combine(path)
        hasher.combine(headers)
        hasher.combine(cachePolicy)
        hasher.combine(isAuthenticationNeededRequest)
        hasher.combine(httpMethod)
        hasher.combine(httpTask)
        return hasher.finalize()
    }
}

/// An enum which is used to set the HTTP method of our requests.
public enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case patch  = "PATCH"
    case delete = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
    case options = "OPTIONS"
}

/// `HTTPTask` is responsible for configuring parameters for a specific endPoint request.
/// You can add as many cases as are applicable to your Network Layers requirements.
public enum HTTPTask {
    case request
    case requestWithParameters(
        bodyParameters: VFGParameters?,
        bodyEncoding: VFGParameterEncoder,
        urlParameters: VFGParameters?)
    case requestWithParametersAndHeaders(
        bodyParameters: VFGParameters?,
        bodyEncoding: VFGParameterEncoder,
        urlParameters: VFGParameters?,
        extraHeaders: VFGHTTPHeaders?)
}

extension HTTPTask: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(hash)
    }

    public static func == (lhs: HTTPTask, rhs: HTTPTask) -> Bool {
        return lhs.hash == rhs.hash
    }

    internal var hash: Int {
        switch self {
        case .request:
            var hasher = Hasher()
            hasher.combine("request")
            return hasher.finalize()
        case let .requestWithParameters(bodyParameters, bodyEncoding, urlParameters):
            let bodyParameters = bodyParameters?.map { "\($0.key),\($0.value)" }
            let urlParameters = urlParameters?.map { "\($0.key),\($0.value)" }

            var hasher = Hasher()
            hasher.combine(bodyParameters)
            hasher.combine(bodyEncoding)
            hasher.combine(urlParameters)
            return hasher.finalize()
        case let .requestWithParametersAndHeaders(bodyParameters, bodyEncoding, urlParameters, extraHeaders):
            let bodyParameters = bodyParameters?.map { "\($0.key),\($0.value)" }
            let urlParameters = urlParameters?.map { "\($0.key),\($0.value)" }

            var hasher = Hasher()
            hasher.combine(bodyParameters)
            hasher.combine(bodyEncoding)
            hasher.combine(urlParameters)
            hasher.combine(extraHeaders)
            return hasher.finalize()
        }
    }
}

/// `VFRequest` is the concrete implementation that can be initialized using builder
public struct VFGRequest: VFGRequestProtocol {
    public var httpMethod: HTTPMethod
    public var httpTask: HTTPTask
    public var headers: VFGHTTPHeaders?
    public var isAuthenticationNeededRequest: Bool?
    public var cachePolicy: VFGCachePolicy
    public var path: String
    /// `VFGRequest` struct initializer.
    /// - Parameters:
    ///   - path: A string object which represents the url of the endpoint at the server, default is empty string.
    ///   - httpMethod: An object of type *HTTPMethod* which represents a set of request methods to indicate the desired action to be performed for a given resource, default is `.get`.
    ///   - httpTask: An object of type *HTTPTask* which is responsible for configuring parameters for a specific endPoint request, deafult is `.request`.
    ///   - headers: A dictionary containing all the request’s HTTP header fields related to such endPoint, default is `nil`.
    ///   - isAuthenticationNeededRequest: A boolean flag which represents  authentication flag if exist in protocol network client may ask auth layer to provide new auth token, default is `true`.
    ///   - cachePolicy: An object of type *VFGCachePolicy* which is used to specify interaction with the cached responses, default is `.reloadIgnoringLocalCacheData`.
    public init(
        path: String = NetworkDefaults.path,
        httpMethod: HTTPMethod = NetworkDefaults.httpMethod,
        httpTask: HTTPTask = NetworkDefaults.httpTask,
        headers: VFGHTTPHeaders? = NetworkDefaults.httpHeaders,
        isAuthenticationNeededRequest: Bool? = NetworkDefaults.isAuthenticationNeeded,
        cachePolicy: VFGCachePolicy = NetworkDefaults.cashPolicy
    ) {
        self.path = path
        self.httpMethod = httpMethod
        self.httpTask = httpTask
        self.headers = headers
        self.isAuthenticationNeededRequest = isAuthenticationNeededRequest
        self.cachePolicy = cachePolicy
    }
}
