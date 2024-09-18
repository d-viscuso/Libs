//
//  File.swift
//  VFGMVA10Tests
//
//  Created by Tomasz Czyżak on 10/06/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
extension Date {
    var elapsedMilliseconds: Double {
        return Date().timeIntervalSince(self) * 1000
    }
}
