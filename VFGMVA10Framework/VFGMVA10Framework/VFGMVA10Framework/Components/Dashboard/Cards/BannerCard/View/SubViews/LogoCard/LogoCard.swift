//
//  LogoCard.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 27/07/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// A view which holds a logo and a copy label.
public class LogoCard: UIView {
    @IBOutlet weak var logoImageView: VFGImageView!
    @IBOutlet weak var titleLabel: VFGLabel!

    public var numberOfTitleLines: Int = 4 {
        didSet {
            titleLabel.numberOfLines = numberOfTitleLines
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
            nibName: String(describing: LogoCard.self),
            in: bundle
        ) else { return }
        xibSetup(contentView: contentView)
    }

    /// A method used to configure view with data model.
    /// - Parameter model: A model of type *LogoCardModel* which holds view data.
    public func configure(with model: LogoCardModel) {
        logoImageView.image = VFGImage(named: model.logo)
        titleLabel.text = model.title
        if let titleColor = model.titleColor {
            titleLabel.textColor = UIColor(hexString: titleColor)
        }
    }
}
