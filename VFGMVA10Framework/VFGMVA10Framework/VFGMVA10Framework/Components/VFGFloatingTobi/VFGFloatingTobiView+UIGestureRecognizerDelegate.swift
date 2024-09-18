//
//  VFGFloatingTobiView+UIGestureRecognizerDelegate.swift
//  VFGMVA10Framework
//
//  Created by Loodos on 8/12/22.
//

import Foundation

extension VFGFloatingTobiView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if isCollapesed, gestureRecognizer is UISwipeGestureRecognizer {
            return false
        }
        if isCollapesed == false, gestureRecognizer is UIPanGestureRecognizer {
            return false
        }
        return true
    }
}
