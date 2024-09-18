//
//  VFGEnvironment.swift
//  VFGMVA10Foundation
//
//  Created by Esraa Eldaltony on 6/27/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

@objc public class VFGEnvironment: NSObject {
    /**
    Determines whether application is running on Simulator.
    - Returns: true if running on simulator, false otherwise
    */
    @objc static public var isSimulator: Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }
}
