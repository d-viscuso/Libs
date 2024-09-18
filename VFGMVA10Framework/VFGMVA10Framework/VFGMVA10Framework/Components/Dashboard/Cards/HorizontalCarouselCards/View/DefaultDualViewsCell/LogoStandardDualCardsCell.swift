//
//  LogoStandardDualCardsCell.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 03/01/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import UIKit

/// A cell which represents large standard dual cards type under type three card.
public class LogoStandardDualCardsCell: BaseDualCardsBannerCell {
    var topLogoStandardCard: SmallLogoStandardCard?
    var bottomLogoStandardCard: SmallLogoStandardCard?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTopView()
        setupBottomView()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTopView()
        setupBottomView()
    }

    private func setupTopView() {
        topLogoStandardCard = SmallLogoStandardCard()
        addTopContentView(topLogoStandardCard ?? UIView())
    }

    private func setupBottomView() {
        bottomLogoStandardCard = SmallLogoStandardCard()
        addBottomContentView(bottomLogoStandardCard ?? UIView())
    }

    /// A method used to configure top card with data model.
    /// - Parameter model: A model of type *HorizontalDualCardModel* which holds top card data.
    public override func configureTopCard(with model: HorizontalDualCardModel) {
        super.configureTopCard(with: model)
        topLogoStandardCard?.configure(with: LogoStandardModel(
            logo: model.logo,
            title: model.title,
            subtitle: model.subtitle,
            titleColor: model.titleColor,
            subtitleColor: model.subtitleColor
        ))
    }

    /// A method used to configure bottom card with data model.
    /// - Parameter model: A model of type *HorizontalDualCardModel* which holds bottom card data.
    public override func configureBottomCard(with model: HorizontalDualCardModel) {
        super.configureBottomCard(with: model)
        bottomLogoStandardCard?.configure(with: LogoStandardModel(
            logo: model.logo,
            title: model.title,
            subtitle: model.subtitle,
            titleColor: model.titleColor,
            subtitleColor: model.subtitleColor
        ))
    }
}
