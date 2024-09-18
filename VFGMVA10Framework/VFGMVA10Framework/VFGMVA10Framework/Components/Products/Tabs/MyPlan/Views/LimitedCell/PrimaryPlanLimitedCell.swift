//
//  PrimaryPlanLimitedCell.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 7/2/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class PrimaryPlanLimitedCell: UITableViewCell {
    @IBOutlet weak var planIconBGView: UIView!
    @IBOutlet weak var planIconImageView: VFGImageView!
    @IBOutlet weak var planTitleLabel: VFGLabel!
    @IBOutlet weak var remainingBalanceLabel: VFGLabel!
    @IBOutlet weak var planUsageBar: UIView!
    @IBOutlet weak var remainingRatioLabel: VFGLabel!
    @IBOutlet weak var addBalanceButton: VFGButton!
    @IBOutlet weak var customDetailsView: UIView!
    @IBOutlet weak var labelsStackView: UIStackView!
    @IBOutlet weak var remainingsStackView: UIStackView!
    var addDataButtonAction: (() -> Void)?

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
        planIconBGView.backgroundColor = .darkGrayBackground
        planIconBGView.layer.cornerRadius = 6
        planTitleLabel.textColor = .primaryTextColor
        remainingBalanceLabel.textColor = .redTextColor
        remainingRatioLabel.textColor = .primaryTextColor
        planUsageBar.layer.cornerRadius = 3
    }

    func configure(with viewModel: PrimaryPlanCellViewModel?) {
        planIconImageView?.image = VFGImage(named: viewModel?.planIcon ?? "")
        planTitleLabel?.text = viewModel?.planTitle
        remainingBalanceLabel?.text = viewModel?.remainingBalanceTxt
        let ratio = viewModel?.remainingBalanceRatio ?? 100
        remainingRatioLabel?.text = "(\(ratio)%)"
        remainingRatioLabel.isHidden = viewModel?.remainingBalanceRatio == nil
        let grayColorPercent = 100.0 - (ratio + 1.0)
        let percentage = [ratio, 1.0, grayColorPercent]
        let colors: [UIColor] = [
            .filledRedProgressBar ?? .red,
            .white,
            .unfilledGrayProgressBar ?? .gray
        ]
        planUsageBar.fillProgressBarColors(colors, withPercentage: percentage)
        addBalanceButton.setTitle(viewModel?.addBalanceButtonTitle, for: .normal)
        sizeToFitLabels()
        labelsStackView.axis = isAnyLabelTruncated() ? .vertical : labelsStackView.axis
        let isTruncated = isAnyLabelTruncated(remainingsLabelsOnly: true)
        remainingsStackView.axis = isTruncated ? .vertical : remainingsStackView.axis
        setupAccessibilityLabels()
    }

    func sizeToFitLabels() {
        planTitleLabel.sizeToFit()
        remainingBalanceLabel.sizeToFit()
        remainingRatioLabel.sizeToFit()
    }

    func isAnyLabelTruncated(remainingsLabelsOnly: Bool = false) -> Bool {
        let titleLabelWidth = planTitleLabel.frame.size.width
        let remainingBalanceLabelWidth = remainingBalanceLabel.frame.size.width
        let remainingRatioLabelWidth = remainingRatioLabel.frame.size.width
        let isTitleTruncated = planTitleLabel.isTruncated(numberOfLines: 1, width: titleLabelWidth)
        let isRemainingBalanceTruncated = remainingBalanceLabel.isTruncated(
            numberOfLines: 1,
            width: remainingBalanceLabelWidth
        )
        let isRemainingRatioTruncated = remainingRatioLabel.isTruncated(
            numberOfLines: 1,
            width: remainingRatioLabelWidth
        )
        return isTitleTruncated && !remainingsLabelsOnly || isRemainingBalanceTruncated || isRemainingRatioTruncated
    }

    @IBAction func addDataButtonPressed(_ sender: Any) {
        addDataButtonAction?()
    }

    private func setupAccessibilityLabels() {
        [self, planIconBGView, planIconImageView]
            .forEach { $0?.isAccessibilityElement = false }
        [planTitleLabel, remainingBalanceLabel, remainingRatioLabel, planUsageBar, addBalanceButton]
            .forEach { $0?.isAccessibilityElement = true }
        guard
            let planTitleLabel = planTitleLabel,
            let remainingBalanceLabel = remainingBalanceLabel,
            let remainingRatioLabel = remainingRatioLabel,
            let planUsageBar = planUsageBar,
            let addBalanceButton = addBalanceButton
        else { return }
        accessibilityElements = [
            planTitleLabel,
            remainingBalanceLabel,
            remainingRatioLabel,
            planUsageBar,
            addBalanceButton
        ]
    }
}

/// Primary plan cell view model.
public struct PrimaryPlanCellViewModel {
    /// Plan icon name in assets.
    public var planIcon: String
    /// Plan title.
    public var planTitle: String
    /// Remaining balance text.
    public var remainingBalanceTxt: String
    /// Remaining balance ratio.
    public var remainingBalanceRatio: Float?
    /// Add balance button title.
    public var addBalanceButtonTitle: String
    /// Boolean determines whether the cell has background or not.
    public var hasBackgroundColor: Bool

    public init(
        planIcon: String,
        planTitle: String,
        remainingBalanceTxt: String = "",
        remainingBalanceRatio: Float? = nil,
        addBalanceButtonTitle: String = "",
        hasBackgroundColor: Bool = false
    ) {
        self.planIcon = planIcon
        self.planTitle = planTitle
        self.remainingBalanceTxt = remainingBalanceTxt
        self.remainingBalanceRatio = remainingBalanceRatio
        self.addBalanceButtonTitle = addBalanceButtonTitle
        self.hasBackgroundColor = hasBackgroundColor
    }
}
