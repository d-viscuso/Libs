//
//  VFGParameterEncoder.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed Sultan on 10/15/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

public protocol ParameterEncodingProtocol {
    func encode(urlRequest: inout URLRequest, with parameters: VFGParameters) throws
}

/// An enum which holds a different types of parameter encoding.
public enum VFGParameterEncoder {
    case urlEncoding
    case jsonEncoding
    case urlAndJsonEncoding
    case bodyDataEncoding
    case bodyUrlEncoding

    public func encode(
        urlRequest: inout URLRequest,
        bodyParameters: VFGParameters?,
        urlParameters: VFGParameters?
    ) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)

            case .jsonEncoding:
                guard let bodyParameters = bodyParameters, !bodyParameters.isEmpty else { return }
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)

            case .urlAndJsonEncoding:
                guard let bodyParameters = bodyParameters,
                    let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)

            case .bodyDataEncoding:
                guard let bodyParameters = bodyParameters else { return }
                try DataParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)

            case .bodyUrlEncoding:
                guard let bodyParameters = bodyParameters else { return }
                try DataParameterUrlEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
            }
        } catch {
            throw error
        }
    }
}

/// A struct which is used in encoding url parameters into encoded query.
public struct URLParameterEncoder: ParameterEncodingProtocol {
    public func encode(urlRequest: inout URLRequest, with parameters: VFGParameters) throws {
        guard let url = urlRequest.url else { throw VFGNetworkError.missingURL }
        guard var urlComponents = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false),
            !parameters.isEmpty else { return }
        urlComponents.setQueryItems(with: parameters)
        urlRequest.url = urlComponents.url
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
    }
}

/// A struct which is used in encoding body parameters to json data
public struct JSONParameterEncoder: ParameterEncodingProtocol {
    public func encode(urlRequest: inout URLRequest, with parameters: VFGParameters) throws {
        do {
            let jsonData = try JSONSerialization.data(
                withJSONObject: serializedParameters(parameters),
                options: .prettyPrinted
            )
            urlRequest.httpBody = jsonData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw VFGNetworkError.encodingFailed
        }
    }
}

/// A struct which is used in encoding body parameters to data utf8
public struct DataParameterEncoder: ParameterEncodingProtocol {
    public func encode(urlRequest: inout URLRequest, with parameters: VFGParameters) throws {
        var urlComponents = URLComponents()
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        urlRequest.httpBody = urlComponents.percentEncodedQuery?.data(using: .utf8)
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
    }
}

public struct DataParameterUrlEncoder: ParameterEncodingProtocol {
    public func encode(urlRequest: inout URLRequest, with parameters: VFGParameters) throws {
        urlRequest.httpBody = Data(urlEncoded(formDataSet: parameters).utf8)
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
    }

    func urlEncoded(formDataSet: VFGParameters) -> String {
        return formDataSet.map { key, value in
            return  key + "=\(value)"
        }
        .joined(separator: "&")
    }
}

func serializedParameters(_ parameters: VFGParameters) -> [String: Any] {
    var serializedParameters: [String: Any] = [:]
    for (key, component) in parameters {
        serializedParameters[key] = component
    }

    return serializedParameters
}
