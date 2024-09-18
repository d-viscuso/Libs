//
//  VFGNetworkClientProtocol.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed Sultan on 10/16/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

public typealias VFGNetworkCompletion = ( Codable?, Error? ) -> Void
public typealias VFGNetworkCompletionDelegate<T: Codable> = (Result<T, Error>) -> Void
public typealias VFGNetworkProgressClosure = ((Double) -> Void)?
public typealias VFGNetworkDownloadClosure = ( URL?, URLResponse?, Error? ) -> Void
/// A protocol which contains all the information to configure your network client base URL, headers related to the client, timeout, and session.
/// Note that this configuration is shared per same network client.
public protocol VFGNetworkClientProtocol {
    /// The URL of the EndPoint at the server.
    var baseUrl: String { get }
    /// A dictionary containing all the Client Related HTTP header fields (default: nil)
    var headers: [String: String]? { get }
    /// The session used during HTTP request (default: URLSession.shared)
    var session: URLSessionProtocol { get }
    /// the authClientProvider module may be injected
    var authClientProvider: AuthTokenProvider? { get set }
    /// The HTTP request timeout.
    var timeout: TimeInterval { get }
    @available(*, deprecated, message: "please use executeData instead")
    /// A method used to start a network execution to start http request.
    /// - Parameters:
    ///   - request: An object of type *VFGRequestProtocol* which represents the running request.
    ///   - model: A generic type which represents the model that corresponds to the response data.
    ///   - progressClosure: A closure which monitor the download execution progress.
    ///   - completion: A completion handler which gets invoked once executing request is finished.
    func execute<T: Codable>(
        request: VFGRequestProtocol,
        model: T.Type,
        progressClosure: VFGNetworkProgressClosure?,
        completion: @escaping VFGNetworkCompletion
    )
    /// A method used to fetch a response from your call using a given request with a codable model type which satisfies the response.
    /// - Parameters:
    ///   - request: An object of type *VFGRequestProtocol* which represents the running request.
    ///   - model: A generic type which represents the model that corresponds to the response data.
    ///   - progressClosure: A closure which monitor the download execution progress.
    ///   - completion: A completion handler which gets invoked once executing request is finished.
    func executeData<T: Codable>(
        request: VFGRequestProtocol,
        model: T.Type,
        progressClosure: VFGNetworkProgressClosure?,
        completion: @escaping VFGNetworkCompletionDelegate<T>
    )
    /// A method used to upload tasks.
    /// You can upload an object of type encodable by just passing the file model to upload method through `VFGNetworkClient`.
    /// - Parameters:
    ///   - request: An object of type *VFGRequestProtocol* which represents the network request.
    ///   - responseModel: A generic type which conforms to `Codable` and used to handle uploading response.
    ///   - uploadModel: An object of a generic type which conforms to `Encodable` and represents the uploaded data.
    ///   - completion: A completion handler which gets invoked once the upload completed.
    func upload<T: Codable, U: Encodable>(
        request: VFGRequestProtocol,
        responseModel: T.Type,
        uploadModel: U,
        completion: @escaping VFGNetworkCompletionDelegate<T>
    )
    /// A method used to download a file with any extension.
    /// You can download an audioFile by just passing the file URL to download method in `VFGNetworkClient`.
    /// - Parameters:
    ///   - url: A string object which represents the URL of the file you want to download at the server.
    ///   - progressClosure: A closure which monitor the download execution progress.
    ///   - completion: A completion handler which gets invoked once the download completed.
    func download(
        url: String,
        progressClosure: VFGNetworkProgressClosure?,
        completion: @escaping VFGNetworkDownloadClosure
    )
    /// A method used to cancel current task execution.
    /// - Parameters:
    ///   - request: An object of type *VFGRequestProtocol* which represents the network request.
    ///   - completion: A completion handler which gets invoked once the request execution is canceled.
    func cancel(request: VFGRequestProtocol, completion: (() -> Void)?)
}

/// A protocol which is meant to handle HTTP response status codes indicate whether a specific HTTP request has been successfully completed.
public protocol HTTPURLResponseProtocol {
    /// A method used to HTTP response status codes indicate whether a specific HTTP request has been successfully completed.
    /// - Returns: An enum of type *VFGNetworkError* which holds an error message corresponds to specific response.
    func handleNetworkResponse() -> VFGNetworkError?
}
