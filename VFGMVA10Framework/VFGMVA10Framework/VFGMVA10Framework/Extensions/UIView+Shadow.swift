//
//  UIView+Shadow.swift
//  VFGMVA10Group
//
//  Created by Mohamed Mahmoud Zaki on 3/21/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    /// Method used to add Shadow on the *UIView*.
    /// - Parameters:
    ///    - size: Shadow offset.
    ///    - radius: Shadow Radius.
    ///    - opacity: Shadow opacity.
    func addingShadow(size: CGSize, radius: CGFloat, opacity: Float) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = size
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
}
