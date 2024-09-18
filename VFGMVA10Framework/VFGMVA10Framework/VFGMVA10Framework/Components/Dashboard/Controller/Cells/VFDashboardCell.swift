//
//  VFDashboardCell.swift
//  mva10
//
//  Created by Tomasz Czyżak on 21/12/2018.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import UIKit
import AVKit
import VFGMVA10Foundation
/// *VFDashboardViewController* collection view default cell
class VFDashboardCell: UICollectionViewCell {
    /// Dashboard cell content
    weak var viewComponentEntry: VFGComponentEntry? {
        didSet {
            guard let entry = viewComponentEntry else {
                return
            }
            setup(entry: entry)
        }
    }

    override func prepareForReuse() {
        removeShadow()
        super.prepareForReuse()
    }
    /// Shadow configuration for dashboard cell
    func addShadow() {
        // adding transparent border to cell content view to make shadow appear with rounded corners
        contentView.layer.cornerRadius = 6.0
        contentView.layer.borderWidth = 2.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true

        configureShadow(radius: 4.0)
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    /// Shadow removal from dashboard cell
    func removeShadow() {
        layer.shadowOpacity = 0.0
        layer.cornerRadius = 0
        layer.masksToBounds = false
        contentView.layer.masksToBounds = false
        contentView.layer.cornerRadius = 0
        contentView.layer.borderWidth = 0
    }

    private func setup(entry: VFGComponentEntry) {
        guard let cardView = entry.isLocked ? entry.lockedCardView : entry.cardView else {
            return
        }

        guard cardView.superview != contentView else {
            return
        }

        contentView.removeSubviews()
        contentView.embed(view: cardView)
    }
}
