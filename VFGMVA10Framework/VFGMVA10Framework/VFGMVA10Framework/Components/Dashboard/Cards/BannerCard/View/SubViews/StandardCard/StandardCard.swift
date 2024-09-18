//
//  StandardCard.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 27/07/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// A view which holds a title and a copy labels.
public class StandardCard: UIView {
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var subTitleLabel: VFGLabel!

    /// Configure number of lines for title.
    public var numberOfTitleLines: Int = 2 {
        didSet {
            titleLabel.numberOfLines = numberOfTitleLines
        }
    }
    /// Configure number of lines for subtitles.
    public var numberOfSubtitleLines: Int = 4 {
        didSet {
            subTitleLabel.numberOfLines = numberOfSubtitleLines
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
            nibName: String(describing: StandardCard.self),
            in: bundle
        ) else { return }
        xibSetup(contentView: contentView)
    }

    /// A method used to configure view with data model.
    /// - Parameter model: A model of type *StandardCardModel* which holds view data.
    public func configure(with model: StandardCardModel) {
        titleLabel.text = model.title
        subTitleLabel.text = model.subtitle
        if let titleColor = model.titleColor {
            titleLabel.textColor = UIColor(hexString: titleColor)
        }
        if let subtitleColor = model.subtitleColor {
            subTitleLabel.textColor = UIColor(hexString: subtitleColor)
        }
    }
}
