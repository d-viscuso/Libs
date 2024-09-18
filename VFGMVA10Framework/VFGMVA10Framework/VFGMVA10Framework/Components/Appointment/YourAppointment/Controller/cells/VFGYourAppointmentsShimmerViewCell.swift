//
//  VFGYourAppointmentsShimmerViewCell.swift
//  Airship
//
//  Created by Moustafa Hegazy on 03/02/2021.
//

import UIKit
import VFGMVA10Foundation

class VFGYourAppointmentsShimmerViewCell: UICollectionViewCell {
    @IBOutlet var shimmerViews: [VFGShimmerView]!

    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
        accessibilityIdentifier = "YAshimmerCell"
    }

    func startShimmer() {
        shimmerViews.forEach { shimmeredView in
            shimmeredView.startAnimation()
        }
    }

    func stopShimmer() {
        removeFromSuperview()
    }

    func addShadow() {
        contentView.layer.cornerRadius = 4
        contentView.addingShadow(size: CGSize(width: 0, height: 1), radius: 4, opacity: 0.16)
        contentView.layer.masksToBounds = true
    }
}
