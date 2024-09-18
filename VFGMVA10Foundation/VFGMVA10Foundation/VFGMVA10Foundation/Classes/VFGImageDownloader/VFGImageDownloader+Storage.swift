//
//  VFGImageDownloader+Storage.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 16/10/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

@objc extension VFGImageDownloader {
    func updateStoredImage(key: String, image: UIImage, metaData: [String: String]?) {
        checkStoredImage(key: key, backendMetaData: metaData) { storedImage in
            guard storedImage == nil else { return }
            VFGImageDownloader.storage.save(withKey: key, model: image.pngData())
            VFGImageDownloader.storage.saveMetaData(forKey: key, metaData: metaData)
        }
    }

    func checkStoredImage(key: String, backendMetaData: [String: String]?, completion: @escaping (UIImage?) -> Void) {
        VFGImageDownloader.storage.read(model: Data.self, withKey: key) { imageData in
            guard let imageData = imageData else {
                completion(nil)
                return
            }
            VFGImageDownloader.storage.readMetaData(withKey: key) { savedMetaData in
                let matchFound = NSDictionary(dictionary: savedMetaData ?? [:])
                    .isEqual(to: backendMetaData ?? [:])
                completion(matchFound ? UIImage(data: imageData) : nil)
            }
        }
    }
}
