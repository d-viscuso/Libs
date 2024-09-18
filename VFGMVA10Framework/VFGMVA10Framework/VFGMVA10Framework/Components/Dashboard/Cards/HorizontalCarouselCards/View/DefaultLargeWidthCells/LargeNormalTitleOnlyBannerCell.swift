//
//  LargeNormalTitleOnlyBannerCell.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 24/12/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit

/// A cell which represents large normal title only type under type one card.
public class LargeNormalTitleOnlyBannerCell: BaseLargeWidthBannerCell {
    var largeNormalTitleOnlyCard: TitleOnlyCard?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        largeNormalTitleOnlyCard = TitleOnlyCard()
        addContentView(largeNormalTitleOnlyCard ?? UIView())
    }

    /// A method used to configure cell with data model.
    /// - Parameter model: A model of type *HorizontalCardItem* which holds cell data.
    public override func configure(with model: HorizontalLargeWidthCardModel) {
        super.configure(with: model)
        largeNormalTitleOnlyCard?.numberOfTitleLines = 4
        largeNormalTitleOnlyCard?.configure(
            title: model.title,
            titleColor: model.titleColor
        )
    }
}
