//
//  VFGPointsBadgeView.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed AbdElnabi on 17/01/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import UIKit

/// A view which represents points badge that holds a point icon and number.
public class VFGPointsBadgeView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var pointsImageView: VFGImageView!
    @IBOutlet weak var pointsLabel: VFGLabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setupBorderWidth()
    }

    private func xibSetup() {
        let bundle = Bundle.foundation
        guard let pointsBadgeView = loadViewFromNib(
            nibName: className,
            in: bundle
        ) else { return }
        xibSetup(contentView: pointsBadgeView)
    }

    private func setupBorderWidth() {
        contentView.cornerRadius = frame.size.height / 2
    }

    /// A method used to configure points badge with *VFGPointsBadgeModel*.
    /// - Parameter model: An instance which represents points badge model.
    public func configure(with model: VFGPointsBadgeModel) {
        pointsImageView?.image = VFGImage(named: model.pointsIcon)
        pointsLabel.text = model.points
        if let pointsColor = model.pointsColor {
            pointsLabel.textColor = UIColor(hexString: pointsColor)
        }
    }
}
