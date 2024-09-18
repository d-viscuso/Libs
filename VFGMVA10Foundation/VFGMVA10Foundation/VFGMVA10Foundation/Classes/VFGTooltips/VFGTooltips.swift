//
//  VFGTooltips.swift
//  VFGMVA10Group
//
//  Created by Yahya Saddiq on 15/01/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit

public class VFGTooltips: UIView {
    // MARK: - Nested types -

    public enum ArrowPosition {
        case any
        case top
        case bottom
        case right
        case left

        static let allValues = [top, bottom, right, left]
    }

    enum Content: CustomStringConvertible {
        case text(String)
        case attributedText(NSAttributedString)
        case view(UIView)

        public var description: String {
            switch self {
            case .text(let text):
                return "text : '\(text)'"
            case .attributedText(let text):
                return "attributed text : '\(text)'"
            case .view(let contentView):
                return "view : \(contentView)"
            }
        }
    }

    // MARK: - Variables -

    override open var backgroundColor: UIColor? {
        didSet {
            guard let color = backgroundColor, color != UIColor.clear else { return }

            preferences.drawing.backgroundColor = color
            backgroundColor = UIColor.clear
        }
    }

    override open var description: String {
        let type = "'\(String(reflecting: Swift.type(of: self)))'".components(separatedBy: ".").last

        return "<< \(type ?? "") with \(content) >>"
    }

    weak var presentingView: UIView?
    weak var delegate: VFGTooltipsDelegate?
    var presentingViewFrame: CGRect?
    var dot = CGPoint.zero
    var arrowTip = CGPoint.zero
    fileprivate(set) open var preferences: Preferences
    let content: Content

    // MARK: - Lazy variables -

    lazy var contentSize: CGSize = { [unowned self] in
        switch content {
        case .text(let text):
            var attributes = [NSAttributedString.Key.font: self.preferences.drawing.font]

            var textSize = text.boundingRect(
                with: CGSize(
                    width: self.preferences.positioning.maxWidth,
                    height: CGFloat.greatestFiniteMagnitude
                ),
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: attributes,
                context: nil).size

            textSize.width = ceil(textSize.width)
            textSize.height = ceil(textSize.height)

            if textSize.width < self.preferences.drawing.arrowWidth {
                textSize.width = self.preferences.drawing.arrowWidth
            }

            return textSize

        case .attributedText(let text):
            var textSize = text.boundingRect(
                with: CGSize(
                    width: self.preferences.positioning.maxWidth,
                    height: CGFloat.greatestFiniteMagnitude
                ),
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                context: nil).size

            textSize.width = ceil(textSize.width)
            textSize.height = ceil(textSize.height)

            if textSize.width < self.preferences.drawing.arrowWidth {
                textSize.width = self.preferences.drawing.arrowWidth
            }

            return textSize

        case .view(let contentView):
            return contentView.frame.size
        }
    }()

    lazy var tipViewSize: CGSize = { [unowned self] in
        var tipViewSize =
            CGSize(
                width: UIScreen.main.bounds.width,
                height:
                    self.contentSize.height
                    + self.preferences.positioning.contentInsets.top
                    + self.preferences.positioning.contentInsets.bottom
                    + self.preferences.positioning.bubbleInsets.top
                    + self.preferences.positioning.bubbleInsets.bottom
                    + self.preferences.drawing.arrowHeight)

        return tipViewSize
    }()

    // MARK: - Static variables -

    public static var globalPreferences = Preferences()

    // MARK: - Initializer -

    convenience init (text: String, preferences: Preferences = VFGTooltips.globalPreferences, delegate: VFGTooltipsDelegate? = nil) {
        self.init(content: .text(text), preferences: preferences, delegate: delegate)

        self.isAccessibilityElement = true
        self.accessibilityTraits = UIAccessibilityTraits.staticText
        self.accessibilityLabel = text
    }

    convenience init (contentView: UIView, preferences: Preferences = VFGTooltips.globalPreferences, delegate: VFGTooltipsDelegate? = nil) {
        self.init(content: .view(contentView), preferences: preferences, delegate: delegate)
    }

    convenience init (text: NSAttributedString, preferences: Preferences = VFGTooltips.globalPreferences, delegate: VFGTooltipsDelegate? = nil) {
        self.init(content: .attributedText(text), preferences: preferences, delegate: delegate)
    }

