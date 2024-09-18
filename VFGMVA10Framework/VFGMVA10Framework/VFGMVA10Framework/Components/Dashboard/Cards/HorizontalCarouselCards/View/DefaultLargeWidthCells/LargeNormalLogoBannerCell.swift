//
//  LargeNormalLogoBannerCell.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 25/12/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit

/// A cell which represents large normal logo type under type one card.
public class LargeNormalLogoBannerCell: BaseLargeWidthBannerCell {
    var lagreNormalLogoCard: LogoCard?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        lagreNormalLogoCard = LogoCard()
        addContentView(lagreNormalLogoCard ?? UIView())
    }

    /// A method used to configure cell with data model.
    /// - Parameter model: A model of type *HorizontalCardItem* which holds cell data.
    public override func configure(with model: HorizontalLargeWidthCardModel) {
        super.configure(with: model)
        lagreNormalLogoCard?.numberOfTitleLines = 4
        lagreNormalLogoCard?.configure(with: LogoCardModel(
            logo: model.logo,
            title: model.title,
            titleColor: model.titleColor))
    }
}
