//
//  URLSessionExtensions.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed Sultan on 10/17/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

/// A protocol which is conformed by `URLSessionTask`.
/// It is used to provide a shared type for session task.
public protocol URLSessionTaskProtocol {}

/// A protocol which is conformed by `URLSessionDataTask`.
/// This protocol is meant to use the utilities that is provided by `URLSessionDataTask` which is a concrete subclass of `URLSessionTask`.
/// It monitors the data task progress while returning data directly to the app (in memory) as one or more NSData objects and provide different utilities including resume, suspend and cancel current task.
public protocol URLSessionDataTaskProtocol {
    var progress: Progress { get }
    /// A method used to resume the suspended task.
    func resume()
    /// A method used to suspend a task.
    /// Suspending a task will prevent the NSURLSession from continuing to load data.
    func suspend()
    /// A method used to cancel a task.
    func cancel()
}

/// A protocol which is conformed by `URLSessionUploadTask`.
/// This protocol is meant to use the utilities that is provided by`URLSessionUploadTask` which is a concrete subclass of `URLSessionDataTask`.
/// It monitors the URL session task progress while uploading data to the network in a request body and provide different utilities including resume and cancel current task.
public protocol URLSessionUploadTaskProtocol {
    var progress: Progress { get }
    /// A method used to resume the suspended task.
    func resume()
    /// A method used to cancel a task.
    func cancel()
}

/// A protocol which is conformed by `URLSessionDownloadTask`.
/// This protocol is meant to use the utilities that is provided by `URLSessionDownloadTask` which is a concrete subclass of `URLSessionTask`.
/// It monitors the URL session task while storing downloaded data to a file and provide different utilities including resume and cancel current task.
public protocol URLSessionDownloadTaskProtocol {
    var progress: Progress { get }
    /// A method used to resume the suspended task.
    func resume()
    /// A method used to cancel a task.
    func cancel()
}

extension URLSessionTask: URLSessionTaskProtocol {}
extension URLSessionUploadTask: URLSessionUploadTaskProtocol {}
extension URLSessionDownloadTask: URLSessionDownloadTaskProtocol {}
extension URLSessionDataTask: URLSessionDataTaskProtocol {}

/// A protocol which is conformed by `URLSession`.
/// This protocol is meant to use the utilities that is provided by`URLSession` which is an object that coordinates a group of related, network data transfer tasks.
public protocol URLSessionProtocol {
    var sessionDelegate: VFGNetworkProgressDelegate? { get }
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    typealias DownloadTaskResult = (URL?, URLResponse?, Error?) -> Void
    /// A method which creates a task that retrieves the contents of a URL based on the specified URL request object, and calls a handler upon completion.
    /// - Parameters:
    ///   - request: An object of type *URLRequest* which represents the URL request.
    ///   - completionHandler: A completion handler which gets called once the runing request finished.
    /// - Returns: An object of type *URLSessionDataTaskProtocol*.
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
    /// A method which creates a task that retrieves the contents of a URL based on the specified URL object, and calls a handler upon completion.
    /// - Parameters:
    ///   - url: A string object which represents the URL of the EndPoint at the server.
    ///   - completionHandler: A completion handler which gets called once the runing request finished.
    /// - Returns: An object of type *URLSessionDataTaskProtocol*.
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
    /// A method which creates a task that performs an HTTP request for the specified URL request object and uploads the provided data.
    /// - Parameters:
    ///   - request: An object of type *URLRequest* which represents the URL request.
    ///   - data: An object of type *Data* which is a data object containing the transferred data.
    ///   - completionHandler: A completion handler which gets called once the provided data is uploaded.
    /// - Returns: An object of type *URLSessionUploadTaskProtocol*.
    func uploadTask(
        with request: URLRequest,
        from data: Data,
        completionHandler: @escaping DataTaskResult
    ) -> URLSessionUploadTaskProtocol
    /// A method which creates a download task that retrieves the contents of a URL based on the specified URL request object, saves the results to a file, and calls a handler upon completion.
    /// - Parameters:
    ///   - url: An object of type *URLRequest* which represents the URL request.
    ///   - completionHandler: A completion handler which gets called once the data is downloaded and saved.
    /// - Returns: An object of type *URLSessionDownloadTaskProtocol*.
    func downloadTask(with url: URL, completionHandler: @escaping DownloadTaskResult) -> URLSessionDownloadTaskProtocol
}

/// Default implementation for tasks so you do not need to implement extra methods in your session
public extension URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping DataTaskResult
    ) -> URLSessionDataTaskProtocol {
        completionHandler(nil, nil, nil)
        return URLSessionUploadTask()
    }
    func dataTask(
        with url: URL,
        completionHandler: @escaping DataTaskResult
    ) -> URLSessionDataTaskProtocol {
        completionHandler(nil, nil, nil)
        return URLSessionUploadTask()
    }
    func downloadTask(
        with url: URL,
        completionHandler: @escaping DownloadTaskResult
    ) -> URLSessionDownloadTaskProtocol {
        completionHandler(nil, nil, nil)
        return URLSessionDownloadTask()
    }
    func uploadTask(
        with request: URLRequest,
        from data: Data,
        completionHandler: @escaping DataTaskResult
    ) -> URLSessionUploadTaskProtocol {
        completionHandler(nil, nil, nil)
        return URLSessionUploadTask()
    }
}

extension URLSession: URLSessionProtocol {
    public var sessionDelegate: VFGNetworkProgressDelegate? {
        return delegate as? VFGNetworkProgressDelegate
    }
    public func downloadTask(
        with url: URL,
        completionHandler: @escaping DownloadTaskResult
    ) -> URLSessionDownloadTaskProtocol {
        return downloadTask(with: url, completionHandler: completionHandler) as URLSessionDownloadTask
    }
    public func dataTask(
        with url: URL,
        completionHandler: @escaping URLSessionProtocol.DataTaskResult
    ) -> URLSessionDataTaskProtocol {
        return dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask
    }
    public func uploadTask(
        with request: URLRequest,
        from data: Data,
        completionHandler: @escaping DataTaskResult
    ) -> URLSessionUploadTaskProtocol {
        return uploadTask(
            with: request,
            from: data,
            completionHandler: completionHandler
            ) as URLSessionUploadTask
    }
    public func dataTask(
        with request: URLRequest,
        completionHandler: @escaping URLSessionProtocol.DataTaskResult
    )
        -> URLSessionDataTaskProtocol {
            return dataTask(
                with: request,
                completionHandler: completionHandler
                ) as URLSessionDataTask
    }
}
