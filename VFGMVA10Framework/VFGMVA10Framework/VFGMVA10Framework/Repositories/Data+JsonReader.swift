//
//  Data+JsonReader.swift
//  mva10
//
//  Created by Sandra Morcos on 12/12/18.
//  Copyright © 2018 vodafone. All rights reserved.
//

import Foundation

public extension Data {
    /// Search for JSON file to get its contents
    /// - Parameters:
    ///    - fileName: Name of JSON file
    ///    - bundle: Bundle location for file
    init?(with fileName: String, bundle: Bundle = Bundle.mva10Framework) {
        let file = bundle.path(forResource: fileName, ofType: "json")
        guard let filePath = file else {
            return nil
        }
        try? self.init(contentsOf: URL(fileURLWithPath: filePath))
    }
}
