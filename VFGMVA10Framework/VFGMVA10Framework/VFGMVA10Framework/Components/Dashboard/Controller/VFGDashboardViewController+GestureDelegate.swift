//
//  VFGDashboardViewController+GestureDelegate.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 12/2/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

extension VFDashboardViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}
