//
//  UIView+DashBorder.swift
//  VFGMVA10Foundation
//
//  Created by Hamsa Hassan on 9/9/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

extension UIView {
    /// Draws dashed border on the current UIView object.
    /// - Parameters:
    ///    - color: Color of the dash line.
    ///    - lineDashPattern: Array of NSNumber objects that specify the lengths of the painted segments and unpainted segments, respectively, of the dash pattern.
    ///    - cornerRadius: The radius of each corner oval. A value of 0 results in a rectangle without rounded corners.
    ///     Values larger than half the rectangle’s width or height are clamped appropriately to half the width or height.
    public func addDashedBorder(
        color: UIColor,
        lineWidth: CGFloat,
        lineDashPattern: [NSNumber],
        cornerRadius: CGFloat
    ) {
        let shapeLayer = CAShapeLayer()
        let frameSize = frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = lineDashPattern
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: cornerRadius).cgPath
        layer.addSublayer(shapeLayer)
    }

    /// Draws dashed border on the current UIView object.
    /// - Parameters:
    ///    - pattern: Array of NSNumber objects that specify the lengths of the painted segments and unpainted segments, respectively, of the dash pattern.
    ///    - radius: The radius of each corner oval. Values larger than half the view’s width or height are clamped appropriately to half the width or height.
    ///    - color: Color of the dash line.
	@discardableResult
	public func addLineDashedStroke(pattern: [NSNumber]?, radius: CGFloat, color: UIColor) -> CALayer {
		let borderLayer = CAShapeLayer()
		let cornerRadius = CGSize(width: radius, height: radius)

		layer.sublayers?.forEach { layer in
			if layer is CAShapeLayer {
				layer.removeFromSuperlayer()
			}
		}

		layer.cornerRadius = radius
		layer.masksToBounds = true

		borderLayer.strokeColor = color.cgColor
		borderLayer.lineDashPattern = pattern
		borderLayer.frame = bounds
		borderLayer.fillColor = nil
		borderLayer.path = UIBezierPath(
			roundedRect: bounds,
			byRoundingCorners: .allCorners,
			cornerRadii: cornerRadius
		).cgPath

		layer.addSublayer(borderLayer)
		return borderLayer
	}
}
