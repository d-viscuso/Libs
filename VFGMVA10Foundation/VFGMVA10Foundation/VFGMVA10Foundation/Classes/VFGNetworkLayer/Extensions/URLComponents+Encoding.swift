//
//  URLComponents+Encoding.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed Sultan on 10/15/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

extension URLComponents {
    mutating func setQueryItems(with parameters: VFGParameters) {
        self.queryItems = parameters.map {
            URLQueryItem(
                name: $0.key,
                value: "\($0.value)")
        }
    }
}
