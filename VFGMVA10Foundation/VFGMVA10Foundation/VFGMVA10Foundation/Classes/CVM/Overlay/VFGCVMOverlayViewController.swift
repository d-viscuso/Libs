//
//  VFGCVMOverlayViewController.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed Sultan on 8/25/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import Lottie

/// A full screen overlay which contains image, title, subtitle, X button, action button
public class VFGCVMOverlayViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: VFGImageView!

    @IBOutlet var iconsContainerCenterConstrain: NSLayoutConstraint!
    @IBOutlet var iconsContainerLeadingConstrain: NSLayoutConstraint!

    @IBOutlet weak var iconsContainerView: UIView!
    @IBOutlet weak var mainIconContainerView: UIView!
    @IBOutlet weak var mainIconContainerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainIconContainerViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var rightIconContainerView: UIView!
    @IBOutlet weak var rightIconContainerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightIconContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightIconContainerViewBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var leftIconContainerView: UIView!
    @IBOutlet weak var leftIconContainerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftIconContainerViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var subTitleLabel: VFGLabel!
    @IBOutlet weak var primaryButton: VFGButton!
    @IBOutlet weak var secondaryButton: VFGButton!
    @IBOutlet weak var closeButton: VFGButton!
    @IBOutlet weak var customView: UIView!

    @IBOutlet var contentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var contentViewCenterConstraint: NSLayoutConstraint!
    @IBOutlet var contentViewBottomConstraint: NSLayoutConstraint!

    public var contentView: UIView?
    /// A delegate that is called when need to create custom CVM Overlay
    public weak var dataSource: VFGCVMOverlayDataSourceProtocol?
    /// A closure that is called when clicking on the X button
    public var dismissCompletion: (() -> Void)?
    /// A closure that is called when clicking on the primary action button
    public var primaryButtonCompletion: (() -> Void)?
    /// A closure that is called when clicking on the secondary action button
    public var secondaryButtonCompletion: (() -> Void)?
    var overlayViewModel: VFGCVMOverlayViewModel?

    // A list of animations to play when this view controller appears.
    private var animations: [AnimationView] = []

    public override var prefersStatusBarHidden: Bool {
        return true
    }

    public convenience init() {
        self.init(
            nibName: String(describing: VFGCVMOverlayViewController.self),
            bundle: Bundle.foundation)
    }

    public convenience init(with model: VFGCVMOverlayViewModel) {
        self.init(
            nibName: String(describing: VFGCVMOverlayViewController.self),
            bundle: Bundle.foundation)
        overlayViewModel = model
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setAccessibilityIdentifiers()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animations.forEach { $0.play() }
    }

    private func setupContentAlignment(_ alignment: VFGCVMOverlayContentAlignment) {
        [contentViewTopConstraint, contentViewCenterConstraint, contentViewBottomConstraint].forEach {
            $0?.isActive = false
        }
        switch alignment {
        case .top(let margin):
            contentViewTopConstraint?.isActive = true
            contentViewTopConstraint?.constant = margin
        case .center(let margin):
            contentViewCenterConstraint?.isActive = true
            contentViewCenterConstraint?.constant = margin
        case .bottom(let margin):
            contentViewBottomConstraint?.isActive = true
            contentViewBottomConstraint?.constant = margin
        }
    }

    private func setupIconsAlignment(_ alignment: VFGCVMOverlayIconsAlignment) {
        switch alignment {
        case .left(let margin):
            NSLayoutConstraint.changePriority(of: &iconsContainerCenterConstrain, to: .defaultLow)
            NSLayoutConstraint.changePriority(of: &iconsContainerLeadingConstrain, to: .required)
            iconsContainerLeadingConstrain?.constant = margin
        case .center(let margin):
            NSLayoutConstraint.changePriority(of: &iconsContainerLeadingConstrain, to: .defaultLow)
            NSLayoutConstraint.changePriority(of: &iconsContainerCenterConstrain, to: .required)
            iconsContainerCenterConstrain?.constant = margin
        }
    }

    private func set(style: VFGCVMOverlayStyle) {
        switch style {
        case .birthday:
            addImageView(withImage: VFGFoundationAsset.Image.star, in: rightIconContainerView)
            addImageView(withImage: VFGFoundationAsset.Image.star, in: leftIconContainerView)
        case let .custom(rightIcon, leftIcon):
            addImageView(withImage: rightIcon, in: rightIconContainerView)
            addImageView(withImage: leftIcon, in: leftIconContainerView)
            if rightIcon == nil {
                rightIconContainerViewHeightConstraint.constant = 0
                rightIconContainerViewBottomConstraint.constant = 0
            }
        case let .customIcons(rightIcon, leftIcon, rightSize, leftSize):
            setupCustomIcons(rightIcon: rightIcon, leftIcon: leftIcon, rightSize: rightSize, leftSize: leftSize)
        case .textOnly:
            iconsContainerView.isHidden = true
        }
    }

    private func setupCustomIcons(
        rightIcon: VFGCVMOverlayIcon? = nil,
        leftIcon: VFGCVMOverlayIcon? = nil,
        rightSize: CGSize = VFGCVMOverlayIcon.Size.medium,
        leftSize: CGSize = VFGCVMOverlayIcon.Size.small
    ) {
        rightIconContainerViewWidthConstraint.constant = rightSize.width
        rightIconContainerViewHeightConstraint.constant = rightSize.height
        switch rightIcon {
        case let .image(image):
            addImageView(withImage: image, in: rightIconContainerView)
        case let .animation(animation):
            addAnimationView(withAnimation: animation, in: rightIconContainerView)
        case .none:
            rightIconContainerViewHeightConstraint.constant = 0
            rightIconContainerViewBottomConstraint.constant = 0
        }

        leftIconContainerViewWidthConstraint.constant = leftSize.width
        leftIconContainerViewHeightConstraint.constant = leftSize.height
        switch leftIcon {
        case let .image(image):
            addImageView(withImage: image, in: leftIconContainerView)
        case let .animation(animation):
            addAnimationView(withAnimation: animation, in: leftIconContainerView)
        case .none:
            break
        }
    }

    func setupUI() {
        if let customOverlayview = dataSource?.customView {
            customView.isHidden = false
            customView.embed(view: customOverlayview)
            return
        }
        guard let overlayModel = overlayViewModel else { return }

        switch overlayModel.appearance {
        case .light:
            backgroundImageView.image = overlayModel.backgroundImage ?? VFGFoundationAsset.Image.greyBG
            titleLabel.textColor = .VFGPrimaryText
            subTitleLabel.textColor = .VFGPrimaryText
            // The rest of the elements are the same as defined in the XIB file.
        case .dark:
            backgroundImageView.image = overlayModel.backgroundImage ?? VFGFoundationAsset.Image.redBG
            titleLabel.textColor = .VFGWhiteText
            subTitleLabel.textColor = .VFGWhiteText
            primaryButton.backgroundStyle = VFGButton.BackgroundStyle.colored.rawValue
            closeButton.setImage(VFGFoundationAsset.Image.icCloseWhite, for: .normal)
            // The rest of the elements are the same as defined in the XIB file.
        }
        if let closeIconColor = overlayModel.closeIconColor, let templateImage = VFGFoundationAsset.Image.icClose {
            let templateButtonImage = templateImage.withRenderingMode(.alwaysTemplate)
            closeButton.setImage(templateButtonImage, for: .normal)
            closeButton.tintColor = closeIconColor
        }
        mainIconContainerViewWidthConstraint.constant = overlayModel.mainIconSize.width
        mainIconContainerViewHeightConstraint.constant = overlayModel.mainIconSize.height
        switch overlayModel.mainIcon {
        case let .image(image):
            addImageView(withImage: image, in: mainIconContainerView)
        case let .animation(animation):
            addAnimationView(withAnimation: animation, in: mainIconContainerView)
        case .none:
            mainIconContainerViewHeightConstraint.constant = 0
        }

        titleLabel.text = overlayModel.title
        if overlayModel.content != nil {
            subTitleLabel.text = overlayModel.content
        } else {
            subTitleLabel.attributedText = overlayModel.attributedContent
        }
        titleLabel.textAlignment = overlayModel.textContentAlignment
        subTitleLabel.textAlignment = overlayModel.textContentAlignment
        if let textColor = overlayModel.textColor {
            titleLabel.textColor = textColor
            subTitleLabel.textColor = textColor
        }
        setUpButtonsUI()
        set(style: overlayModel.style)
        setupContentAlignment(overlayModel.contentAlignment)
        setupIconsAlignment(overlayModel.iconsAlignment)
    }

    func setUpButtonsUI() {
        guard let overlayModel = overlayViewModel else { return }

        primaryButton.setTitle(overlayModel.primaryButtonTitle, for: .normal)
        if let title = overlayModel.secondaryButtonTitle {
            secondaryButton.isHidden = false
            secondaryButton.setTitle(title, for: .normal)
        } else {
            secondaryButton.isHidden = true
        }

        if let background = overlayModel.primaryButtonBackgroundColor,
            let textColor = overlayModel.primaryButtonTextColor {
            primaryButton.type = .customStyle
            primaryButton.backgroundColor = background
            primaryButton.setTitleColor(textColor, for: .normal)
        }
        if  let borderColor = overlayModel.primaryButtonBorder {
            primaryButton.layer.borderWidth = 1
            primaryButton.layer.borderColor = borderColor.cgColor
        }
        if let background = overlayModel.secondaryButtonBackgroundColor,
            let textColor = overlayModel.secondaryButtonTextColor {
            secondaryButton.type = .customStyle
            secondaryButton.backgroundColor = background
            secondaryButton.setTitleColor(textColor, for: .normal)
        }
    }

    func setAccessibilityIdentifiers() {
        backgroundImageView.accessibilityIdentifier = "overlayBackgroundImage"
        iconsContainerView.accessibilityIdentifier = "overlayIconsContainer"
        titleLabel.accessibilityIdentifier = "overlayType1PrimaryText"
        subTitleLabel.accessibilityIdentifier = "overlayBirthdaySecondaryText"
        primaryButton.accessibilityIdentifier = "overlayCloseButton"
        secondaryButton.accessibilityIdentifier = "overlaysecondaryButton"
        closeButton.accessibilityIdentifier = "btnClose"
    }
}

// MARK: Helpers
private extension VFGCVMOverlayViewController {
    func addImageView(withImage image: UIImage?, in view: UIView) {
        let imageView = VFGImageView(image: image)
        view.subviews.forEach { $0.removeFromSuperview() }
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.vfgAutoPinEdgesToSuperviewEdges()
    }

    func addAnimationView(withAnimation animation: Animation?, in view: UIView) {
        let animationView = AnimationView()
        view.addSubview(animationView)
        animationView.contentMode = .scaleAspectFill
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.animation = animation
        animationView.vfgAutoPinEdgesToSuperviewEdges()
        // Keep references to play when the controller appears.
        animations.append(animationView)
    }
}

// MARK: Actions
extension VFGCVMOverlayViewController {
    @IBAction func dismissOverlayPressed(_ sender: Any) {
        dismissCompletion?()
    }

    @IBAction func primaryButtonDidPress(_ sender: Any) {
        primaryButtonCompletion?()
    }

    @IBAction func secondaryButtonDidPress(_ sender: Any) {
        secondaryButtonCompletion?()
    }
}
