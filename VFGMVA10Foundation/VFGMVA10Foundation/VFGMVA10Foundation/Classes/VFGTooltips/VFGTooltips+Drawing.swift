//
//  VFGTooltips+Drawing.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 18/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

extension VFGTooltips {
    func drawBubble(_ bubbleFrame: CGRect, arrowPosition: ArrowPosition, context: CGContext) {
        let arrowWidth = preferences.drawing.arrowWidth
        let arrowHeight = preferences.drawing.arrowHeight
        let cornerRadius = preferences.drawing.cornerRadius

        let contourPath = CGMutablePath()

        contourPath.move(to: CGPoint(x: arrowTip.x, y: arrowTip.y))

        switch arrowPosition {
        case .bottom, .top, .any:

            contourPath.addLine(
                to: CGPoint(
                    x: arrowTip.x - arrowWidth / 2,
                    y: arrowTip.y + (arrowPosition == .bottom ? -1 : 1) * arrowHeight))
            if arrowPosition == .bottom {
                drawBubbleBottomShape(bubbleFrame, cornerRadius: cornerRadius, path: contourPath)
            } else {
                drawBubbleTopShape(bubbleFrame, cornerRadius: cornerRadius, path: contourPath)
            }
            contourPath.addLine(
                to: CGPoint(
                    x: arrowTip.x + arrowWidth / 2,
                    y: arrowTip.y + (arrowPosition == .bottom ? -1 : 1) * arrowHeight))

        case .right, .left:

            contourPath.addLine(
                to: CGPoint(
                    x: arrowTip.x + (arrowPosition == .right ? -1 : 1) * arrowHeight,
                    y: arrowTip.y - arrowWidth / 2))

            if arrowPosition == .right {
                drawBubbleRightShape(bubbleFrame, cornerRadius: cornerRadius, path: contourPath)
            } else {
                drawBubbleLeftShape(bubbleFrame, cornerRadius: cornerRadius, path: contourPath)
            }

            contourPath.addLine(
                to: CGPoint(
                    x: arrowTip.x + (arrowPosition == .right ? -1 : 1) * arrowHeight,
                    y: arrowTip.y + arrowWidth / 2))
        }

        contourPath.closeSubpath()
        context.addPath(contourPath)
        context.clip()

        paintBubble(context)

        if preferences.hasBorder {
            drawBorder(contourPath, context: context)
        }
    }

    fileprivate func drawBubbleBottomShape(_ frame: CGRect, cornerRadius: CGFloat, path: CGMutablePath) {
        path.addArc(
            tangent1End: CGPoint(x: frame.x, y: frame.y + frame.height),
            tangent2End: CGPoint(x: frame.x, y: frame.y),
            radius: cornerRadius)
        path.addArc(
            tangent1End: CGPoint(x: frame.x, y: frame.y),
            tangent2End: CGPoint(x: frame.x + frame.width, y: frame.y),
            radius: cornerRadius)
        path.addArc(
            tangent1End: CGPoint(x: frame.x + frame.width, y: frame.y),
            tangent2End: CGPoint(x: frame.x + frame.width, y: frame.y + frame.height),
            radius: cornerRadius)
        path.addArc(
            tangent1End: CGPoint(x: frame.x + frame.width, y: frame.y + frame.height),
            tangent2End: CGPoint(x: frame.x, y: frame.y + frame.height),
            radius: cornerRadius)
    }

    fileprivate func drawBubbleTopShape(_ frame: CGRect, cornerRadius: CGFloat, path: CGMutablePath) {
        path.addArc(
            tangent1End: CGPoint(x: frame.x, y: frame.y),
            tangent2End: CGPoint(x: frame.x, y: frame.y + frame.height),
            radius: cornerRadius)
        path.addArc(
            tangent1End: CGPoint(x: frame.x, y: frame.y + frame.height),
            tangent2End: CGPoint(x: frame.x + frame.width, y: frame.y + frame.height),
            radius: cornerRadius)
        path.addArc(
            tangent1End: CGPoint(x: frame.x + frame.width, y: frame.y + frame.height),
            tangent2End: CGPoint(x: frame.x + frame.width, y: frame.y),
            radius: cornerRadius)
        path.addArc(
            tangent1End: CGPoint(x: frame.x + frame.width, y: frame.y),
            tangent2End: CGPoint(x: frame.x, y: frame.y),
            radius: cornerRadius)
    }

    fileprivate func drawBubbleRightShape(_ frame: CGRect, cornerRadius: CGFloat, path: CGMutablePath) {
        path.addArc(
            tangent1End: CGPoint(x: frame.x + frame.width, y: frame.y),
            tangent2End: CGPoint(x: frame.x, y: frame.y),
            radius: cornerRadius)
        path.addArc(
            tangent1End: CGPoint(x: frame.x, y: frame.y),
            tangent2End: CGPoint(x: frame.x, y: frame.y + frame.height),
            radius: cornerRadius)
        path.addArc(
            tangent1End: CGPoint(x: frame.x, y: frame.y + frame.height),
            tangent2End: CGPoint(x: frame.x + frame.width, y: frame.y + frame.height),
            radius: cornerRadius)
        path.addArc(
            tangent1End: CGPoint(x: frame.x + frame.width, y: frame.y + frame.height),
            tangent2End: CGPoint(x: frame.x + frame.width, y: frame.height),
            radius: cornerRadius)
    }

