//
//  SmallNormalStandardBannerCell.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 25/12/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit

/// A cell which represents small normal standard card type under type one card.
public class SmallNormalStandardBannerCell: BaseLargeWidthBannerCell {
    var smallNormalStandardCard: StandardCard?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        smallNormalStandardCard = StandardCard()
        addContentView(smallNormalStandardCard ?? UIView())
    }

    /// A method used to configure cell with data model.
    /// - Parameter model: A model of type *HorizontalCardItem* which holds cell data.
    public override func configure(with model: HorizontalLargeWidthCardModel) {
        super.configure(with: model)
        smallNormalStandardCard?.numberOfTitleLines = 3
        smallNormalStandardCard?.configure(with: StandardCardModel(
            title: model.title,
            titleColor: model.titleColor))
    }
}
