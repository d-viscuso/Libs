//
//  VFGLoadingLogoView.swift
//  VFGMVA10Foundation
//
//  Created by Moustafa Hegazy on 10/6/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import Lottie

/// Vodafone loading logo style
public enum VFGLoadingStyle {
    /// White Vodafone logo style
    case white
    /// Red Vodafone logo style
    case red
    /// Style automatically configured by current user interface mode (Light or Dark)
    case automatic
}

/// A generic UIView that can be shown while loading. Consists of AnimationView, title and subtitle
open class VFGLoadingLogoView: UIView {
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var labelsStackView: UIStackView!
    @IBOutlet public weak var titleLabel: VFGLabel!
    @IBOutlet weak var subtitleLabel: VFGLabel!
    @IBOutlet weak var animationViewHeightConstraint: NSLayoutConstraint!

    static var loadingLogoView: VFGLoadingLogoView?
    var style: VFGLoadingStyle? {
        didSet {
            switch style {
            case .white:
                animation = .vodafoneLogoWhite
            case .red:
                animation = .vodafoneLogoRed
            default:
                animation = .vodafoneLogo
            }
        }
    }
    var animationBackgroundColor: UIColor?
    lazy var animation: Animation? = {
        switch style {
        case .white:
            animation = .vodafoneLogoWhite
        case .red:
            animation = .vodafoneLogoRed
        default:
            animation = .vodafoneLogo
        }

        return animation
    }()
    var view: UIView?

    open override func awakeFromNib() {
        super.awakeFromNib()
        animationView.superview?.backgroundColor = animationBackgroundColor
    }

    /**
    Configure loading view to animate in a parent view

    - Parameter style: The loading style, default is white Vodafone logo loading
    - Parameter view: The superView that you want to add the loading view to
    - Parameter backgroundColor: The loading view background color
    - Parameter title: The title, default is nil and it will be hidden
    - Parameter titleFont: The title font, default is nil
    - Parameter titleTextColor: The title, default is nil
    - Parameter subtitle: The subtitle, default is nil and it will be hidden
    */
    public func configure(
        style: VFGLoadingStyle? = .automatic,
        view: UIView,
        backgroundColor: UIColor,
        title: String? = nil,
        titleFont: UIFont? = nil,
        titleTextColor: UIColor? = nil,
        subtitle: String? = nil,
        subtitleTextColor: UIColor? = nil
    ) {
        self.style = style
        self.view = view
        self.backgroundColor = backgroundColor

        guard title != nil else {
            labelsStackView.isHidden = true
            return
        }

        titleLabel.text = title
        if let titleFont = titleFont {
            titleLabel.font = titleFont
        }

        if let titleTextColor = titleTextColor {
            titleLabel.textColor = titleTextColor
        }
        subtitleLabel.text = subtitle

        if let subtitleTextColor = subtitleTextColor {
            subtitleLabel.textColor = subtitleTextColor
        }
        setAccessibilityVoiceOver()
    }

    /**
    Configure loading

    - Parameter style: The loading style, default is white Vodafone logo loading
    - Parameter height: The container view height constant
    - Parameter backgroundColor: The loading view background color
    - Parameter animationViewHeight: The loading view background color
    - Parameter title: The title, default is nil and it will be hidden
    - Parameter titleFont: The title font, default is nil
    - Parameter titleTextColor: The title, default is nil
    - Parameter subtitle: The subtitle, default is nil
    */
    public func configure(
        style: VFGLoadingStyle? = .automatic,
        height: CGFloat,
        backgroundColor: UIColor = .VFGWhiteBackground,
        animationViewHeight: CGFloat? = nil,
        title: String? = nil,
        titleFont: UIFont? = nil,
        titleTextColor: UIColor? = nil,
        subtitle: String? = nil
    ) {
        self.style = style
        self.backgroundColor = backgroundColor

        heightAnchor.constraint(equalToConstant: height).isActive = true

        if let animationViewHeight = animationViewHeight {
            animationViewHeightConstraint.constant = animationViewHeight
        }
        guard title != nil else {
            labelsStackView.isHidden = true
            return
        }

        titleLabel.text = title
        subtitleLabel.text = subtitle

        if let titleFont = titleFont {
            titleLabel.font = titleFont
        }

        if let titleTextColor = titleTextColor {
            titleLabel.textColor = titleTextColor
        }
        setAccessibilityVoiceOver()
    }

    /// Handle *animationView* animation process &
    /// its behavior in background &
    /// its loop mode
    public func startLoading() {
        animationView.animation = animation
        animationView.play()
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.loopMode = .loop
        if let view = view {
            frame = view.bounds
            view.addSubview(self)
        }
    }
    /// Remove loading view from screen
    public func endLoading() {
        removeFromSuperview()
    }

    func setAccessibilityVoiceOver() {
        animationView.accessibilityLabel = "Vodafone logo loading animated view"
        titleLabel.accessibilityLabel = titleLabel.text ?? ""
        subtitleLabel.accessibilityLabel = subtitleLabel.text ?? ""
    }
}
