//
//  VFGSwitch.swift
//  VFGMVA10Foundation
//
//  Created by Esraa Eldaltony on 7/4/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

/// A custom UISwitch Allows customization of backgroundColor and tintColor
public class VFGSwitch: UISwitch {
    override init(frame: CGRect) {
        super.init(frame: frame)
        customUI()
    }

    @objc public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customUI()
    }

    public convenience init(_ switchOnTintColor: UIColor) {
        self.init()
        customUI(switchOnTintColor)
    }

    func customUI(_ switchOnTintColor: UIColor? = nil) {
        frame.size = intrinsicContentSize
        let onTintColorVar = UIColor(red: 4 / 255, green: 123 / 255, blue: 147 / 255, alpha: 1)
        onTintColor = switchOnTintColor ?? onTintColorVar
        backgroundColor = .VFGMidGreyToggleSwitch
        tintColor = .VFGMidGreyToggleSwitch
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
        isOn = true
        isEnabled = true
        isUserInteractionEnabled = true
    }

    public override var accessibilityValue: String? {
        get { "" }
        set {
            self.accessibilityValue = newValue
        }
    }
}
