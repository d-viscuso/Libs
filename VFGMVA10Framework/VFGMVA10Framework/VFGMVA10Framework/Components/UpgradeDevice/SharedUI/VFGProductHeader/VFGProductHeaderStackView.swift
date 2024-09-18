//
//  VFGProductHeaderStackView.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 6/10/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class VFGProductHeaderStackView: UIStackView {
    @IBOutlet weak var iconImageView: VFGImageView!
    @IBOutlet weak var nameLabel: VFGLabel!
    @IBOutlet weak var descriptionLabel: VFGLabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        nameLabel.text = ""
        descriptionLabel.text = ""
    }

    init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    private func commonInit() {
        guard let contentView = self.loadViewFromNib(nibName: className, in: .mva10Framework) else {
            return
        }

        xibSetup(contentView: contentView)
    }

    func setup(productHeader: VFGProductHeaderUIModel) {
        if let name = productHeader.name {
            nameLabel.text = name.text
            nameLabel.font = name.font
        }

        if let description = productHeader.description {
            descriptionLabel.text = description.text
            descriptionLabel.font = description.font
        }

        if let imageURL = productHeader.imageURL {
            iconImageView.image = VFGImage(named: imageURL)
        }
        setupAccessibilityControls()
        setupAccessibilityIdentifiers()
    }
}

extension VFGProductHeaderStackView {
    func setupAccessibilityControls() {
        nameLabel.accessibilityLabel = nameLabel.text ?? ""
        descriptionLabel.accessibilityLabel = descriptionLabel.text ?? ""
        iconImageView.accessibilityLabel = "icon for \(nameLabel.text ?? "" )"
    }

    func setupAccessibilityIdentifiers() {
        nameLabel.accessibilityIdentifier = "UDCostBreakdownHeaderNameID"
        descriptionLabel.accessibilityIdentifier = "UDCostBreakdownHeaderDescriptionID"
        iconImageView.accessibilityIdentifier = "UDCostBreakdownHeaderImageID"
    }
}

struct VFGProductHeaderUIModel {
    let imageURL: String?
    let name: (text: String, font: UIFont)?
    let description: (text: String, font: UIFont)?
}
