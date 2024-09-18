//
//  VFGNoAppointmentCollectionViewCell.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 14/02/2021.
//

import UIKit
import VFGMVA10Foundation
class VFGNoAppointmentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var subtitleLabel: VFGLabel!
    @IBOutlet weak var descLabel: VFGLabel!
    @IBOutlet weak var imageView: UIImageView!

    func setupCell(title: String, subtitle: String, desc: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        descLabel.text = desc

        titleLabel.isAccessibilityElement = true
        subtitleLabel.isAccessibilityElement = true
        descLabel.isAccessibilityElement = true
        imageView.isAccessibilityElement = true

        titleLabel.accessibilityLabel = titleLabel.text
        subtitleLabel.accessibilityLabel = subtitleLabel.text
        descLabel.accessibilityLabel = descLabel.text
        imageView.accessibilityLabel = "No Appointment"
    }
}
