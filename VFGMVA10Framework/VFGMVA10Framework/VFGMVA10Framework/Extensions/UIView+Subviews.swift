//
//  UIView+Subviews.swift
//  VFGMVA10Group
//
//  Created by Sandra Morcos on 4/10/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

public extension UIView {
    /// Removes all subview from current this *UIView*.
    func removeSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}
