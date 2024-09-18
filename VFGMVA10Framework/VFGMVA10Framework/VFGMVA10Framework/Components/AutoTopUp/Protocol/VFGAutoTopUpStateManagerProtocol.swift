//
//  VFGAutoTopUpStateManagerProtocol.swift
//  VFGMVA10Framework
//
//  Created by Moataz Akram on 12/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// *VFGAutoTopUpStateManager* protocol
protocol VFGAutoTopUpStateManagerDelegate: AnyObject {
    /// Method to be called after finishing auto top up journey
    /// - Parameters:
    ///    - activeAutoTopUpModel: Auto top up model data
    func journeyDidFinish(activeAutoTopUpModel: VFGActiveAutoTopUpProtocol)
}
