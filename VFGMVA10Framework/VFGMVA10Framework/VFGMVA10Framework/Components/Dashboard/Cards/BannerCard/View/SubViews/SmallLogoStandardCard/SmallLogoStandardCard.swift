//
//  SmallLogoStandardCard.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 04/01/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

public class SmallLogoStandardCard: UIView {
    @IBOutlet weak var logoImageView: VFGImageView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var subtitleLabel: VFGLabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func xibSetup() {
        let bundle = Bundle.mva10Framework
        guard let contentView = loadViewFromNib(
            nibName: String(describing: SmallLogoStandardCard.self),
            in: bundle
        ) else { return }
        xibSetup(contentView: contentView)
    }

    func configure(with model: LogoStandardModel) {
        logoImageView.image = VFGImage(named: model.logo)
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        if let titleColor = model.titleColor {
            titleLabel.textColor = UIColor(hexString: titleColor)
        }
        if let subTitleColor = model.subtitleColor {
            subtitleLabel.textColor = UIColor(hexString: subTitleColor)
        }
    }
}
