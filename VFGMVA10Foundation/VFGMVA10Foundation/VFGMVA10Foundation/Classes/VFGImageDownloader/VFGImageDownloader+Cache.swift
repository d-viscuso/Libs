//
//  VFGImageDownloader+Cache.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 16/10/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

@objc extension VFGImageDownloader {
    func updateCachedImage(key: String, image: UIImage, metaData: [String: String]?) {
        guard checkCachedImage(key: key, backendMetaData: metaData) == nil else { return }
        VFGImageDownloader.cache.save(
            image,
            forKey: key,
            metaData: metaData)
    }

    func checkCachedImage(key: String, backendMetaData: [String: String]?) -> UIImage? {
        guard let image = VFGImageDownloader.cache.retrieve(from: key).object else {
            return nil
        }
        let cachedMetaData = VFGImageDownloader.cache.retrieve(from: key).metaData
        let matchFound = NSDictionary(dictionary: cachedMetaData ?? [:])
            .isEqual(to: backendMetaData ?? [:])
        return matchFound ? image : nil
    }
}
