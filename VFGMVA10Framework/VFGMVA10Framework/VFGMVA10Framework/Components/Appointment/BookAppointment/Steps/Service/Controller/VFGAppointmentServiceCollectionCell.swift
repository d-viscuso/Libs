//
//  VFGAppointmentServiceCollectionCell.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/10/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class VFGAppointmentServiceCollectionCell: UICollectionViewCell {
    @IBOutlet weak var arrowImageView: VFGImageView!
    @IBOutlet weak var iconImageView: VFGImageView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var durationLabel: VFGLabel!
    @IBOutlet weak var detailsLabel: VFGLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureShadow()
    }

    func setup(with service: VFGAppointmentServiceModel.Service) {
        titleLabel.text = service.title
        detailsLabel.text = service.details
        durationLabel.text = String(format: durationLabel.text ?? "", service.duration)
        iconImageView.image = UIImage(named: service.iconImageName, in: .mva10Framework)

        titleLabel.accessibilityLabel = titleLabel.text
        detailsLabel.accessibilityLabel = detailsLabel.text
        durationLabel.accessibilityLabel = durationLabel.text
        iconImageView.accessibilityLabel = "icon for \(titleLabel.text ?? "" )"
        arrowImageView.accessibilityLabel = "arrow for \(titleLabel.text ?? "" )"
    }

    func setupAccessibilityIds(with index: Int) {
        titleLabel.accessibilityIdentifier = "APserviceTitleLabel\(index)"
        detailsLabel.accessibilityIdentifier = "APserviceDetailsLabel\(index)"
        durationLabel.accessibilityIdentifier = "APserviceDurationLabel\(index)"
        iconImageView.accessibilityIdentifier = "APserviceIconImage\(index)"
        arrowImageView.accessibilityIdentifier = "APserviceChevron\(index)"
    }
}
