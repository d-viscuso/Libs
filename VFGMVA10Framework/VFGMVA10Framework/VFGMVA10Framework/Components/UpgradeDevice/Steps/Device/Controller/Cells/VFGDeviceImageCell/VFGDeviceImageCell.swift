//
//  VFGDeviceImageCell.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 23/05/2021.
//

import UIKit
import VFGMVA10Foundation

class VFGDeviceImageCell: UITableViewCell {
    @IBOutlet weak var deviceImageView: VFGImageView!

    func updateImage(image: String) {
        deviceImageView.image = UIImage(named: image, in: .mva10Framework)
        deviceImageView.accessibilityIdentifier = "DImageCellID"
    }

    override var isAccessibilityElement: Bool {
        get { true }
        set { }
    }

    override var accessibilityLabel: String? {
        get { "Image of a Device" }
        set { }
    }
}
