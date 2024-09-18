//
//  UpgradePlanDetailView.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 5/22/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

public class UpgradePlanDetailView: UIView {
    @IBOutlet weak var detailImageView: VFGImageView!
    @IBOutlet weak var detailLabel: VFGLabel!

    /// Method that is called to setup upgrade plan details view.
    /// - Parameters:
    ///     - detailImageURL: New *UIImage* that you want to show.
    ///     - detailText: needed text to be shown.
    ///     -  bundle: the location of images.
    public func setup(detailImageURL: String, detailText: String, bundle: Bundle) {
        detailImageView.image = UIImage(named: detailImageURL, in: bundle)
        detailLabel.text = detailText
        setAccessibilityForVoiceOver()
    }
}

extension UpgradePlanDetailView {
    /// set accessibility for voice over
    func setAccessibilityForVoiceOver() {
        detailLabel.accessibilityLabel = detailLabel.text
    }
}
