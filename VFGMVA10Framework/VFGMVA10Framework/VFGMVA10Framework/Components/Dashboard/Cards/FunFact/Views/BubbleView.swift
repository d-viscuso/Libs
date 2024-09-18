//
//  BubbleView.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 02/02/2022.
//

import Foundation
import UIKit

@IBDesignable
open class BubbleView: UIView {
    // MARK: - IBInspectable
    @IBInspectable public var arrowTopLeft: Bool = false
    @IBInspectable public var arrowTopCenter: Bool = false
    @IBInspectable public var arrowTopRight: Bool = false
    @IBInspectable public var arrowBottomLeft: Bool = false
    @IBInspectable public var arrowBottomCenter: Bool = false
    @IBInspectable public var arrowBottomRight: Bool = false
    @IBInspectable public var fillColor: UIColor = UIColor.clear
    @IBInspectable public var bubbleBorderColor: UIColor = UIColor.black
    @IBInspectable public var bubbleBorderRadius: CGFloat = 5
    @IBInspectable public var bubbleBorderWidth: CGFloat = 0.5
    @IBInspectable public var shadowColor: UIColor = UIColor.clear
    @IBInspectable public var shadowOffsetX: CGFloat = 0
    @IBInspectable public var shadowOffsetY: CGFloat = 2
    @IBInspectable public var shadowBlur: CGFloat = 10
    // MARK: Global Variables
    var tooltipWidth: CGFloat = UIScreen.main.bounds.width - 52
    var tooltipHeight: CGFloat = 130
    let bubblePath = UIBezierPath()
    // MARK: Initialization

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawTooltip()
    }

    // MARK: Private Methods

    /// Orientation methods
    private func topLeft(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }

    private func topRight(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: tooltipWidth - x, y: y)
    }

    private func bottomLeft(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: tooltipHeight - y)
    }

    private func bottomRight(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: tooltipWidth - x, y: tooltipHeight - y)
    }

    /// Draw methods
    public func drawTooltip() {
        // Top left corner
        bubblePath.move(to: topLeft(0, bubbleBorderRadius))
        let topLeftStartPoint = topLeft(bubbleBorderRadius, 0)
        let topLeftPoint1 = topLeft(0, bubbleBorderRadius / 2)
        let topLeftPoint2 = topLeft(bubbleBorderRadius / 2, 0)
        bubblePath.addCurve(to: topLeftStartPoint, controlPoint1: topLeftPoint1, controlPoint2: topLeftPoint2)

        // Top right corner
        bubblePath.addLine(to: topRight(bubbleBorderRadius, 0))
        let topRightStartPoint = topRight(0, bubbleBorderRadius)
        let topRightPoint1 = topRight(bubbleBorderRadius / 2, 0)
        let topRightPoint2 = topRight(0, bubbleBorderRadius / 2)
        bubblePath.addCurve(to: topRightStartPoint, controlPoint1: topRightPoint1, controlPoint2: topRightPoint2)

        // Bottom right corner
        bubblePath.addLine(to: bottomRight(0, bubbleBorderRadius))
        let bottomRtStartPoint = bottomRight(bubbleBorderRadius, 0)
        let bottomRtPoint1 = bottomRight(0, bubbleBorderRadius / 2)
        let bottomRtPoint2 = bottomRight(bubbleBorderRadius / 2, 0)
        bubblePath.addCurve(to: bottomRtStartPoint, controlPoint1: bottomRtPoint1, controlPoint2: bottomRtPoint2)

        // Bottom left corner
        bubblePath.addLine(to: bottomLeft(bubbleBorderRadius, 0))
        let bottomLeftStartPoint = bottomLeft(0, bubbleBorderRadius)
        let bottomLeftPoint1 = bottomLeft(bubbleBorderRadius / 2, 0)
        let bottomLeftPoint2 = bottomLeft(0, bubbleBorderRadius / 2)
        bubblePath.addCurve(to: bottomLeftStartPoint, controlPoint1: bottomLeftPoint1, controlPoint2: bottomLeftPoint2)
        bubblePath.close()

        // Shadow Layer
        addShadowShape()
        // Border Layer
        addBorderShape()
        // Fill Layer
        addfillShape()
    }

    private func addBorderShape() {
        let borderShape = CAShapeLayer()
        borderShape.path = bubblePath.cgPath
        borderShape.fillColor = fillColor.cgColor
        borderShape.strokeColor = bubbleBorderColor.cgColor
        borderShape.lineWidth = CGFloat(bubbleBorderWidth * 2)
        layer.insertSublayer(borderShape, at: 0)
    }

    private func addShadowShape() {
        let shadowShape = CAShapeLayer()
        shadowShape.path = bubblePath.cgPath
        shadowShape.fillColor = fillColor.cgColor
        shadowShape.shadowColor = shadowColor.cgColor
        shadowShape.shadowOffset = CGSize(width: CGFloat(shadowOffsetX), height: CGFloat(shadowOffsetY))
        shadowShape.shadowRadius = CGFloat(shadowBlur)
        shadowShape.shadowOpacity = 0.8
        layer.insertSublayer(shadowShape, at: 0)
    }

    private func addfillShape() {
        let fillShape = CAShapeLayer()
        fillShape.path = bubblePath.cgPath
        fillShape.fillColor = fillColor.cgColor
        layer.insertSublayer(fillShape, at: 0)
    }
}
