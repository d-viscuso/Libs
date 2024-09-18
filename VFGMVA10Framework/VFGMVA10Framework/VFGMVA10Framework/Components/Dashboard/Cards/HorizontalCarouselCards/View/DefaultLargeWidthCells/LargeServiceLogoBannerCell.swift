//
//  LargeServiceLogoBannerCell.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 25/12/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit

/// A cell which represents large service logo type under type one card.
public class LargeServiceLogoBannerCell: BaseLargeWidthBannerCell {
    var largeServiceLogoCard: LogoCard?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        largeServiceLogoCard = LogoCard()
        bannerCard?.showDefaultBackground = true
        addContentView(largeServiceLogoCard ?? UIView())
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
        largeServiceLogoCard?.numberOfTitleLines = 4
        largeServiceLogoCard?.configure(with: LogoCardModel(
            logo: model.logo,
            title: model.title,
            titleColor: model.titleColor))
    }
}
