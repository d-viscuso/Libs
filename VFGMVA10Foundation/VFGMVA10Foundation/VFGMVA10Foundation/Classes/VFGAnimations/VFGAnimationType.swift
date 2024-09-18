//
//  VFGAnimationType.swift
//  VFGMVA10Foundation
//
//  Created by Fafoutis, Athinodoros, Vodafone Greece on 11/11/2020.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
    /// `VFGAnimationType` is a public enum for the available animation cases.
    /// - Cases:
    ///    - shake: Use this to simulate shaking animation on the view.
    ///    - rotate360: Use this to simulate 360 rotation animation on the view.
public enum VFGAnimationType: String, Codable {
    case shake
    case rotate360
}