    init (content: Content, preferences: Preferences = VFGTooltips.globalPreferences, delegate: VFGTooltipsDelegate? = nil) {
        self.content = content
        self.preferences = preferences
        self.delegate = delegate

        super.init(frame: CGRect.zero)

        self.backgroundColor = UIColor.clear

        let notificationName = UIDevice.orientationDidChangeNotification

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRotation),
            name: notificationName,
            object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    /**
        NSCoding not supported. Use init(text, preferences, delegate) instead!
        */
    required public init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported. Use init(text, preferences, delegate) instead!")
    }

    // MARK: - Rotation support -

    @objc func handleRotation() {
        guard let sview = superview, presentingView != nil else { return }

        UIView.animate(withDuration: 0.3) {
            self.arrange(withinSuperview: sview)
            self.setNeedsDisplay()
        }
    }

    func arrange(withinSuperview superview: UIView) {
        guard let presentingView = presentingView else {
            return
        }

        var position = preferences.drawing.arrowPosition
        /// the `refViewFrame` will be calculated from `presentingViewFrame` otherwise we will rely on `presentingView`
        let refViewFrame = presentingViewFrame ?? presentingView.convert(presentingView.bounds, to: superview)

        let superviewFrame: CGRect
        if let scrollview = superview as? UIScrollView {
            superviewFrame = CGRect(origin: scrollview.frame.origin, size: scrollview.contentSize)
        } else {
            superviewFrame = superview.frame
        }

        var frame = computeFrame(arrowPosition: position, refViewFrame: refViewFrame, superviewFrame: superviewFrame)

        if !isFrameValid(frame, forRefViewFrame: refViewFrame, withinSuperviewFrame: superviewFrame) {
            changeFramePosition(&position, refViewFrame, superviewFrame, &frame)
        }

        switch position {
        case .bottom, .top, .any:
            var arrowTipXOrigin: CGFloat
            let dotHorizontalMultiplier = preferences.positioning.dotHorizontalMultiplier
            if frame.width < refViewFrame.width {
                arrowTipXOrigin = tipViewSize.width * dotHorizontalMultiplier
            } else {
                arrowTipXOrigin = abs(frame.x - refViewFrame.x) + refViewFrame.width * dotHorizontalMultiplier
            }

            dot = CGPoint(
                x: arrowTipXOrigin - (preferences.drawing.dotImage.size.width / 2),
                y: position == .bottom
                    ? tipViewSize.height - preferences.drawing.dotImage.size.height
                    : 0
            )

            arrowTip = CGPoint(
                x: arrowTipXOrigin,
                y: position == .bottom
                    ? tipViewSize.height - preferences.positioning.bubbleInsets.bottom
                    : preferences.positioning.bubbleInsets.top
            )
        case .right, .left:
            var arrowTipYOrigin: CGFloat
            if frame.height < refViewFrame.height {
                arrowTipYOrigin = tipViewSize.height / 2
            } else {
                arrowTipYOrigin = abs(frame.y - refViewFrame.y) + refViewFrame.height / 2
            }

            arrowTip = CGPoint(
                x: preferences.drawing.arrowPosition == .left
                    ? preferences.positioning.bubbleInsets.left
                    : tipViewSize.width - preferences.positioning.bubbleInsets.right,
                y: arrowTipYOrigin)
        }

        if case .view(let contentView) = content {
            contentView.frame = getContentRect(from: getBubbleFrame())
        }

        self.frame = frame
    }

    // MARK: - Callbacks -
    @objc func handleTap() {
        self.delegate?.tooltipViewDidTap(self)
        guard preferences.animating.dismissOnTap else { return }
        dismiss()
    }
}

extension VFGTooltips {
    // MARK: - Private methods -
    private func changeFramePosition(_ position: inout VFGTooltips.ArrowPosition, _ refViewFrame: CGRect, _ superviewFrame: CGRect, _ frame: inout CGRect) {
        for value in ArrowPosition.allValues where value != position {
            let newFrame = computeFrame(
                arrowPosition: value,
                refViewFrame: refViewFrame,
                superviewFrame: superviewFrame
            )
            if isFrameValid(newFrame, forRefViewFrame: refViewFrame, withinSuperviewFrame: superviewFrame) {
                if position != .any {
                    VFGInfoLog("The arrow position you chose <\(position)> could not be applied. \n" +
                        "Instead, position <\(value)> has been applied! \n" +
                        "Please specify position <\(ArrowPosition.any)> \n" +
                        "if you want VFGTooltips to choose a position for you.")
                }

                frame = newFrame
                position = value
                preferences.drawing.arrowPosition = value
                break
            }
        }
    }

    fileprivate func computeFrame(arrowPosition position: ArrowPosition, refViewFrame: CGRect, superviewFrame: CGRect) -> CGRect {
        var xOrigin: CGFloat = 0
        var yOrigin: CGFloat = 0
        let dotVerticalMultiplier = preferences.positioning.dotVerticalMultiplier
        let dotImage = preferences.drawing.dotImage
        switch position {
        case .top, .any:
            xOrigin = refViewFrame.center.x - tipViewSize.width / 2
            yOrigin = (refViewFrame.y - (dotImage.size.height * dotVerticalMultiplier)) + refViewFrame.height
        case .bottom:
            xOrigin = refViewFrame.center.x - tipViewSize.width / 2
            yOrigin = (refViewFrame.y + (dotImage.size.height * dotVerticalMultiplier)) - tipViewSize.height
        case .right:
            xOrigin = refViewFrame.x - tipViewSize.width
            yOrigin = refViewFrame.center.y - tipViewSize.height / 2
        case .left:
            xOrigin = refViewFrame.x + refViewFrame.width
            yOrigin = refViewFrame.center.y - tipViewSize.height / 2
        }

        var frame = CGRect(x: xOrigin, y: yOrigin, width: tipViewSize.width, height: tipViewSize.height)
        adjustFrame(&frame, forSuperviewFrame: superviewFrame)
        return frame
    }

    fileprivate func adjustFrame(_ frame: inout CGRect, forSuperviewFrame superviewFrame: CGRect) {
        // adjust horizontally
        if frame.x < 0 {
            frame.x = 0
        } else if frame.maxX > superviewFrame.width {
            frame.x = superviewFrame.width - frame.width
        }

        // adjust vertically
        if frame.y < 0 {
            frame.y = 0
        } else if frame.maxY > superviewFrame.maxY {
            frame.y = superviewFrame.height - frame.height
        }
    }

    fileprivate func isFrameValid(_ frame: CGRect, forRefViewFrame: CGRect, withinSuperviewFrame: CGRect) -> Bool {
        return !frame.intersects(forRefViewFrame)
    }
}
