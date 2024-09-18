//
//  VFGEasingFunctions+Splash.swift
//  VFGMVA10Splash
//
//  Created by Hamsa Hassan on 9/18/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

extension CAMediaTimingFunction {
    @objc static var easeInQuart: CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.895, 0.03, 0.685, 0.22)
    }
}
