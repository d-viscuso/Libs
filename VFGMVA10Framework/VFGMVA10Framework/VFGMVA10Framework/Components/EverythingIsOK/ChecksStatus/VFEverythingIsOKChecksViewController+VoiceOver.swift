//
//  VFEverythingIsOKChecksViewController+VoiceOver.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 27/04/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

extension VFEverythingIsOKChecksViewController {
    func setupVoiceOverAccessibility() {
        logoImageView.isAccessibilityElement = true
        descriptionLabel.accessibilityLabel = "status description"
        descriptionLabel.accessibilityValue = descriptionLabel.text
        closeButton.accessibilityLabel = "close"
        logoImageView.accessibilityLabel = "logo icon"
        myProductsButton.accessibilityLabel = "my products"
        accessibilityCustomActions = [closeButtonVoiceOverAction()]
    }

    func setupVoiceOverAccessibility(for header: VFEverythingIsOKChecksHeaderCell) {
        header.titleLabel.isAccessibilityElement = true
        header.indicatorImageView.isAccessibilityElement = true
        header.headerIcon.isAccessibilityElement = true
        header.titleLabel.accessibilityLabel = "service title"
        header.titleLabel.accessibilityValue = header.titleLabel.text
        header.indicatorImageView.accessibilityLabel = "expansion indicator icon"
        header.indicatorImageView.accessibilityHint = header.willExpand ? "item is expanded" : "item is collapsed"
        header.headerIcon.accessibilityLabel = "\(header.titleLabel.text ?? "") service icon"
    }

    func setupVoiceOverAccessibility(for cell: VFEverythingIsOkCheckFailedCell, with status: EIOStatus) {
        cell.icon.isAccessibilityElement = true
        cell.titleLabel.isAccessibilityElement = true
        cell.descriptionLabel.isAccessibilityElement = true
        switch status {
        case .success:
            cell.icon.accessibilityLabel = "tick icon"
            cell.titleLabel.accessibilityLabel = "passed service title"
            cell.descriptionLabel.accessibilityLabel = "passed service description"
        case .failed:
            cell.icon.accessibilityLabel = "warning icon"
            cell.titleLabel.accessibilityLabel = "failed service title"
            cell.descriptionLabel.accessibilityLabel = "failed service description"
        case .inProgress:
            cell.icon.accessibilityLabel = "sync icon"
            cell.titleLabel.accessibilityLabel = "inprogress service title"
            cell.descriptionLabel.accessibilityLabel = "inprogress service description"
        }
        cell.titleLabel.accessibilityValue = cell.titleLabel.text
        cell.descriptionLabel.accessibilityValue = cell.descriptionLabel.text
    }

    func closeButtonVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "close action"
        return UIAccessibilityCustomAction(
            name: actionName,
            target: self,
            selector: #selector(closeButtonAction)
        )
    }
}
