//
//  TitleOnlyCard.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 28/07/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// A view which holds a title label.
public class TitleOnlyCard: UIView {
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
            nibName: String(describing: TitleOnlyCard.self),
            in: bundle
        ) else { return }
        xibSetup(contentView: contentView)
    }

    /// A method used to configure view with data.
    /// - Parameters:
    ///   - title: An instance of type *String* which represents view title.
    ///   - titleColor: An instance of type *String* which represents view title color.
    public func configure(
        title: String?,
        titleColor: String? = nil
    ) {
        titleLabel.text = title
        if let titleColor = titleColor {
            titleLabel.textColor = UIColor(hexString: titleColor)
        }
    }
}
