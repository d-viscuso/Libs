//
//  LargeNormalStandardBannerCell.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 24/12/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit

/// A cell which represents large normal standard type under type one card.
public class LargeNormalStandardBannerCell: BaseLargeWidthBannerCell {
    var largeNormalStandardCard: StandardCard?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        largeNormalStandardCard = StandardCard()
        addContentView(largeNormalStandardCard ?? UIView())
    }

    /// A method used to configure cell with data model.
    /// - Parameter model: A model of type *HorizontalCardItem* which holds cell data.
    public override func configure(with model: HorizontalLargeWidthCardModel) {
        super.configure(with: model)
        largeNormalStandardCard?.numberOfTitleLines = 2
        largeNormalStandardCard?.numberOfSubtitleLines = 4
        largeNormalStandardCard?.configure(with: StandardCardModel(
            title: model.title,
            subtitle: model.subtitle,
            titleColor: model.titleColor,
            subtitleColor: model.subtitleColor))
    }
}
