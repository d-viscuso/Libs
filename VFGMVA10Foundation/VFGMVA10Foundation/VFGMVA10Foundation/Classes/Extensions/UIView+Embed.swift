//
//  UIView+Embed.swift
//  VFGMVA10Foundation
//
//  Created by Sandra Morcos on 6/16/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

@IBDesignable
extension UIView {
    @IBInspectable var viewBackgroundColor: String {
        get {
            self.viewBackgroundColor
        }
        set {
            backgroundColor = UIColor(named: newValue, in: .foundation, compatibleWith: nil)
        }
    }
}

extension UIView {
    /// Embeds the given view in the current UIVIew object.
    /// - Parameters:
    ///    - view: The view that will be embeded in the current view.
    ///    - top: Top constraint of the given view relevant to the parent view.
    ///    - bottom: Bottom constraint of the given view relevant to the parent view.
    ///    - leading: Leading constraint of the given view relevant to the parent view.
    ///    - trailing: Trailing constraint of the given view relevant to the parent view.
    public func embed(view: UIView, top: CGFloat = 0, bottom: CGFloat = 0, leading: CGFloat = 0, trailing: CGFloat = 0) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        addConstraints(view: view, top: top, bottom: bottom, leading: leading, trailing: trailing)
    }
}

private extension UIView {
    /// Adds constraints to the given view relevant to the current UIView object.
    /// - Parameters:
    ///    - view: The view for the bottom, top, left or right  side of the constraint.
    ///    - top: Top constraint of the given view relevant to the current view.
    ///    - bottom: Bottom constraint of the given view relevant to the current view.
    ///    - leading: Leading constraint of the given view relevant to the current view.
    ///    - trailing: Trailing constraint of the given view relevant to the current view.
    func addConstraints(view: UIView, top: CGFloat = 0, bottom: CGFloat = 0, leading: CGFloat = 0, trailing: CGFloat = 0) {
        let topConstraint = NSLayoutConstraint(
            item: view,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1,
            constant: top
        )
        let bottomConstraint = NSLayoutConstraint(
            item: view,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1,
            constant: bottom
        )
        let leadingConstraint = NSLayoutConstraint(
            item: view,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self,
            attribute: .leading,
            multiplier: 1,
            constant: leading
        )
        let trailingConstraint = NSLayoutConstraint(
            item: view,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self,
            attribute: .trailing,
            multiplier: 1,
            constant: trailing
        )

        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
        view.updateConstraints()
    }
}
