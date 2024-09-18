//
//  LogoStandardMediumBannerCell.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 01/01/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import UIKit

/// A cell which represents logo with standard medium squared type under type two card.
public class LogoStandardMediumBannerCell: BaseMediumSquaredBannerCell {
    var logoStandardCard: LogoStandardCard?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        logoStandardCard = LogoStandardCard()
        addContentView(logoStandardCard ?? UIView())
    }

    /// A method used to configure cell with data model.
    /// - Parameter model: A model of type *HorizontalMediumSquaredCardModel* which holds cell data.
    public override func configure(with model: HorizontalMediumSquaredCardModel) {
        super.configure(with: model)
        logoStandardCard?.numberOfTitleLines = 2
        logoStandardCard?.numberOfSubtitleLines = 3
        logoStandardCard?.configure(with: LogoStandardModel(
            logo: model.logo,
            title: model.title,
            subtitle: model.subtitle,
            titleColor: model.titleColor,
            subtitleColor: model.subtitleColor
        ))
    }
}
