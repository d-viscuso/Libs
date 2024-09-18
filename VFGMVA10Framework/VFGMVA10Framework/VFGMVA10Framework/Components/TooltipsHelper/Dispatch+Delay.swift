//
//  Dispatch+Delay.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 24/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

func delay(_ delay: Double, closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
        execute: closure)
}
