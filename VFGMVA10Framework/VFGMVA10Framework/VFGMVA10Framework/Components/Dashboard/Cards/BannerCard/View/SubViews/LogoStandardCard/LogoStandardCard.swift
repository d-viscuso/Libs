//
//  LogoStandardCard.swift
//  VFGMVA10Framework
//
//  Created by Tuncel, Pelin, Vodafone on 10/21/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

public class LogoStandardCard: UIView {
    @IBOutlet weak var logoImageView: VFGImageView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var subtitleLabel: VFGLabel!

    public var numberOfTitleLines: Int = 2 {
        didSet {
            titleLabel.numberOfLines = numberOfTitleLines
        }
    }
    public var numberOfSubtitleLines: Int = 2 {
        didSet {
            subtitleLabel.numberOfLines = numberOfSubtitleLines
        }
    }

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
            nibName: String(describing: LogoStandardCard.self),
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
