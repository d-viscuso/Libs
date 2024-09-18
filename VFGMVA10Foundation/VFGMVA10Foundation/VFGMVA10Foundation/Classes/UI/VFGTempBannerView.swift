//
//  VFGTempBannerView.swift
//  VFGMVA10Foundation
//
//  Created by Atta Ahmed on 12/17/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
/// A UIView is displayed at the top of UIViewController with message and icon.
public class VFGTopBannerView: UIView {
    @IBOutlet weak var messageLabel: VFGLabel!
    @IBOutlet public weak var iconImageView: VFGImageView!
    /// *VFGTopBannerView* UI configuration
    /// - Parameters:
    ///    - message: *messageLabel* text value
    ///    - imageName: *iconImageView* image name
    public func configure(message: String, imageName: String ) {
        messageLabel.text = message
        iconImageView.image = UIImage(named: imageName)
    }
}
