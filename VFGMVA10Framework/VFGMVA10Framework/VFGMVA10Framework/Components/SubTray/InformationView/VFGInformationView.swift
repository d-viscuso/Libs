//
//  VFGInformationView.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 1/25/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// Information view for *VFGBaseSubtrayView*
public class VFGInformationView: UIView {
    @IBOutlet var titleLabel: VFGLabel!
    /// *titleLabel* text
    /// - Parameters:
    ///    - title: Text for *titleLabel*
    public func configure(title: String) {
        titleLabel.text = title
    }
}
