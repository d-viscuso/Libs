//
//  VFGTooltips+Preferences.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 18/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

/// Tooltips appearance preferences
extension VFGTooltips {
    /// Tooltips appearance preferences
    public struct Preferences {
        public var drawing = Drawing()
        public var positioning = Positioning()
        public var animating = Animating()
        public var hasBorder: Bool {
            return drawing.borderWidth > 0 && drawing.borderColor != UIColor.clear
        }

        public var hasShadow: Bool {
            return drawing.shadowOpacity > 0 && drawing.shadowColor != UIColor.clear
        }

        public init() {}
    }

    /// Tooltips drawing  preferences
    public struct Drawing {
        public var dotImage = VFGFoundationAsset.Image.icTooltipDot ?? UIImage()
        public var cornerRadius = CGFloat(5)
        public var arrowHeight = CGFloat(13)
        public var arrowWidth = CGFloat(23)
        public var foregroundColor = UIColor.white
        public var backgroundColor = UIColor.VFGTimelineCellActive
        public var arrowPosition = ArrowPosition.any
        public var textAlignment = NSTextAlignment.center
        public var borderWidth = CGFloat(0)
        public var borderColor = UIColor.clear
        public var font = UIFont.systemFont(ofSize: 15)
        public var shadowColor = UIColor.clear
        public var shadowOffset = CGSize(width: 0.0, height: 0.0)
        public var shadowRadius = CGFloat(0)
        public var shadowOpacity = CGFloat(0)
    }

    /// Tooltips position  preferences
    public struct Positioning {
        public var dotVerticalMultiplier = CGFloat(0.5)
        public var dotHorizontalMultiplier = CGFloat(0.5)
        public var bubbleInsets = UIEdgeInsets(top: 50.0, left: 16.0, bottom: 50.0, right: 16.0)
        public var contentInsets = UIEdgeInsets(top: 17, left: 19, bottom: 23, right: 17)
        public var maxWidth = CGFloat(200)
    }

    /// Tooltips animation  preferences
    public struct Animating {
        public var dismissTransform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        public var showInitialTransform = CGAffineTransform(scaleX: 0, y: 0)
        public var showFinalTransform = CGAffineTransform.identity
        public var springDamping = CGFloat(0.7)
        public var springVelocity = CGFloat(0.7)
        public var showInitialAlpha = CGFloat(0)
        public var dismissFinalAlpha = CGFloat(0)
        public var showDuration = 0.7
        public var dismissDuration = 0.7
        public var dismissOnTap = false
    }
}
