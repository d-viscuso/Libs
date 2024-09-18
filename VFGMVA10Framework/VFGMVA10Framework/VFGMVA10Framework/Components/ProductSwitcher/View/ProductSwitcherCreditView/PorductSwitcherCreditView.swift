//
//  PorductSwitcherCreditView.swift
//  VFGMVA10Framework
//
//  Created by Claudio Cavalli on 08/11/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class ProductSwitcherCreditView: UIView {
    let contentStack = UIStackView()
    let headerStackView = UIStackView()
    let iconImageView = VFGImageView()
    let titleLabel = VFGLabel()
    let bodyStackView = UIStackView()
    let descriptionLabel = VFGLabel()
    let progressView = UIView()
    let footerStackView = UIStackView()
    let statusLabel = VFGLabel()
    let stackSpacing = 6.0
    let progressViewMarginWidth = -40.0
    let progressViewMarginHeight = 6.0
    let iconImageViewSize = 25.0
    let contentStackMarginLeading = 16.0
    let contentStackMarginTrailing = -16.0
    let contentStackTop = 5.0
    let contentStackBottom = 12.0
    let contentStackLargeHeight = 10.0
    let statusLabelfontSize = 14.0
    let titleLabelSmallfontSize = 14.0
    let titleLabelLargefontSize = 16.0
    let descriptionLabelLargefontSize = 24.0
    let progressRatioDividend: Float = 100.0
    let progressRatioCompensation: Float = 1.0
    /// init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.style()
        self.layout()
    }
    /// required init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// setup
    private func setup() {
        addSubview(contentStack)
        contentStack.addArrangedSubview(headerStackView)
        contentStack.addArrangedSubview(bodyStackView)
        contentStack.addArrangedSubview(footerStackView)
        headerStackView.addArrangedSubview(iconImageView)
        headerStackView.addArrangedSubview(titleLabel)
        bodyStackView.addArrangedSubview(descriptionLabel)
        bodyStackView.addArrangedSubview(progressView)
        footerStackView.addArrangedSubview(statusLabel)
    }
    /// style
    private func style() {
        progressView.layer.masksToBounds = true
        progressView.layer.cornerRadius = 3
        progressView.backgroundColor = .VFGAluminiumProgressBar
        contentStack.axis = .vertical
        contentStack.alignment = .leading
        contentStack.distribution = .fill
        contentStack.spacing = stackSpacing
        headerStackView.alignment = .leading
        bodyStackView.axis = .vertical
        bodyStackView.alignment = .leading
        footerStackView.axis = .vertical
        footerStackView.alignment = .leading
        headerStackView.spacing = stackSpacing
        bodyStackView.spacing = stackSpacing
        footerStackView.spacing = stackSpacing
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.font = .vodafoneBold(titleLabelLargefontSize)
        descriptionLabel.font = .vodafoneBold(descriptionLabelLargefontSize)
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
        statusLabel.font = .vodafoneLite(statusLabelfontSize)
        statusLabel.textAlignment = .left
    }
    /// layout
    private func layout() {
        contentStack.fresh.makeConstraints { make in
            make.trailing.constrain(self.fresh.trailing.constant(contentStackMarginTrailing), relation: .equal)
            make.leading.constrain(self.fresh.leading.constant(contentStackMarginLeading), relation: .equal)
            make.top.constrain(self.fresh.top.constant(contentStackTop), relation: .equal)
            make.bottom.constrain(self.fresh.bottom.constant(contentStackBottom), relation: .equal)
        }
        headerStackView.fresh.makeConstraints { make in
            make.leading == contentStack.fresh.leading
            make.trailing == contentStack.fresh.trailing
        }
        iconImageView.fresh.makeConstraints { make in
            make.height == iconImageViewSize
            make.width == iconImageViewSize
        }
        progressView.fresh.makeConstraints { make in
            make.height == progressViewMarginHeight
            make.width.constrain(self.fresh.width.constant(progressViewMarginWidth), relation: .equal)
        }
    }
    /// setContentItem
    func setContentItem(
        _ contentItem: ProductSwitcherContentItem,
        for width: CGFloat
    ) {
        iconImageView.image = contentItem.icon
        titleLabel.text = contentItem.title
        descriptionLabel.text = contentItem.desc
        if let descAttributedString = contentItem.descAttributedString {
            descriptionLabel.attributedText = descAttributedString
        }
        statusLabel.text = contentItem.descStatus
        checkVisibility(contentItem: contentItem)
    }
    /// checkVisibility
    private func checkVisibility(contentItem: ProductSwitcherContentItem) {
        iconImageView.isHidden = contentItem.icon == nil
        titleLabel.isHidden = contentItem.title == nil
        descriptionLabel.isHidden = contentItem.desc == nil
        descriptionLabel.isHidden = contentItem.descAttributedString == nil
        descriptionLabel.adjustsFontSizeToFitWidth = true
        statusLabel.isHidden = contentItem.descStatus == nil
        progressView.isHidden = contentItem.progressRatio == nil
        setupDesc(
            desc: contentItem.desc,
            progressRatio: contentItem.progressRatio,
            descStatus: contentItem.descStatus,
            descAttributedString: contentItem.descAttributedString
        )
    }
    /// setupDesc layout
    private func setupDesc(
        desc: String?,
        progressRatio: Float?,
        descStatus: String?,
        descAttributedString: NSAttributedString?
    ) {
        if desc == nil, progressRatio == nil, descStatus == nil {
            bodyStackView.removeFromSuperview()
            footerStackView.removeFromSuperview()
        }
        if desc != nil &&
            progressRatio == nil &&
            descStatus == nil &&
            descAttributedString == nil {
            self.titleLabel.font = .vodafoneBold(titleLabelSmallfontSize)
            bodyStackView.removeFromSuperview()
            footerStackView.removeFromSuperview()
        }
        if descStatus == nil {
            progressView.removeFromSuperview()
            contentStack.distribution = .fill
            contentStack.spacing = contentStackLargeHeight
        }
        setupProgress(progressRatio: progressRatio)
    }
    /// setupProgress
    private func setupProgress(progressRatio: Float?) {
        guard let progressRatio = progressRatio else { return }
        let ratioPercentage = Float(round(progressRatio * progressRatioDividend))
        let grayColorPercent = progressRatioDividend - (ratioPercentage + progressRatioCompensation)
        let percentages = [ratioPercentage, progressRatioCompensation, grayColorPercent]
        let colors: [UIColor] = [.VFGRedProgressBar, .white, .VFGAluminiumProgressBar]
        DispatchQueue.main.async {
            self.progressView.fillProgressBarColors(colors, withPercentage: percentages)
        }
    }
}
