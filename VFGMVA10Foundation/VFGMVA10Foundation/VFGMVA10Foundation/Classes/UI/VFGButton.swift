//
//  VFGButton.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 6/30/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import Lottie

/// Designable and inspectable UIButton that allows customization of font, size, style and background. **VFGButton** contains five button styles which vary depending on the background.
@IBDesignable
public class VFGButton: UIButton {
    // MARK: - initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    @objc public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        isEnabled = true
        layer.cornerRadius = 6
        setTitleColor(titleColor, for: .normal)
        setTitleFont()
        contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

    func setTitleFont() {
        setTitle("", for: .normal)
        titleLabel?.adjustsFontForContentSizeCategory = true
        titleLabel?.font = UIFont.font(
            of: FontType(name: titleLabel?.font?.fontName) ?? FontType.regular,
            with: titleLabel?.font?.pointSize ?? fontSize,
            shouldScale: shouldScaleFont
        )
    }

    /// Method to configure and control the loading animation inside the button
    /// - Parameters:
    ///   - animationControl: animation conrtol to play and stop the animation
    ///   - buttonTitle: a string to set the button title
    ///   - buttonState: to select one of the button states
    public func configureButtonAnimation(animationControl: ButtonAnimationControl, buttonTitle: String = "", buttonState: UIControl.State = .normal) {
        switch animationControl {
        case .play:
            addSubview(loadingAnimationView)
            DispatchQueue.main.async {
                self.loadingAnimationView.play()
            }
            self.isUserInteractionEnabled = false
            self.setTitle(buttonTitle, for: buttonState)
        case .stop:
            loadingAnimationView.stop()
            loadingAnimationView.removeFromSuperview()
            self.isUserInteractionEnabled = true
            self.setTitle(buttonTitle, for: buttonState)
        }
    }

    public override func traitCollectionDidChange(
        _ previousTraitCollection: UITraitCollection?
    ) {
        editButtonStyle()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        loadingAnimationView.frame = CGRect(x: frame.width / 2 - 20, y: frame.height / 2 - 20, width: 40, height: 40)
    }

    // MARK: - local properties
    var type: ButtonStyle = .customStyle
    var backgroundType: BackgroundStyle = .light
    var loadingAnimationView: AnimationView = {
        let view = AnimationView()
        view.animationSpeed = 1
        view.loopMode = .loop
        view.animation = Animation.vodafoneLogoRed
        return view
    }()

    // MARK: - inspectable(s)
    @IBInspectable var imageName: String = "" {
        didSet {
            setImage(VFGImage(named: imageName), for: state)
        }
    }
    /// Button text title color
    @IBInspectable var titleColor: UIColor? {
        get {
            return self.titleColor(for: .normal)
        }
        set {
            if let color = newValue {
                setTitleColor(color, for: .normal)
            } else {
                setTitleColor(.white, for: .normal)
            }
        }
    }

    /// Represent `ButtonStyle` enum and it has 6 value from 0 to 5
    /// - 0 : primary style
    /// - 1 : secondary style
    /// - 2 : Alternative 1
    /// - 3 : Alternative 2
    /// - 4 : custom style
    /// - 5 : icon style
    /// - 6 : selection style
    @IBInspectable public var buttonStyle: Int {
        get {
            return type.rawValue
        }
        set(buttonType) {
            type = ButtonStyle(rawValue: buttonType) ?? .customStyle
            editButtonStyle()
        }
    }

    /// Represent `BackgroundStyle` enum and it has 3 value from 0 to 2
    /// - 0 : light backgrounds
    /// - 1 : colored backgrounds
    @IBInspectable public var backgroundStyle: Int {
        get {
            return backgroundType.rawValue
        }
        set (type) {
            backgroundType = BackgroundStyle(rawValue: type) ?? .light
            editButtonStyle()
        }
    }

    @IBInspectable var shouldScaleFont: Bool = true {
        willSet(newValue) {
            titleLabel?.font = UIFont.font(
                of: FontType(rawValue: fontName) ?? FontType.regular,
                with: fontSize,
                shouldScale: newValue
            )
        }
    }

    @IBInspectable var fontName: Int = 0 {
        willSet(newValue) {
            titleLabel?.font = UIFont.font(of: FontType(rawValue: newValue) ?? FontType.regular, with: fontSize)
        }
    }

    @IBInspectable var fontSize: CGFloat = 22 {
        willSet(newValue) {
            titleLabel?.font = UIFont.font(of: FontType(rawValue: fontName) ?? FontType.regular, with: newValue)
        }
    }

    @IBInspectable public var isChosen: Bool = false {
        didSet {
            if buttonStyle == 6 {
                editButtonStyle()
            }
        }
    }

    // MARK: - overrides
    /// The background color when button enabled
    public override var isEnabled: Bool {
        didSet {
            let color = isEnabled ? enabledColor : disabledColor
            guard let buttonColor = color else {
                editButtonStyle()
                return
            }
            layer.borderWidth = 0
            backgroundColor = buttonColor
        }
    }
    /// `isHighlighted` status change button appearance depends on it's style and background
    public override var isHighlighted: Bool {
        didSet {
            editButtonStyle()
        }
    }

    // MARK: - public properties
    /// The button style
    public enum ButtonStyle: Int {
        case primary
        case secondary
        case alt1
        case alt2
        case customStyle
        /// icon button
        case icon
        case selection
    }

    /// Background mode
    public enum BackgroundStyle: Int {
        /// The light backgrounds
        case light
        /// The colored backgrounds
        case colored
    }

    /// Button animation control
    public enum ButtonAnimationControl {
        /// start animation
        case play
        /// stop animation
        case stop
    }

    /// The background color when button enabled
    public var enabledColor: UIColor? {
        willSet {
            if isEnabled == true {
                backgroundColor = newValue
            }
        }
    }

    /// The background color when button disabled
    public var disabledColor: UIColor? {
        willSet {
            if isEnabled == false {
                backgroundColor = newValue
            }
        }
    }

    // MARK: - private methods
    private func editButtonStyle() {
        switch backgroundType {
        case .light:
            lightStyle()
        case .colored:
            coloredStyle()
        }
    }

    private func lightStyle() {
        switch type {
        case .primary:
            updatePrimaryLightBackgroundColor()
            updatePrimaryLightTextColor()
        case .secondary:
            updateSecondaryLightBackgroundColor()
            updateSecondaryLightTextColor()
        case .alt1:
            updateAlt1LightBackgroundColor()
            updateAlt1LightTextColor()
        case .alt2:
            updateAlt2LightBackgroundColor()
            updateAlt2LightTextColor()
        case .icon:
            updateIconButtonStyle()
        case .customStyle:
            break
        case .selection:
            updateChooseButtonStyle()
            updateChooseButtonTextColorStyle()
        }
    }

    private func coloredStyle() {
        switch type {
        case .primary:
            updatePrimaryColoredBackgroundColor()
            updatePrimaryColoredTextColor()
        case .secondary:
            updateSecondaryColoredBackgroundColor()
            updateSecondaryColoredTextColor()
        case .alt1:
            updateAlt1ColoredBackgroundColor()
        case .alt2:
            break
        case .icon:
            updateIconButtonStyle()
        case .customStyle:
            break
        case .selection:
            break
        }
    }
}
