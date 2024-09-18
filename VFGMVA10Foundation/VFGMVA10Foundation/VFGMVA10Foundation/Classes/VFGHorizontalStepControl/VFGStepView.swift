//
//  VFGStepView.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 8/25/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit

class VFGStepView: UIView {
    @IBOutlet weak var pendingButton: VFGButton!
    @IBOutlet weak var inProgressButton: VFGButton!
    @IBOutlet weak var titleButton: VFGButton!
    @IBOutlet weak var titleLabel: VFGLabel!

    @IBOutlet weak var leftSeparator: UIView!
    @IBOutlet weak var rightSeparator: UIView!

    @IBOutlet weak var leftSeparatorToInProgressConstraints: NSLayoutConstraint!
    @IBOutlet weak var leftSeparatorToPendingConstraints: NSLayoutConstraint!
    @IBOutlet weak var rightSeparatorToInProgressConstraints: NSLayoutConstraint!
    @IBOutlet weak var rightSeparatorToPendingConstraints: NSLayoutConstraint!

    var previousStepAction: VFGStepAction = .complete
    var onStepDidPress: (() -> Void)?

    private(set) var status: VFGStepStatus = .pending
    private var action: VFGStepAction?

    func setup(
        with title: String,
        isFirstStep: Bool,
        isLastStep: Bool,
        isInteractionEnabled: Bool
    ) {
        titleLabel.text = title
        updateUI(with: isFirstStep ? .inProgress : .pending)

        leftSeparator.isHidden = isFirstStep
        rightSeparator.isHidden = isLastStep

        pendingButton.isUserInteractionEnabled = isInteractionEnabled
        inProgressButton.isUserInteractionEnabled = isInteractionEnabled
        titleButton.isUserInteractionEnabled = isInteractionEnabled
        addAccessibilityForVoiceOver()
    }

    @IBAction func pendingButtonDidPress() {
        guard status == .passed else {
            return
        }

        onStepDidPress?()
        addAccessibilityForVoiceOver()
    }

    func addAccessibilityForVoiceOver() {
        pendingButton.isAccessibilityElement = false
        inProgressButton.isAccessibilityElement = false
        titleLabel.isAccessibilityElement = false
        titleButton.isAccessibilityElement = true
        titleButton.accessibilityLabel = titleLabel.text
        let accessibilityHint = "\(titleLabel.text ?? "") step is \(status.rawValue)"
        titleButton.accessibilityHint = accessibilityHint
    }

    func setupAccessibilityIDs() {
        titleButton.accessibilityIdentifier = titleLabel.text
    }

    func updateUI(with action: VFGStepAction) {
        self.action = action

        switch action {
        case .complete:
            rightSeparator.backgroundColor = .VFGStepControlSeparatorInProgress
            enablePendingSeparatorConstraints()
            status = .passed
            changeFont(.passed)

            pendingButton?.backgroundColor = .VFGStepControlSeparatorInProgress
            pendingButton?.isHidden = false

            inProgressButton.isHidden = true
        case .skip:
            rightSeparator.backgroundColor = .VFGStepControlSeparatorSkipAction

            changeFont(.pending)

            pendingButton?.backgroundColor = .VFGStepControlSeparatorSkipAction
            pendingButton?.isHidden = false

            inProgressButton.isHidden = true
        case .link:
            rightSeparator.backgroundColor = .VFGStepControlSeparatorSkipAction
            rightSeparator.isHidden = false

        default:
            break
        }
        addAccessibilityForVoiceOver()
        setupAccessibilityIDs()
    }

    func updateUI(
        with status: VFGStepStatus,
        nextStepStatus: VFGStepStatus? = .pending,
        previousStepStatus: VFGStepStatus? = .pending
    ) {
        self.status = status

        switch status {
        case .pending:
            rightSeparator.backgroundColor = .VFGStepControlSeparatorSkipAction
            leftSeparator.backgroundColor = .VFGStepControlSeparatorSkipAction

            pendingButton?.backgroundColor = .VFGStepControlSeparatorSkipAction
            pendingButton?.isHidden = false
            inProgressButton.isHidden = true

            changeFont(.pending)
            enablePendingSeparatorConstraints()
        case .inProgress:
            if nextStepStatus == .pending {
                rightSeparator.backgroundColor = .VFGStepControlSeparatorSkipAction
            } else if nextStepStatus == .inProgress || nextStepStatus == .passed {
                rightSeparator.backgroundColor = .VFGStepControlSeparatorInProgress
            }

            if previousStepAction == .complete || previousStepStatus == .passed {
                leftSeparator.backgroundColor = .VFGStepControlSeparatorInProgress
            } else {
                leftSeparator.backgroundColor = .VFGStepControlSeparatorSkipAction
            }

            changeFont(.inProgress)
            enableInProgressSeparatorConstraints()
            inProgressButton.isHidden = false
        case .passed:
            if nextStepStatus == .pending {
                rightSeparator.backgroundColor = .VFGStepControlSeparatorSkipAction
            } else if nextStepStatus == .inProgress || nextStepStatus == .passed {
                rightSeparator.backgroundColor = .VFGStepControlSeparatorInProgress
            }

            if previousStepStatus == .passed {
                leftSeparator.backgroundColor = .VFGStepControlSeparatorInProgress
            }

            changeFont(.passed)
            enablePendingSeparatorConstraints()
            pendingButton?.backgroundColor = .VFGStepControlSeparatorInProgress
            inProgressButton.isHidden = true
            pendingButton?.isHidden = false
        default:
            break
        }
        addAccessibilityForVoiceOver()
    }

    private func enableInProgressSeparatorConstraints() {
        leftSeparatorToInProgressConstraints.priority = .defaultHigh
        rightSeparatorToInProgressConstraints.priority = .defaultHigh

        leftSeparatorToPendingConstraints.priority = .defaultLow
        rightSeparatorToPendingConstraints.priority = .defaultLow
    }

    private func enablePendingSeparatorConstraints() {
        leftSeparatorToPendingConstraints.priority = .defaultHigh
        rightSeparatorToPendingConstraints.priority = .defaultHigh

        leftSeparatorToInProgressConstraints.priority = .defaultLow
        rightSeparatorToInProgressConstraints.priority = .defaultLow
    }

    private func changeFont(_ status: VFGStepStatus) {
        switch status {
        case .inProgress:
            titleLabel.font = UIFont.vodafoneBold(VFGConstants.StepControl.Size.font)
            titleLabel.textColor = .VFGPrimaryText
        case .pending:
            titleLabel.font = UIFont.vodafoneRegular(VFGConstants.StepControl.Size.font)
            titleLabel.textColor = .VFGSecondaryText
        case .passed:
            titleLabel.font = UIFont.vodafoneRegular(VFGConstants.StepControl.Size.font)
            titleLabel.textColor = .VFGPrimaryText
        default: break
        }
    }
}
