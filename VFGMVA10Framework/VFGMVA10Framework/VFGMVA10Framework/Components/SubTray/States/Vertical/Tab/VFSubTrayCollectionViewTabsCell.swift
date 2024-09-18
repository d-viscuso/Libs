//
//  VFSubTrayCollectionViewTabsCell.swift
//  VFGMVA10Framework
//
//  Created by Hamsa Hassan on 11/23/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation
/// Vertical sub tray tabs collection view cell
public class VFSubTrayCollectionViewTabsCell: UICollectionViewCell {
    @IBOutlet weak var tabTitle: VFGLabel!
    @IBOutlet weak var tabUnderline: UIView!

    var tabAccessibilityCustomAction: TabAccessibilityCustomAction? {
        didSet {
            guard let tabAction = tabAccessibilityCustomAction else { return }
            self.accessibilityCustomActions = [tabAction]
        }
    }
    /// *tabTitle* text
    /// - Parameters:
    ///    - title: Text for *tabTitle*
    func setupCell(with title: String) {
        tabTitle.text = title.localized(bundle: Bundle.mva10Framework)
        setupVoiceOverAccessibility()
    }
    /// Selected tab configuration
    func isSelected() {
        tabTitle.font = .vodafoneBold(17)
        tabTitle.textColor = .VFGPrimaryText
        tabUnderline.backgroundColor = .VFGTabsUnderline
        tabUnderline.accessibilityValue = "selected"
    }
    /// Unselected tab configuration
    func unSelected() {
        tabTitle.font = .vodafoneRegular(17)
        tabTitle.textColor = .VFGSecondaryText
        tabUnderline.backgroundColor = .clear
        tabUnderline.accessibilityValue = "unSelected"
    }
}
