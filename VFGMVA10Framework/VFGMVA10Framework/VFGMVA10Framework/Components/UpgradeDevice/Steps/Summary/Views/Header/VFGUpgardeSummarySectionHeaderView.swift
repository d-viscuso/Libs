//
//  VFGUpgradeSummarySectionHeaderView.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 6/1/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFGUpgradeSummarySectionHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var titleStackView: UIStackView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var subtitleLabel: VFGLabel!
    @IBOutlet weak var editButtonView: UIView!
    @IBOutlet weak var editButtonTitleLabel: VFGLabel!
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var editButton: VFGButton!
    var buttonAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        titleStackView.isHidden = true
        subtitleLabel.isHidden = true
        editButtonView.isHidden = true
        setupAccessibilityIDs()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        titleStackView.isHidden = true
        subtitleLabel.isHidden = true
        editButtonView.isHidden = true
    }

    func setup(
        title: String? = nil,
        subtitle: String? = nil,
        buttonTitle: String? = nil,
        buttonAction: (() -> Void)? = nil
    ) {
        if title != nil {
            titleLabel.text = title
            titleStackView.isHidden = false
            stackViewTopConstraint.constant = 34

            if buttonTitle != nil {
                editButtonTitleLabel.text = buttonTitle
                editButtonView.isHidden = false
            }
        } else {
            // when there's no title
            // move-up subtitle
            stackViewTopConstraint.constant = -25
        }

        if subtitle != nil {
            subtitleLabel.text = subtitle
            subtitleLabel.isHidden = false
            stackViewBottomConstraint.constant = 16
        } else {
            // when there's no subtitle
            // move-down title
            stackViewBottomConstraint.constant = -7
        }

        self.buttonAction = buttonAction
        setupAccessibilityLabels()
    }

    @IBAction func editButtonDidPress(_ sender: Any) {
        editButtonAction()
    }

    @objc func editButtonAction() {
        buttonAction?()
    }
}

extension VFGUpgradeSummarySectionHeaderView {
    func setupAccessibilityLabels() {
        titleLabel.accessibilityLabel = titleLabel.text ?? ""
        subtitleLabel.accessibilityLabel = subtitleLabel.text ?? ""
        editButtonTitleLabel.accessibilityLabel = editButtonTitleLabel.text ?? ""
        accessibilityCustomActions = [editVoiceOverAction()]
    }
    /// action for edit upgrade summary voice over
    /// - Returns: action for edit upgrade summary  button in voice over

    func editVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "edit"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(editButtonAction))
    }

    func setupAccessibilityIDs() {
        titleLabel.accessibilityIdentifier = "UDSummaryHeaderTitleID"
    }
}
