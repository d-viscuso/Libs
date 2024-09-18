//
//  LargeServiceStandardBannerCell.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 25/12/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit

/// A cell which represents large service standard type under type one card.
public class LargeServiceStandardBannerCell: BaseLargeWidthBannerCell {
    var largeServiceStandardCard: StandardCard?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        largeServiceStandardCard = StandardCard()
        bannerCard?.showDefaultBackground = true
        addContentView(largeServiceStandardCard ?? UIView())
    }

    /// A method used to configure cell with data model.
    /// - Parameter model: A model of type *HorizontalCardItem* which holds cell data.
    public override func configure(with model: HorizontalLargeWidthCardModel) {
        super.configure(with: model)
        bannerCard?.configure(with: BannerCardModel(
            bgImage: model.bgImage,
            serviceIcon: model.serviceIcon,
            points: model.points,
            link: model.link,
            showGradientOverlay: model.showGradientOverlay,
            gradientDirection: model.gradientDirection))
        largeServiceStandardCard?.numberOfTitleLines = 2
        largeServiceStandardCard?.numberOfSubtitleLines = 4
        largeServiceStandardCard?.configure(with: StandardCardModel(
            title: model.title,
            subtitle: model.subtitle,
            titleColor: model.titleColor,
            subtitleColor: model.subtitleColor))
    }
}
