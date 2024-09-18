//
//  UIView+RoundCorners.swift
//  VFGMVA10Foundation
//
//  Created by Sandra Morcos on 6/17/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

extension UIView: PropertyStoring {
    /// Another naming for *CGSize*
    public typealias ObjectType = CGSize

    private enum ObjectKeys {
        static var bounds = 0
    }

    var oldViewSize: CGSize? {
        get {
            return getAssociatedObject(&ObjectKeys.bounds)
        }
        set {
            setAssociatedObject(&ObjectKeys.bounds, newValue: newValue)
        }
    }

    func roundUpperCornersOs10Imp(cornerRadius: CGFloat) {
        guard oldViewSize != bounds.size else {
            return
        }
        var cornerMask = UIRectCorner()
        cornerMask.insert(.topLeft)
        cornerMask.insert(.topRight)
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: cornerMask,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        oldViewSize = bounds.size
    }

    /// Apply corner radius to top left corner and top right corner of view.
    /// - Parameter cornerRadius: Radius in float
    public func roundUpperCorners(cornerRadius: CGFloat) {
        guard oldViewSize == nil else {
            return
        }
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        oldViewSize = bounds.size
    }

    /// Apply corner radius to bottom left corner and bottom right corner of view.
    /// - Parameter cornerRadius: Radius in float
    public func roundBottomCorners(cornerRadius: CGFloat) {
        guard oldViewSize == nil else {
            return
        }
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        oldViewSize = bounds.size
    }

    /// Apply corner radius to bottom left and right corner and top right corner of view.
    /// - Parameter cornerRadius: Radius in float
    public func roundBottomAndRightCorners(cornerRadius: CGFloat) {
        guard oldViewSize == nil else {
            return
        }
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        oldViewSize = bounds.size
    }

    /// Apply corner radius to top left and bottom left corner of view.
    /// - Parameter cornerRadius: Radius in float
    public func roundLeftCorners(cornerRadius: CGFloat) {
        guard oldViewSize == nil else {
            return
        }
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        oldViewSize = bounds.size
    }

    /// Apply corner radius to top right and bottom right corner of view.
    /// - Parameter cornerRadius: Radius in float
    public func roundRightCorners(cornerRadius: CGFloat) {
        guard oldViewSize == nil else {
            return
        }
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        oldViewSize = bounds.size
    }

    /// Apply corner radius to all or specified view corners.
    /// - Parameter corners: CACornerMask corners to round
    /// - Parameter cornerRadius: Radius in float. Defaults to 6.0
    public func roundCorners(_ corners: CACornerMask? = nil, cornerRadius: CGFloat = 6.0) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        if let corners = corners {
            layer.maskedCorners = corners
        }
    }
}
