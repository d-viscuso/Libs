//
//  PrimaryPlanUnlimitedCell.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 7/2/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class PrimaryPlanUnlimitedCell: UITableViewCell {
    @IBOutlet weak var planIconBGView: UIView!
    @IBOutlet weak var planIconImageView: VFGImageView!
    @IBOutlet weak var planTitleLabel: VFGLabel!
    @IBOutlet weak var unlimitedLabel: VFGLabel!
    @IBOutlet weak var labelsStackView: UIStackView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var customDetailsView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        for view in customDetailsView.subviews {
            view.removeFromSuperview()
        }
    }

    func setupViews() {
        unlimitedLabel?.text = "my_plan_primary_card_unlimited_consumption".localized(bundle: Bundle.mva10Framework)
        planIconBGView.backgroundColor = .darkGrayBackground
        planIconBGView.layer.cornerRadius = 6
        planTitleLabel.textColor = .primaryTextColor
        unlimitedLabel.textColor = .redTextColor
        progressBar.progressTintColor = .filledRedProgressBar
        progressBar.trackTintColor = .unfilledGrayProgressBar
    }

    func configure(with viewModel: PrimaryPlanCellViewModel?) {
        planIconImageView?.image = VFGImage(named: viewModel?.planIcon ?? "")
        planTitleLabel?.text = viewModel?.planTitle
        setupAccessibilityLabels()
    }

    private func setupAccessibilityLabels() {
        [self, planIconBGView, planIconImageView]
            .forEach { $0?.isAccessibilityElement = false }
        [planTitleLabel, unlimitedLabel]
            .forEach { $0?.isAccessibilityElement = true }
        guard
            let planTitleLabel = planTitleLabel,
            let unlimitedLabel = unlimitedLabel
        else { return }
        accessibilityElements = [ planTitleLabel, unlimitedLabel]
    }
}
