//
//  SuscriptionCell.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 5/22/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

public class SubscriptionCell: UICollectionViewCell {
    @IBOutlet weak var subscriptionImageView: VFGImageView!

    /// Method that is called to setup subscription cell.
    /// - Parameters:
    ///     - imageUrlString: New *UIImage* that you want to show.
    public func setup(imageUrlString: String) {
        subscriptionImageView.image = UIImage(named: imageUrlString, in: .mva10Framework)
        setAccessibilityForVoiceOver()
    }
}

extension SubscriptionCell {
    /// set accessibility for voice over
    func setAccessibilityForVoiceOver() {
        subscriptionImageView.accessibilityLabel = "subscription image"
    }
}
