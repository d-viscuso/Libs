//
//  ProductsScrollView.swift
//  VFGMVA10Framework
//
//  Created by Claudio Cavalli on 04/07/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
/// ProductsScrollView. ScrollView inside the cell that shouldRecognizeSimultaneouslyWith.
class ProductsScrollView: UIScrollView {}
// MARK: - ProductsScrollView UIGestureRecognizerDelegate
extension ProductsScrollView: UIGestureRecognizerDelegate {
    /// ProductsScrollView with shouldRecognizeSimultaneouslyWith set active.
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }
}
