//
//  DashboardTopupCard.swift
//  VFGMVA10Framework
//
//  Created by Esraa Eldaltony on 12/7/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//
import UIKit
import VFGMVA10Foundation

class DashboardTopupCard: UIView {
    @IBOutlet weak var spendingLabel: VFGLabel!
    @IBOutlet weak var currencyUnitLabel: VFGLabel!
    @IBOutlet weak var payDateLabel: VFGLabel!
    @IBOutlet weak var iconImageView: VFGImageView!
    @IBOutlet weak var descriptionLabel: VFGLabel!
    @IBOutlet weak var descriptionStackView: UIStackView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var badgeView: VFGBadgeView!
    @IBOutlet weak var spendingLabelBottom: NSLayoutConstraint!

    func configure(with model: VFGDashboardTopUpModel) {
        accessibilityIdentifier = "DBtopupCard"
        titleLabel.text =
            "dashboard_top_up_card_title".localized(bundle: .mva10Framework)
        descriptionLabel.text =
            "dashboard_top_up_card_subtitle".localized(bundle: .mva10Framework)

        let amount = model.value
        spendingLabel.text = "\(String(format: "%.2f", amount))"
        let currencyUnit = (model.unit).moneySymbol
        currencyUnitLabel.text = "\(currencyUnit)"

        let lastUpdatedText = "dashboard_top_up_card_last_updated".localized(bundle: .mva10Framework)
        payDateLabel.text =
            String(format: lastUpdatedText, "dashboard_top_up_card_last_updated_value".localized(
            bundle: .mva10Framework))

        let topUpState = model.topUpState
        switch topUpState {
        case .settled: // Paid
            descriptionLabel.superview?.isHidden = true
            badgeView.superview?.isHidden = true
            spendingLabelBottom.isActive = false
            payDateLabel.text =
                "dashboard_top_up_card_date_paid_title".localized(bundle: .mva10Framework)

        case .sent, .new: // UnPaid & Due date
            badgeView.update(
                with: BadgeModel(
                    text: "dashboard_top_up_card_badge_unpaid_title".localized(bundle: .mva10Framework),
                    backgroundColor: .VFGAlertError,
                    font: .vodafoneRegular(14.6))
            )
            payDateLabel.superview?.isHidden = true
            if topUpState == .sent {
                descriptionLabel.text =
                    "dashboard_top_up_card_description_unpaid_title".localized(bundle: .mva10Framework)
            } else {
                var remainingDaysString = ""
                if let dueDate = VFGDateHelper.getDateFromString(dateString: model.paymentDueDate ?? "") {
                    let remainingDays = Calendar.current.dateComponents([.day], from: Date(), to: dueDate).day
                    if let remainingDays = remainingDays {
                        remainingDaysString = String(remainingDays)
                    }
                }
                let localized = "dashboard_top_up_card_due_in_days".localized(bundle: .mva10Framework)
                let localizedString = String(format: localized, remainingDaysString, "")
                descriptionLabel.text = localizedString
            }

        default: // Due
            badgeView.superview?.isHidden = true
        }
        setupAccessibilityLabels()
    }

    private func setupAccessibilityLabels() {
        let descriptionAccessibilityElement = UIAccessibilityElement(accessibilityContainer: self)
        descriptionAccessibilityElement.accessibilityFrame = CGRect(
            x: descriptionStackView.frame.minX,
            y: descriptionStackView.frame.minY,
            width: descriptionStackView.frame.width,
            height: descriptionStackView.frame.height + spendingLabel.frame.height)
        descriptionAccessibilityElement.isAccessibilityElement = true
        descriptionAccessibilityElement.accessibilityTraits = .staticText
        let descriptionText = [
            descriptionLabel.text ?? "",
            spendingLabel.text ?? "",
            currencyUnitLabel.text ?? ""
        ].joined(separator: " ")
        descriptionAccessibilityElement.accessibilityLabel = descriptionText

        guard
            let titleLabel = titleLabel,
            let payDateLabel = payDateLabel
        else { return }
        accessibilityElements = [titleLabel, descriptionAccessibilityElement, payDateLabel]
    }
}
