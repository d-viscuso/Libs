//
//  VFGNetworkProgressDelegate.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed Sultan on 11/6/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

/// A struct which represents a generic task which holds a data task and a download task.
/// It holds a progress handler closure to monitor task progress.
public struct GenericTask {
    var progressHandler: ((Double) -> Void)?
    var dataTask: URLSessionDataTaskProtocol?
    var downloadTask: URLSessionDownloadTaskProtocol?
    var expectedContentLength: Int64 = 0
    var buffer = Data()
}

/// A class delegate which is responsible for adding a new working task by providing data task, download task and progress closure.
open class VFGNetworkProgressDelegate: NSObject {
    var workingTask = GenericTask()
    public override init() {}
    func addTask(
        dataTask task: URLSessionDataTaskProtocol? = nil,
        downloadTask downTask: URLSessionDownloadTaskProtocol? = nil,
        progressClosure: VFGNetworkProgressClosure?
    ) {
        guard let progress = progressClosure else {
            return
        }
        workingTask.progressHandler = progress

        if let task = task {
            workingTask.dataTask = task
        } else if let task = downTask {
            workingTask.downloadTask = task
        }
    }
}

/// An extension of *VFGNetworkProgressDelegate*.
extension VFGNetworkProgressDelegate: URLSessionDataDelegate, URLSessionDownloadDelegate {
    /// A method which tells the delegate that the data task received the initial reply (headers) from the server.
    /// - Parameters:
    ///   - session: An object of type *URLSession* which is the session containing the data task that received an initial reply.
    ///   - dataTask: An object of type *URLSessionDataTask* which is the data task that received an initial reply.
    ///   - response: An object of type *URLResponse* which is the URL response object populated with headers.
    ///   - completionHandler: A completion handler that your code calls to continue a transfer, passing a `URLSession.ResponseDisposition` constant to indicate whether the transfer should continue as a data task or should become a download task.
    open func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive response: URLResponse,
        completionHandler: @escaping (URLSession.ResponseDisposition) -> Void
    ) {
        guard let task = workingTask.dataTask as? URLSessionDataTask, task == dataTask else {
            completionHandler(.cancel)
            return
        }
        workingTask.expectedContentLength = response.expectedContentLength
        completionHandler(.allow)
    }
    /// A method which tells the delegate that the data task has received some of the expected data.
    /// - Parameters:
    ///   - session: An object of type *URLSession* which is the session containing the data task that provided data.
    ///   - dataTask: An object of type *URLSessionDataTask* which is the data task that provided data.
    ///   - data: An object of type *Data* which is a data object containing the transferred data.
    open func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive data: Data
    ) {
        guard let task = workingTask.dataTask as? URLSessionDataTask, task == dataTask else {
            return
        }
        workingTask.buffer.append(data)
        let percentageDownloaded = Double(workingTask.buffer.count) / Double(workingTask.expectedContentLength)
        DispatchQueue.main.async {
            self.workingTask.progressHandler?(percentageDownloaded)
        }
    }
    /// A method which tells the delegate that the task finished transferring data.
    /// - Parameters:
    ///   - session: An object of type *URLSession* which is the session containing the task that has finished transferring data.
    ///   - task: An object of type *URLSessionDataTask* which is the task that has finished transferring data.
    ///   - error: An object of type *Error* which If an error occurred, an error object indicating how the transfer failed, otherwise NULL.
    open func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: Error?
    ) {
        guard let currentTask = workingTask.dataTask as? URLSessionDataTask, currentTask == task else {
            return
        }
        DispatchQueue.main.async {
            if error != nil {
                self.workingTask.progressHandler?(-1) // this means faild to track progress for any reason
            }
        }
    }
    /// A method which tells the delegate that a download task has finished downloading.
    /// - Parameters:
    ///   - session: An object of type *URLSession* which is the session containing the download task that finished.
    ///   - downloadTask: An object of type *URLSessionDownloadTask* which is the download task that finished.
    ///   - location: An object of type *URL* which is a file URL for the temporary file.
    ///   Because the file is temporary, you must either open the file for reading or move it to
    ///   a permanent location in your app’s sandbox container directory before returning
    ///   from this delegate method.
    public func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL
    ) {
        guard let currentTask = workingTask.downloadTask as? URLSessionDownloadTask,
            currentTask == downloadTask else {
                return
        }
        DispatchQueue.main.async {
            self.workingTask.progressHandler?(100) // this means faild to track progress for any reason
        }
    }
}
