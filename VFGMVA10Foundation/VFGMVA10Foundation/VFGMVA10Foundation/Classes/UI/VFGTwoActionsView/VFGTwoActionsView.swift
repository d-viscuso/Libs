//
//  VFGTwoActionsView.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 7/1/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit

/// A view that appear on quick action to display text (title - description - more detail ) , an image and two action buttons.
public class VFGTwoActionsView: UIView {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconImageView: VFGImageView!
    @IBOutlet weak var iconStackView: UIStackView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var titleStackView: UIStackView!
    @IBOutlet weak var descriptionLabel: VFGLabel!
    @IBOutlet weak var descriptionStackView: UIStackView!
    @IBOutlet weak var moreDetailsLabel: VFGLabel!
    @IBOutlet weak var moreDetailsStackView: UIStackView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var primaryButton: VFGButton!
    @IBOutlet weak var secondaryButton: VFGButton!
    @IBOutlet weak var iconImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    /// A delegate that is called when clicking on two action's buttons
    public weak var delegate: VFGTwoActionsViewProtocol?
    /// A view style for two action's view which can be white or transparent
    var viewStyle: VFGTwoActionsViewStyle = .white {
        didSet {
            updateStyle(style: viewStyle)
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        frame = bounds
        autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    /// configure two actions view content , style and accessibility
    /// - Parameters:
    ///   - viewStyle: Style for background which can be white or transparent.
    ///   - bottomMargin: Bottom margin for the content view .
    ///   - iconImage: A icon image for two action view.
    ///   - titlesModel: Title model that contain content of views.
    ///   - titlesFontModel: Title font model that contain the font of views.
    ///   - titlesAlignmentModel: Title alignment model that contain the font of views.
    ///   - accessibilityIDsModel: Title accessibility model that contain the font of views.
    public func configure(
        viewStyle: VFGTwoActionsViewStyle,
        bottomMargin: CGFloat = 40,
        iconImage: UIImage? = nil,
        titlesModel: VFGTitlesModel,
        titlesFontModel: VFGTitlesFontModel = VFGTitlesFontModel(),
        titlesAlignmentModel: VFGTitlesAlignmentModel = VFGTitlesAlignmentModel(),
        accessibilityIDsModel: VFGTwoActionsAccessibilityModel = VFGTwoActionsAccessibilityModel(),
        imageDescription: String? = nil
    ) {
        hideEmptyFields(iconImage: iconImage, titlesModel: titlesModel)
        iconImageView.image = iconImage
        setupLabelsFont(titlesFontModel: titlesFontModel)
        setupLabelsText(titlesModel: titlesModel)
        setupLabelsAlignment(titlesAlignmentModel: titlesAlignmentModel)
        setupAccessibilityIDs(model: accessibilityIDsModel)
        setupAccessibilityVoiceover(with: imageDescription)
        self.viewStyle = viewStyle
        bottomConstraint.constant = bottomMargin
    }
    /// hide empty fields to setup content stack and description and title labels
    /// - Parameters:
    ///   - iconImage: A icon image for two action view.
    ///   - titlesModel: Title model that contain content of views.
    func hideEmptyFields(iconImage: UIImage?, titlesModel: VFGTitlesModel) {
        iconStackView.arrangedSubviews.first?.isHidden = iconImage == nil
        titleStackView.arrangedSubviews.first?.isHidden = titlesModel.title == nil &&
            titlesModel.titleAttributedString == nil
        moreDetailsStackView.arrangedSubviews.first?.isHidden = titlesModel.moreDetails == nil &&
            titlesModel.moreDetailsAttributedString == nil
        buttonsStackView.arrangedSubviews.last?.isHidden = titlesModel.secondaryButtonTitle == nil

        if titlesModel.description == nil,
            titlesModel.descriptionAttributedString == nil {
            descriptionStackView.arrangedSubviews.first?.isHidden = true
        } else {
            descriptionStackView.arrangedSubviews.first?.isHidden = false
        }
    }

    /// update background style and also the views inside it
    /// - Parameters:
    ///   - style: background style
    func updateStyle(style: VFGTwoActionsViewStyle) {
        let isWhiteStyle = style == .white
        titleLabel.textColor = isWhiteStyle ? .VFGPrimaryText : .white
        descriptionLabel.textColor = isWhiteStyle ? .VFGPrimaryText : .white
        moreDetailsLabel.textColor = isWhiteStyle ? .VFGPrimaryText : .white
        primaryButton.buttonStyle = 0
        primaryButton.backgroundStyle = isWhiteStyle ? 0 : 1
        secondaryButton.buttonStyle = isWhiteStyle ? 2 : 1
        secondaryButton.backgroundStyle = isWhiteStyle ? 0 : 1
    }
    /// setup Labels text background content
    /// - Parameters:
    ///   - titlesModel: content model for the two action view
    func setupLabelsText(titlesModel: VFGTitlesModel) {
        if let titleText = titlesModel.title {
            titleLabel.text = titleText
        } else if let titleTextAttributedString = titlesModel.titleAttributedString {
            titleLabel.attributedText = titleTextAttributedString
        }
        if let descriptionText = titlesModel.description {
            descriptionLabel.text = descriptionText
        } else if let descriptionAttributedString = titlesModel.descriptionAttributedString {
            descriptionLabel.attributedText = descriptionAttributedString
        }
        if let moreDetailsText = titlesModel.moreDetails {
            moreDetailsLabel.text = moreDetailsText
        } else if let moreDetailsAttributedString = titlesModel.moreDetailsAttributedString {
            moreDetailsLabel.attributedText = moreDetailsAttributedString
        }
        primaryButton.setTitle(titlesModel.primaryButtonTitle, for: .normal)
        secondaryButton.setTitle(titlesModel.secondaryButtonTitle, for: .normal)
    }
    /// setup labels text Font
    /// - Parameters:
    ///   - titlesFontModel: Font model for the two action view
    func setupLabelsFont(titlesFontModel: VFGTitlesFontModel) {
        titleLabel.font = titlesFontModel.titleFont
        descriptionLabel.font = titlesFontModel.descriptionFont
        moreDetailsLabel.font = titlesFontModel.moreDetailsFont
    }
    /// setup labels text alignment
    /// - Parameters:
    ///   - titlesFontModel: alignment model for the two action view
    func setupLabelsAlignment(titlesAlignmentModel: VFGTitlesAlignmentModel) {
        titleLabel.textAlignment = titlesAlignmentModel.titleAlignment
        descriptionLabel.textAlignment = titlesAlignmentModel.descriptionAlignment
        moreDetailsLabel.textAlignment = titlesAlignmentModel.moreDetailsAlignment
    }
    /// setup view's accessibility
    /// - Parameters:
    ///   - model: Accessibility IDs model for the two action view
    func setupAccessibilityIDs(model: VFGTwoActionsAccessibilityModel) {
        iconImageView.accessibilityIdentifier = model.icon
        titleLabel.accessibilityIdentifier = model.title
        descriptionLabel.accessibilityIdentifier = model.description
        moreDetailsLabel.accessibilityIdentifier = model.moreDetails
        primaryButton.accessibilityIdentifier = model.primaryButton
        secondaryButton.accessibilityIdentifier = model.secondaryButton
    }

    func setupAccessibilityVoiceover(with imageDescription: String?) {
        accessibilityCustomActions = []
        if !iconImageView.isHidden && imageDescription != nil {
            iconImageView.accessibilityLabel = imageDescription
        }
        if !titleLabel.isHidden {
            titleLabel.accessibilityLabel = titleLabel.text ?? ""
        }
        if !descriptionLabel.isHidden {
            descriptionLabel.accessibilityLabel = descriptionLabel.text ?? ""
        }
        if !moreDetailsLabel.isHidden {
            moreDetailsLabel.accessibilityLabel = moreDetailsLabel.text ?? ""
        }
        if !primaryButton.isHidden {
            primaryButton.accessibilityLabel = primaryButton.titleLabel?.text ?? ""
            accessibilityCustomActions?.append(primaryButtonVoiceoverAction())
        }
        if !secondaryButton.isHidden {
            secondaryButton.accessibilityLabel = secondaryButton.titleLabel?.text ?? ""
            accessibilityCustomActions?.append(secondaryButtonVoiceoverAction())
        }
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                secondaryButton.borderColor = viewStyle == .white ? .VFGSecondaryButtonOutline : .white
            }
        }
    }

    // MARK: - Actions
    @IBAction func primaryButtonAction(_ sender: Any) {
        primaryButtonPressed()
    }
    @objc func primaryButtonPressed() {
        delegate?.primaryButtonAction()
    }
    func primaryButtonVoiceoverAction() -> UIAccessibilityCustomAction {
        let actionName = primaryButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(primaryButtonPressed)
        )
    }

    @IBAction func secondaryButtonAction(_ sender: Any) {
        secondaryButtonPressed()
    }
    @objc func secondaryButtonPressed() {
        delegate?.secondaryButtonAction()
    }
    func secondaryButtonVoiceoverAction() -> UIAccessibilityCustomAction {
        let actionName = secondaryButton.titleLabel?.text ?? ""
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(secondaryButtonPressed)
        )
    }
}
