//
//  VFGNetworkClient+Download.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 3/23/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

/// `VFGNetworkClient` class extension.
extension VFGNetworkClient {
    /// A method which gives you the ability to download a file with any extension by just passing the file URL to download method.
    /// - Parameters:
    ///   - url: A string object which represents the URL of the file you want to download at the server.
    ///   - progressClosure: A closure which monitor the download execution progress.
    ///   - completion: A completion handler which gets invoked once the download completed.
    public func download(
        url: String,
        progressClosure: VFGNetworkProgressClosure? = nil,
        completion: @escaping VFGNetworkDownloadClosure
    ) {
        let currentTask: URLSessionDownloadTaskProtocol
        let baseURL = URL(string: url)

        if let baseURL = baseURL {
            currentTask = session.downloadTask(with: baseURL) { location, response, error in
                DispatchQueue.main.async {
                    completion(location, response, error)
                }
            }
            currentTask.resume()
            networkProgressDelegate?.addTask(downloadTask: currentTask, progressClosure: progressClosure)
        }
    }
}
