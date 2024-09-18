//
//  UIKiteExtension.swift
//  VFGMVA10Group
//
//  Created by Yahya Saddiq on 15/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit

// MARK: - UIBarItem extension -

extension UIBarItem {
    var view: UIView? {
        if let item = self as? UIBarButtonItem, let customView = item.customView {
            return customView
        }
        return self.value(forKey: "view") as? UIView
    }
}

// MARK: - UIView extension -

extension UIView {
    func hasSuperview(_ superview: UIView) -> Bool {
        return viewHasSuperview(self, superview: superview)
    }

    fileprivate func viewHasSuperview(_ view: UIView, superview: UIView) -> Bool {
        guard let sview = view.superview else {
            return false
        }

        if sview === superview {
            return true
        } else {
            return viewHasSuperview(sview, superview: superview)
        }
    }
}

// MARK: - CGRect extension -

extension CGRect {
    var x: CGFloat {
        get {
            return self.origin.x
        }
        set {
            self.origin.x = newValue
        }
    }

    var y: CGFloat {
        get {
            return self.origin.y
        }

        set {
            self.origin.y = newValue
        }
    }

    var center: CGPoint {
        return CGPoint(x: self.x + self.width / 2, y: self.y + self.height / 2)
    }
}
public extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    static func += (lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
}
