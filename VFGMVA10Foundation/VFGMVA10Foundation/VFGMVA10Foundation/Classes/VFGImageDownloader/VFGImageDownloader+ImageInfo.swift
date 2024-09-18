//
//  VFGImageDownloader+ImageInfo.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 16/10/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

@objc extension VFGImageDownloader {
    func requestImageInfo(from url: URL, completion: @escaping ([String: String]?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"

        URLSession.shared.dataTask(with: request) { [weak self] _, response, error in
            if let error = error {
                VFGErrorLog(error.localizedDescription)
                completion(nil)
                return
            }

            guard let response = response as? HTTPURLResponse else {
                completion(nil)
                return
            }

            completion(self?.extractMetaData(from: response.allHeaderFields))
        }
        .resume()
    }

    func extractMetaData(from fields: [AnyHashable: Any]) -> [String: String] {
        var metaData: [String: String] = [:]
        cacheAttributes.forEach { attribute in
            metaData[attribute] = String(describing: fields[attribute])
        }
        return metaData
    }
}
