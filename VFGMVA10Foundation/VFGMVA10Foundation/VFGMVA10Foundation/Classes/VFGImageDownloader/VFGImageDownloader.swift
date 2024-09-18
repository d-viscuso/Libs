//
//  VFGImageDownloader.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 16/10/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// Download image and store it.
public class VFGImageDownloader {
    static let cache = VFGCache<UIImage>()
    static let storage = VFGStorage()
    var cacheAttributes: [String] = []

    public init() {}

    /// A method used to download image and store it.
    /// First, it retrieves cached image and its metadata if they exist then update stored image data and if not
    /// check for them in storage if they exist updated cached image and if not download it from the backend.
    /// - Parameters:
    ///   - url: An image URL.
    ///   - cacheAttributes: A keys that are used in matadata extraction.
    ///   - completion: A closure that is invoked after the image is downloaded.
    public func download(
        from url: URL,
        cacheAttributes: [String] = [],
        completion: ((UIImage?) -> Void)?
    ) {
        if let imageFromAssets = VFGImage(named: url.absoluteString) {
            completion?(imageFromAssets)
            return
        }
        self.cacheAttributes = cacheAttributes
        requestImageInfo(from: url) { [weak self] imageInfo in
            guard let self = self else { return }
            guard let imageInfo = imageInfo else {
                self.downloadFromBackend(
                    from: url,
                    completion: completion)
                return
            }
            let urlString = url.absoluteString
            if let cachedImage = self.checkCachedImage(key: urlString, backendMetaData: imageInfo) {
                self.updateStoredImage(
                    key: urlString,
                    image: cachedImage,
                    metaData: imageInfo)
                completion?(cachedImage)
            } else {
                self.checkStoredImage(key: urlString, backendMetaData: imageInfo) { [weak self] storedImage in
                    guard let self = self else { return }
                    if let storedImage = storedImage {
                        self.updateCachedImage(
                            key: urlString,
                            image: storedImage,
                            metaData: imageInfo)
                        completion?(storedImage)
                    } else {
                        self.downloadFromBackend(from: url, completion: completion)
                    }
                }
            }
        }
    }

    /// Removes cached image with given URL from both VFGCache and VFGStorage.
    /// - Parameter url: URL of the cached image.
    public func removeCachedImage(with url: URL) {
        let urlString = url.absoluteString
        VFGImageDownloader.cache.remove(with: urlString)
        VFGImageDownloader.storage.remove(withKey: urlString)
    }

    func downloadFromBackend(from url: URL, completion: ((UIImage?) -> Void)? = nil) {
        downloadFromBackendRequest(from: url) { [weak self] image, httpURLResponse in
            guard let self = self, let image = image else {
                completion?(nil)
                return
            }
            let metaData = self.extractMetaData(from: httpURLResponse?.allHeaderFields ?? [:])
            self.updateCachedImage(
                key: url.absoluteString,
                image: image,
                metaData: metaData)
            self.updateStoredImage(
                key: url.absoluteString,
                image: image,
                metaData: metaData)
            completion?(image)
        }
    }

    func downloadFromBackendRequest(from url: URL, completion: ((UIImage?, HTTPURLResponse?) -> Void)? = nil) {
        URLSession.shared.dataTask(with: url) { data, response, _ in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data,
                let image = UIImage(data: data)
            else {
                completion?(nil, nil)
                return
            }
            completion?(image, httpURLResponse)
        }
        .resume()
    }
}