    fileprivate func drawBubbleLeftShape(_ frame: CGRect, cornerRadius: CGFloat, path: CGMutablePath) {
        path.addArc(
            tangent1End: CGPoint(x: frame.x, y: frame.y),
            tangent2End: CGPoint(x: frame.x + frame.width, y: frame.y),
            radius: cornerRadius)
        path.addArc(
            tangent1End: CGPoint(x: frame.x + frame.width, y: frame.y),
            tangent2End: CGPoint(x: frame.x + frame.width, y: frame.y + frame.height),
            radius: cornerRadius)
        path.addArc(
            tangent1End: CGPoint(x: frame.x + frame.width, y: frame.y + frame.height),
            tangent2End: CGPoint(x: frame.x, y: frame.y + frame.height),
            radius: cornerRadius)
        path.addArc(
            tangent1End: CGPoint(x: frame.x, y: frame.y + frame.height),
            tangent2End: CGPoint(x: frame.x, y: frame.y),
            radius: cornerRadius)
    }

    fileprivate func paintBubble(_ context: CGContext) {
        context.setFillColor(preferences.drawing.backgroundColor.cgColor)
        context.fill(bounds)
    }

    fileprivate func drawShadow(at path: CGPath?) {
        if preferences.hasShadow {
            self.layer.masksToBounds = false
            self.layer.shadowPath = path
            self.layer.shadowColor = preferences.drawing.shadowColor.cgColor
            self.layer.shadowOffset = preferences.drawing.shadowOffset
            self.layer.shadowRadius = preferences.drawing.shadowRadius
            self.layer.shadowOpacity = Float(preferences.drawing.shadowOpacity)
        }
    }

    fileprivate func drawBorder(_ borderPath: CGPath, context: CGContext) {
        context.addPath(borderPath)
        context.setStrokeColor(preferences.drawing.borderColor.cgColor)
        context.setLineWidth(preferences.drawing.borderWidth)
        context.strokePath()
    }

    fileprivate func drawText(_ bubbleFrame: CGRect, context: CGContext) {
        guard case .text(let text) = content else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = preferences.drawing.textAlignment
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping

        let textRect = getContentRect(from: bubbleFrame)

        let attributes = [
            NSAttributedString.Key.font: preferences.drawing.font,
            NSAttributedString.Key.foregroundColor: preferences.drawing.foregroundColor,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]

        text.draw(in: textRect, withAttributes: attributes)
    }

    fileprivate func drawAttributedText(_ bubbleFrame: CGRect, context: CGContext) {
        guard
            case .attributedText(let text) = content
            else {
                return
        }

        let textRect = getContentRect(from: bubbleFrame)

        text.draw(with: textRect, options: .usesLineFragmentOrigin, context: .none)
    }

    override open func draw(_ rect: CGRect) {
        let bubbleFrame = getBubbleFrame()

        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.saveGState()

        preferences.drawing.dotImage.draw(at: dot)
        drawBubble(bubbleFrame, arrowPosition: preferences.drawing.arrowPosition, context: context)

        switch content {
        case .text:
            drawText(bubbleFrame, context: context)
        case .attributedText:
            drawAttributedText(bubbleFrame, context: context)
        case .view(let view):
            addSubview(view)
        }

        drawShadow(at: context.path)
        context.restoreGState()
    }

    func getBubbleFrame() -> CGRect {
        let arrowPosition = preferences.drawing.arrowPosition
        let bubbleWidth: CGFloat
        let bubbleHeight: CGFloat
        let bubbleXOrigin: CGFloat
        let bubbleYOrigin: CGFloat
        switch arrowPosition {
        case .bottom, .top, .any:
            bubbleWidth = tipViewSize.width
                - preferences.positioning.bubbleInsets.left
                - preferences.positioning.bubbleInsets.right
            bubbleHeight = tipViewSize.height
                - preferences.positioning.bubbleInsets.top
                - preferences.positioning.bubbleInsets.bottom
                - preferences.drawing.arrowHeight

            bubbleXOrigin = preferences.positioning.bubbleInsets.left
            bubbleYOrigin = arrowPosition == .bottom
                ? preferences.positioning.bubbleInsets.top
                : preferences.positioning.bubbleInsets.top + preferences.drawing.arrowHeight

        case .left, .right:
            bubbleWidth = tipViewSize.width
                - preferences.positioning.bubbleInsets.left
                - preferences.positioning.bubbleInsets.right
                - preferences.drawing.arrowHeight
            bubbleHeight = tipViewSize.height
                - preferences.positioning.bubbleInsets.top
                - preferences.positioning.bubbleInsets.left

            bubbleXOrigin = arrowPosition == .right
                ? preferences.positioning.bubbleInsets.left
                : preferences.positioning.bubbleInsets.left + preferences.drawing.arrowHeight
            bubbleYOrigin = preferences.positioning.bubbleInsets.top
        }
        return CGRect(x: bubbleXOrigin, y: bubbleYOrigin, width: bubbleWidth, height: bubbleHeight)
    }

    func getContentRect(from bubbleFrame: CGRect) -> CGRect {
        return CGRect(
            x: bubbleFrame.origin.x + preferences.positioning.contentInsets.left,
            y: bubbleFrame.origin.y + preferences.positioning.contentInsets.top,
            width: bubbleFrame.width
                - preferences.positioning.contentInsets.left
                - preferences.positioning.contentInsets.right,
            height: contentSize.height)
    }
}
