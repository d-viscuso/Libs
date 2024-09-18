//
//  VFGErrorView.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed Sultan on 3/1/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit

/// View Error Model
public struct VFGErrorModel: Decodable {
    public var title: String?
    public var description: String?
    public var tryAgainText: String?

    public init(title: String? = nil, description: String? = nil, tryAgainText: String? = nil) {
        self.title = title
        self.description = description
        self.tryAgainText = tryAgainText
    }
}

/// Error View
public class VFGErrorView: ErrorView {
    // MARK: Properties
    public var refreshingClosure: (() -> Void)?
    let nibName = "VFGErrorView"
    var error: VFGErrorModel?

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tryAgainButton: VFGButton!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var tryAgainTopSpace: NSLayoutConstraint!
    @IBOutlet weak var stackBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var tryAgainStackView: UIStackView!
    // MARK: Action
    /// Try again action
    @IBAction func tryAgainPressed(_ sender: Any) {
        tryAgainAction()
    }

    /// Try again action
    @objc func tryAgainAction() {
        refreshingClosure?()
    }

    // MARK: init
    /// Error View Initializer
    /// - Parameters:
    ///    - error: Holds Error view model
    ///    - accessibilityIdInitial: Holds the accessibility identifier for the view UI element
    public required init(error: VFGErrorModel?, accessibilityIdInitial: String? = nil) {
        super.init(frame: CGRect.zero)

        xibSetup()
        configure(errorModel: error, accessibilityIdInitial: accessibilityIdInitial)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    // MARK: Methods
    private func xibSetup() {
        guard let view = loadViewFromNib(nibName: nibName) else {
            VFGErrorLog("VFGErrorView is nil")
            return
        }
        contentView = view
        xibSetup(contentView: contentView)
        setupUI()
    }

    public func configure(errorModel: VFGErrorModel?, accessibilityIdInitial: String? = nil) {
        error = errorModel
        setupAccessibilityIds(accessibilityIdInitial)

        setupUI()
        layoutIfNeeded()
    }

    public func configureErrorViewConstraints(
        height: CGFloat = 32,
        width: CGFloat = 32,
        imageViewTop: CGFloat = 50,
        bottom: CGFloat = 90,
        tryAgainTop: CGFloat = 0,
        stackSpace: CGFloat = 40
        ) {
            imageViewWidth.constant = width
            imageViewHeight.constant = height
            imageViewTopSpace.constant = imageViewTop
            tryAgainTopSpace.constant = tryAgainTop
            stackBottomSpace.constant = stackSpace
        }

    private func setupUI() {
        // error icon setup
        errorImageView.image = UIImage(
            named: "icWarningHiLightTheme",
            in: .foundation,
            compatibleWith: nil)
        errorImageView.contentMode = .scaleAspectFill
        // description label setup
        errorMessageLabel.font = UIFont.vodafoneRegular(16.7)
        errorMessageLabel.textColor = .VFGSecondaryText
        errorMessageLabel.text = error?.description
        // try again
        tryAgainLabel.textColor = UIColor.VFGRedOrangeTextMva12
        tryAgainLabel.text = error?.tryAgainText
        tryAgainLabel.font = UIFont.vodafoneRegular(14.6)
        // refresh image
        refreshImage.image = UIImage(
            named: "icRefreshRed",
            in: .foundation,
            compatibleWith: nil)
        refreshImage.contentMode = .scaleAspectFill
        setAccessibilityForVoiceOver()
    }
}

extension VFGErrorView {
    /// set accessibility for voice over
    func setAccessibilityForVoiceOver() {
        errorImageView.accessibilityLabel = "warning icon"
        errorMessageLabel.accessibilityLabel = errorMessageLabel.text
        tryAgainButton.accessibilityLabel = tryAgainLabel.text
        accessibilityElements = [
            errorImageView,
            errorMessageLabel,
            tryAgainButton
        ].compactMap { $0 }
        accessibilityCustomActions = [ tryAgainVoiceAction() ]
    }

    /// action for tryAgain button in voice over
    /// - Returns: action for tryAgain button in voice over
    func tryAgainVoiceAction() -> UIAccessibilityCustomAction {
        let actionName = "Tray Again"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(tryAgainAction))
    }
}
