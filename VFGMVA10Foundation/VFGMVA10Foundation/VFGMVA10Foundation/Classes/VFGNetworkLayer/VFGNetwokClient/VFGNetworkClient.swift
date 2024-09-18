//
//  VFGNetworkClient.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed Sultan on 10/17/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
public typealias CurrentTask = (request: VFGRequestProtocol?, task: URLSessionDataTaskProtocol?)
var observation: [Int: NSKeyValueObservation] = [:]
/// A main class inside the VFGNetworkClient group that conforms to a protocol VFGNetworkClientProtocol.
/// It contains all the information to configure your network client base URL, headers related to the client, timeout, and session.
/// Note that this configuration is shared per same network client.
/// Exposed Network Client that will be inherited
open class VFGNetworkClient: VFGNetworkClientProtocol {
    var networkProgressDelegate: VFGNetworkProgressDelegate? {
        return session.sessionDelegate
    }
    var headerFields: [AnyHashable: Any]?
    public var runningTasks: [CurrentTask] = []
    open var timeout: TimeInterval { return NetworkDefaults.timeOut }
    public var baseUrl: String
    public var headers: [String: String]? { return nil }
    public var session: URLSessionProtocol
    public var authClientProvider: AuthTokenProvider?
    /// `VFGNetworkClient` class initializer.
    /// - Parameters:
    ///   - baseURL: A string object which represents the URL of the EndPoint at the server.
    ///   - session: An object of type *URLSessionProtocol* which represents the session used during HTTP request (default: URLSession.shared).
    public init(baseURL: String, session: URLSessionProtocol = URLSession.shared) {
        self.baseUrl = baseURL
        self.session = session
    }

    // MARK: - Execute

    /// - Parameters:
    ///   - request: An object of type *VFGRequestProtocol* which represents the running request.
    ///   - model: A generic type which represents the model that corresponds to the response data.
    ///   - progressClosure: A closure which monitor the download execution progress.
    ///   - completion: A completion handler which gets invoked once executing request is finished.
    open func executeData<T: Codable>(
        request: VFGRequestProtocol,
        model: T.Type,
        progressClosure: VFGNetworkProgressClosure? = nil,
        completion: @escaping VFGNetworkCompletionDelegate<T>
    ) {
        internalExecuteData(
            request: request,
            model: model,
            progressClosure: progressClosure,
            completion: completion
        )
    }

    /// A method used to convert your request to URL request and execute the request then provide the result and header fields through the completion closure.
    /// - Parameters:
    ///   - request: An object of type *VFGRequestProtocol* which represents the running request.
    ///   - model: A generic type which represents the model that corresponds to the response data.
    ///   - progressClosure: A closure which monitor the download execution progress.
    ///   - completion: A completion handler which gets invoked once executing request is finished.
    open func executeData<T: Codable>(
        request: VFGRequestProtocol,
        model: T.Type,
        progressClosure: VFGNetworkProgressClosure? = nil,
        completion: @escaping (Result<T, Error>, [AnyHashable: Any]?) -> Void
    ) {
        internalExecuteData(request: request, model: model, progressClosure: progressClosure, completion: completion)
    }

    /// A method which gives you the ability to cancel running requests.
    /// - Parameters:
    ///   - request: An object of type *VFGRequestProtocol* which represents the running request.
    ///   - completion: A completion handler which gets called once the runing request canceled.
    open func cancel(request: VFGRequestProtocol, completion: (() -> Void)?) {
        internalCancel(request: request, completion: completion)
    }

    // MARK: - Upload
    /// A method which gives you the ability to upload tasks.
    /// You can upload an object of type encodable by just passing the file model to upload method through `VFGNetworkClient`.
    /// - Parameters:
    ///   - request: An object of type *VFGRequestProtocol* which represents the network request.
    ///   - responseModel: A generic type which conforms to `Codable` and used to handle uploading response.
    ///   - uploadModel: An object of a generic type which conforms to `Encodable` and represents the uploaded data.
    ///   - completion: A completion handler which gets invoked once the upload completed.
    open func upload<T: Codable, U: Encodable>(
        request: VFGRequestProtocol,
        responseModel: T.Type,
        uploadModel: U,
        completion: @escaping VFGNetworkCompletionDelegate<T>
    ) {
        internalUpload(request: request, responseModel: responseModel, uploadModel: uploadModel, completion: completion)
    }

    // MARK: - Request

    /// A method which is used to build the URL request.
    /// - Parameters:
    ///   - endPoint: An object of type *VFGRequestProtocol* which represents the network request.
    ///   - headers: A dictionary of type *VFGHTTPHeaders* which represents HTTP request header.
    ///   - baseURL: A string object which represents the URL of the EndPoint at the server.
    /// - Returns: An object of type *URLRequest* which represents the built URL request.
    open func buildRequest(
        from endPoint: VFGRequestProtocol,
        with headers: VFGHTTPHeaders,
        to baseURL: URL?
    ) throws -> URLRequest {
        try internalBuildRequest(
            from: endPoint,
            with: headers,
            to: baseURL
        )
    }

    /// A method which is used to configure parameters encoding.
    /// - Parameters:
    ///   - bodyParameters: An array of type *VFGParameters* which holds the request body parameters.
    ///   - bodyEncoding: An enum which represents the type of encoding.
    ///   - urlParameters: An array of type *VFGParameters* which holds the request URL parameters.
    ///   - request: An object of type *URLRequest* which represents the network request.
    open func configureParameters(
        bodyParameters: VFGParameters?,
        bodyEncoding: VFGParameterEncoder,
        urlParameters: VFGParameters?,
        request: inout URLRequest
    ) throws {
        try internalConfigureParameters(
            bodyParameters: bodyParameters,
            bodyEncoding: bodyEncoding,
            urlParameters: urlParameters,
            request: &request
        )
    }

    /// A method which is used to build the header request.
    /// - Parameters:
    ///   - request: An object of type *VFGRequestProtocol* which represents the network request.
    ///   - completion: A completion handler which gets invoked if requesting authentication token failed with error.
    /// - Returns: A dictionary of type *VFGHTTPHeaders* which represents the built headers.
    open func buildHeaders<T: Codable>(request: VFGRequestProtocol, completion: @escaping VFGNetworkCompletionDelegate<T>) -> VFGHTTPHeaders {
        internalBuildHeaders(
            request: request,
            completion: completion
        )
    }

    // MARK: - Response
    /// A method which is used to decode Json data
    /// - Parameters:
    ///   - responseData: An object of type *Data* which represents the response data which will be decoded.
    ///   - model: A generic type which represents the model that corresponds to the response data.
    ///   - completion: A completion handler that gets invoked once the data decoding is done.
    open func decodeJsonData<T: Codable>(
        _ responseData: Data,
        _ model: T.Type,
        _ completion: @escaping VFGNetworkCompletionDelegate<T>
    ) {
        internalDecodeJsonData(responseData, model, completion)
    }

    /// A method which is used to map a given reponse arguments.
    /// - Parameters:
    ///   - responseArg: A tuple of type *ResponseArg* which holds a group of objects including data, url response and error.
    ///   - model: A generic type which represents the model that corresponds to the response data.
    ///   - completion: A completion handler that gets invoked once the response maping is done.
    open func mapResponse<T: Codable>(
        responseArg: ResponseArg,
        model: T.Type,
        completion: @escaping VFGNetworkCompletionDelegate<T>
    ) {
        internalMapResponse(
            responseArg: responseArg,
            model: model,
            completion: completion
        )
    }
}
