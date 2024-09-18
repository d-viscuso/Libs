//
//  VFDiscoverHeader.swift
//  VFGMVA10
//
//  Created by Sandra Morcos on 3/8/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// Dashboard collection view discover section header
class VFDiscoverHeader: UICollectionReusableView {
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var seeAllButton: VFGButton!

    /// Dashboard see all action
    var seeAllAction: (() -> Void)?
    var isSeeAllShow = false {
        didSet {
            if isSeeAllShow {
                seeAllButton.isHidden = false
            } else {
                seeAllButton.isHidden = true
            }
        }
    }

    func setupTitleLabel(with text: String?, and font: UIFont) {
        titleLabel.text = text
        titleLabel.font = font

        if let title = text?.split(separator: " ").first?.lowercased() {
            let title = title == "other" ? "otherApps" : title
            titleLabel.accessibilityIdentifier = "DB\(title)Title"
        }
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityLabel = text
    }

    func setupSeeAllButton(title: String, color: UIColor) {
        seeAllButton.setTitle(title, for: .normal)
        seeAllButton.tintColor = color
    }

    @IBAction func seeAllButtonDidPressed(sender: UIButton) {
        seeAllAction?()
    }
}
