//
//  UIScrollView+ScrollToView.swift
//  VFGMVA10Foundation
//
//  Created by Erdem ILDIZ on 26.07.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit

public extension UIScrollView {
    /// Scrolls to the given view inside the current UIScrollView.
    /// - Parameters:
    ///    - view: View that will be scrolled to.
    ///    - animated: A boolean value to tell if the scroll will be animated or not.
    func scrollToView(view: UIView, animated: Bool) {
        if let origin = view.superview {
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            scrollRectToVisible(CGRect(x: 0, y: childStartPoint.y, width: 1, height: frame.height), animated: animated)
        }
    }
}
