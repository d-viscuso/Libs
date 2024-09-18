//
//  VFGRadioButton.swift
//  VFGMVA10Foundation
//
//  Created by Hussien Gamal Mohammed on 4/26/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
/// Basically a *UIButton* that consists of edge colored circle to show selection state,
/// If button is selected circle is filled with color,
/// if not it a white hallowed color
public class VFGRadioButton: VFGButton {
    let activeImage = VFGFoundationAsset.Image.definitionRadioButtonOn
    let inactiveImage = VFGFoundationAsset.Image.definitionRadioButtonOff
    /// Overridden to set button's image based on current selection state
    override public var isSelected: Bool {
        didSet {
            setImage(isSelected ? activeImage : inactiveImage, for: .normal)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        customUI()
    }

    @objc public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customUI()
    }
    /// *VFGRadioButton* default configuration
    func customUI() {
        setTitle("", for: .normal)
        buttonStyle = ButtonStyle.icon.rawValue
        isSelected = false
    }
}
