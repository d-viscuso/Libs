//
//  VFGBalanceCardCell.swift
//  VFGMVA10Group
//
//  Created by Sandra Morcos on 11/11/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
/// Dashboard usage card collection view balance card
class VFGBalanceCardCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: VFGImageView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var midTextContainerView: UIView!
    @IBOutlet weak var remainingLabel: VFGLabel!
    @IBOutlet weak var unitsLabel: VFGLabel!
    @IBOutlet weak var totalDescriptionLabel: VFGLabel!
    @IBOutlet weak var remainingRatioProgressBar: UIView!
    @IBOutlet weak var remainingDaysLabel: VFGLabel!
    @IBOutlet weak var roamingIcon: VFGImageView?
    var progressBarPercentages: [Float] = []
    let progressBarColors: [UIColor] = [.VFGRedProgressBar, .white, .VFGAluminiumProgressBar]
    /// *VFGBalanceCardCell* configuration
    /// - Parameters:
    ///    - viewModel: *VFGBalanceCardCell* data source
    public func configure(with viewModel: BalanceViewModel) {
        iconImageView.image = UIImage.image(named: viewModel.imageName ?? "")
        titleLabel.text = viewModel.title?.localized()
        remainingDaysLabel.text = viewModel.remainingPeriodText
        if viewModel.usageType == .unlimited {
            remainingLabel.text = "usage_card_unlimited".localized()
            unitsLabel.text = ""
            totalDescriptionLabel.text = ""
        } else {
            remainingLabel.text = viewModel.remainingValueString
            unitsLabel.text = viewModel.units?.localized(bundle: Bundle.mva10Framework)
            totalDescriptionLabel.text = viewModel.totalValueDescription
        }
        let ratioPercentage = round(viewModel.progressRatio * 100)
        let grayColorPercent = 100.0 - (ratioPercentage + 1.0)
        let percentages = [ratioPercentage, 1.0, grayColorPercent]
        progressBarPercentages = percentages
        remainingRatioProgressBar.fillProgressBarColors(progressBarColors, withPercentage: percentages)
        contentView.accessibilityIdentifier = "DBMainCard"
        roamingIcon?.image = UIImage.image(named: viewModel.roamingIcon ?? "")
        titleLabel.accessibilityIdentifier = viewModel.usageType?.title
        setupAccessibilityLabels()
    }

    private func setupAccessibilityLabels() {
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityLabel = titleLabel.text

        let midText = [
            remainingLabel.text ?? "",
            unitsLabel.text ?? "",
            totalDescriptionLabel.text ?? ""
        ]
            .joined(separator: " ")
            .replacingOccurrences(of: "GB", with: "Gigabyte")
        midTextContainerView.isAccessibilityElement = true
        midTextContainerView.accessibilityLabel = midText

        [remainingLabel, unitsLabel, totalDescriptionLabel, remainingRatioProgressBar, roamingIcon]
            .forEach { $0?.isAccessibilityElement = false }
        remainingDaysLabel.accessibilityLabel = remainingDaysLabel.text
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if !progressBarPercentages.isEmpty {
            remainingRatioProgressBar.fillProgressBarColors(
                progressBarColors,
                withPercentage: progressBarPercentages)
        }
    }
}
