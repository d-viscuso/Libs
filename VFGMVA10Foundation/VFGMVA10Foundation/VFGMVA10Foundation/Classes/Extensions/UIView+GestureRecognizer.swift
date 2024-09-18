//
//  UIView+GestureRecognizer.swift
//  VFGMVA10Foundation
//
//  Created by Sandra Morcos on 3/26/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    /// Removes all gestures related to the current UIView object.
    public func removeGestures() {
        guard let gestures = gestureRecognizers else {
            return
        }
        for gesture in gestures {
            removeGestureRecognizer(gesture)
        }
    }
}
