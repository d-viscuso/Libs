//
//  SmallNormalLogoBannerCell.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 25/12/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit

/// A cell which represents small normal logo card type under type one card.
public class SmallNormalLogoBannerCell: BaseLargeWidthBannerCell {
    var smallNormalLogoCard: LogoCard?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        smallNormalLogoCard = LogoCard()
        addContentView(smallNormalLogoCard ?? UIView())
    }

    /// A method used to configure cell with data model.
    /// - Parameter model: A model of type *HorizontalCardItem* which holds cell data.
    public override func configure(with model: HorizontalLargeWidthCardModel) {
        super.configure(with: model)
        smallNormalLogoCard?.configure(with: LogoCardModel(
            logo: model.logo))
    }
}
