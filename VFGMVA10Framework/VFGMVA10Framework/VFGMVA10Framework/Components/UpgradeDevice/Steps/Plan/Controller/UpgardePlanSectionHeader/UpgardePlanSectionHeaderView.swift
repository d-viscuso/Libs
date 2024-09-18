//
//  UpgardePlanSectionHeaderView.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 5/22/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

public class UpgradePlanSectionHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var sectionTitleLabel: VFGLabel!

    /// Method that is called to setup subscription cell.
    /// - Parameters:
    ///     - sectionTitle: The title text.
    public func setup(sectionTitle: String?) {
        sectionTitleLabel.text = sectionTitle
        setAccessibilityForVoiceOver()
    }
}

extension UpgradePlanSectionHeaderView {
    /// set accessibility for voice over
    func setAccessibilityForVoiceOver() {
        sectionTitleLabel.accessibilityLabel = sectionTitleLabel.text
    }
}
