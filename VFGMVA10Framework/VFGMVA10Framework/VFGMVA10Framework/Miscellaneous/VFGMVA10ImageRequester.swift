//
//  VFGMVA10ImageRequester.swift
//  VFGMVA10Framework
//
//  Created by Ivan Sanchez on 8/3/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

public enum VFGMVA10ImageRequester {
    // MARK: - DownloadTask
    public static func requestImage(_ url: String, success: @escaping (UIImage?) -> Void) {
        let completion: (Data?) -> Void = { data -> Void in
            if let data = data {
                success(UIImage(data: data))
            }
        }
        requestURL(url, success: completion)
    }
    fileprivate static func requestURL(_ url: String, success: @escaping (Data?) -> Void, error: ((NSError) -> Void)? = nil) {
        guard let requestURL = URL(string: url) else {
            assertionFailure("Error: Invalid URL")
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: requestURL)) { data, _, err in
            if let err = err {
                error?(err as NSError)
            } else {
                success(data)
            }
        }
        .resume()
    }
}
