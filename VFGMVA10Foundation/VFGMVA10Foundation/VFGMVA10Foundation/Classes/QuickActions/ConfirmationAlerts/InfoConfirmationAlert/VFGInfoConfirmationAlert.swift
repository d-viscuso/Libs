//
//  VFGInfoConfirmationAlert.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed Sultan on 6/4/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

public protocol VFGInfoConfirmationAlertDelegate: AnyObject {
    /// Tells the delegate that the confirmation action is pressed
    func confirmActionPressed(completion: (() -> Void)?)
}

public class VFGInfoConfirmationAlert: UIView {
    // MARK: IBOutlets
    @IBOutlet public weak var infoIconImageView: VFGImageView!
    @IBOutlet public weak var infoQuestionLabel: VFGLabel!
    @IBOutlet public weak var infoAnswerLabel: VFGLabel!
    @IBOutlet public weak var confirmButton: VFGButton!
    @IBOutlet weak var infoIconImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var infoIconImageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var infoIconImageBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var infoIconImageTopSpace: NSLayoutConstraint!

    // MARK: Probs
    public weak var delegate: VFGInfoConfirmationAlertDelegate?
    public var model: VFGInfoConfirmationAlertModel? {
        didSet {
            setupUI()
        }
    }

    // MARK: private methods
    private func setupUI() {
        guard let model = model else {
            return
        }

        infoIconImageViewWidth.constant = model.infoIconSize.width
        infoIconImageViewHeight.constant = model.infoIconSize.height
        if model.infoIconSize.width == 0 {
            infoIconImageBottomSpace?.constant = 0
            infoIconImageTopSpace?.constant = 0
        }
        infoIconImageView.image = model.infoIcon
        infoIconImageView.enableDynamicDirection = false
        infoQuestionLabel.text = model.infoQuestion
        infoAnswerLabel.text = model.infoAnswer
        confirmButton.titleLabel?.font = .vodafoneRegular(18)
        confirmButton.setTitle(model.confirmButtonTitle, for: .normal)
        setupAccessibility()
    }

    private func setupAccessibility() {
        guard let model = model else { return }
        infoIconImageView.accessibilityLabel = model.infoIconDescription
        infoQuestionLabel.accessibilityLabel = model.infoQuestion
        infoAnswerLabel.accessibilityLabel = model.infoAnswer

        let accessibilityConfirmationAction = UIAccessibilityCustomAction(
            name: model.confirmButtonTitle,
            target: self,
            selector: #selector(confirm)
        )
        accessibilityCustomActions = [accessibilityConfirmationAction]
    }

    public func configureStyle(
        titlesAlignment: VFGTitlesAlignmentModel = VFGTitlesAlignmentModel(
            descriptionAlignment: .left,
            moreDetailsAlignment: .left),
        titlesFont: VFGTitlesFontModel = VFGTitlesFontModel(
            descriptionFont: .vodafoneLite(25),
            moreDetailsFont: .vodafoneRegular(16)),
        buttonStyleValue: Int = 2
    ) {
        setupLabelsAlignment(titlesAlignmentModel: titlesAlignment)
        setupLabelsFont(titlesFontModel: titlesFont)
        confirmButton.buttonStyle = buttonStyleValue
    }

    private func setupLabelsAlignment(titlesAlignmentModel: VFGTitlesAlignmentModel) {
        infoQuestionLabel.textAlignment = titlesAlignmentModel.descriptionAlignment
        infoAnswerLabel.textAlignment = titlesAlignmentModel.moreDetailsAlignment
    }
    private func setupLabelsFont(titlesFontModel: VFGTitlesFontModel) {
        infoQuestionLabel.font = titlesFontModel.descriptionFont
        infoAnswerLabel.font = titlesFontModel.moreDetailsFont
    }
    @IBAction private func confirm(_ sender: Any) {
        delegate?.confirmActionPressed(completion: nil)
    }
}
