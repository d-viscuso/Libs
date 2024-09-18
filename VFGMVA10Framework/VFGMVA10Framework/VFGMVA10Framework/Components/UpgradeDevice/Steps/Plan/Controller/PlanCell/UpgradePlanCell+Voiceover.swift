//
//  UpgradePlanCell+Voiceover.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 10/05/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

extension UpgradePlanCell {
    /// set accessibility for voice over
    func setAccessibilityForVoiceOver() {
        if !recommendedView.isHidden {
            recommendedLabel.accessibilityLabel = recommendedLabel.text
        } else {
            recommendedLabel.accessibilityLabel = nil
        }

        planNameLabel.accessibilityLabel = planNameLabel.text
        planRecurringPriceLabel.accessibilityLabel = planRecurringPriceLabel.text
        chevronImageView.accessibilityLabel = "chevron image"
        planTopViewButton.accessibilityLabel = "expand collapse the plan"

        if !planExpandedView.isHidden {
            planSubscriptionTitleLabel.accessibilityLabel = planSubscriptionTitleLabel.text
            if !recommendedInfoView.isHidden {
                choosePlanTitleLabel.accessibilityLabel = choosePlanTitleLabel.text
                recommendedPlanInfoButton.accessibilityLabel = "recommended Plan Info"
            }
            choosePlanButton.accessibilityLabel = choosePlanButton.title(for: .normal)
        }

        accessibilityCustomActions = [
            planTopViewButtonVoiceOverAction()
        ]

        if !planExpandedView.isHidden {
            if !recommendedInfoView.isHidden {
                accessibilityCustomActions?.append(recommendedInfoButtonOverAction())
            }
            accessibilityCustomActions?.append(choosePlanButtonVoiceOverAction())
        }
    }

    /// action for planTopView button in voice over
    /// - Returns: action for planTopView button in voice over
    func planTopViewButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "tap plan header"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(planTopViewButtonAction))
    }

    /// action for recommendedInfo button in voice over
    /// - Returns: action for recommendedInfo button in voice over
    func recommendedInfoButtonOverAction() -> UIAccessibilityCustomAction {
        let actionName = "show why plan recommended"
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(recommendedInfoButtonAction)
        )
    }

    /// action for choosePlan button in voice over
    /// - Returns: action for choosePlan button in voice over
    func choosePlanButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "choose plan"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(choosePlanButtonAction))
    }

    func setupAccessibilityIdentifier(indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        planNameLabel.accessibilityIdentifier = "UDPCPlanNameS\(section)R\(row)ID"
        planTopViewButton.accessibilityIdentifier = "UDPCTopViewButtonS\(section)R\(row)ID"
        choosePlanButton.accessibilityIdentifier = "UDPCChoosePlanButtonS\(section)R\(row)ID"
        planImageView.accessibilityIdentifier = "UDPCImageS\(section)R\(row)ID"
        recommendedLabel.accessibilityIdentifier = "UDPCRecommendedLabelS\(section)R\(row)ID"
    }
}
