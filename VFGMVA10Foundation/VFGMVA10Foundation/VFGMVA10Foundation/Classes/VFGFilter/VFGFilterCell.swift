//
//  VFGFilterCell.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed Sultan on 4/23/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
/// A cell that used to show populated filter item
public class VFGFilterCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: VFGLabel!

    // A color for unSelected item
    var filterUnselectedBackgroundColor: UIColor? = .VFGFilterUnselectedBg
    // A color for unSelected item's border
    var filterUnselectedBorderColor: UIColor? = .clear

    /// A Boolean to show if item is selected or not
    public override var isSelected: Bool {
        didSet {
            containerView.backgroundColor = isSelected ? UIColor.VFGFilterSelectedBg : filterUnselectedBackgroundColor
            nameLabel.textColor = isSelected ? UIColor.VFGFilterSelectedText : UIColor.VFGFilterUnselectedText
            containerView.borderColor = isSelected ? UIColor.clear : filterUnselectedBorderColor
            containerView.borderWidth = isSelected ? 0 : 1
        }
    }

    /// A type for filter item
    public var categoryType: String = "" {
        didSet {
            self.nameLabel.text = categoryType
            self.setupVoiceOverAccessibility()
            self.contentView.setNeedsLayout()
        }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = self.containerView.frame.height / 2
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        containerView.backgroundColor = filterUnselectedBackgroundColor
        nameLabel.textColor = UIColor.VFGFilterUnselectedText
        containerView.borderColor = UIColor.clear
        containerView.borderWidth = 0
    }

    func setupVoiceOverAccessibility() {
        nameLabel.accessibilityLabel = nameLabel.text ?? ""
    }
}
