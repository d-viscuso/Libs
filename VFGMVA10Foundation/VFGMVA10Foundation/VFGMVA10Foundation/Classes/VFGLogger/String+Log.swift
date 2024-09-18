//
//  String+Log.swift
//  VFGMVA10Foundation
//
//  Created by Esraa Eldaltony on 6/25/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

extension String {
    internal static func logFileName(with prefix: String) -> String {
        let date = DateFormatter.logFileNameDateFormatter.string(from: Date())
        return "\(prefix)-\(date).log"
    }

    internal static func fullLogFilePath() -> String {
        let appName: String = Bundle.main.applicationName.replacingOccurrences(of: " ", with: "")
        let documentsPath: String = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true).first ?? ""
        if !FileManager.default.fileExists(atPath: documentsPath) {
            try? FileManager.default.createDirectory(
                atPath: documentsPath,
                withIntermediateDirectories: false,
                attributes: nil)
        }
        return "\(documentsPath)/\(String.logFileName(with: appName))"
    }
}
