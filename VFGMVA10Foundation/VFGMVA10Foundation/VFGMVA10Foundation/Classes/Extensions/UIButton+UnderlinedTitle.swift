//
//  UIButton+UnderlinedTitle.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 7/11/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

extension UIButton {
    /// Sets line under title text.
    /// - Parameters:
    ///    - title: Title of the button.
    ///    - font: Font of the button title.
    ///    - color: Color of the button title.
    ///    - state: State of the button.
    public func setUnderlinedTitle(title: String, font: UIFont, color: UIColor, state: UIControl.State) {
        let attrs: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.underlineStyle: 1
        ]

        let attributedString = NSMutableAttributedString(string: "")
        let buttonTitleStr = NSMutableAttributedString(string: title, attributes: attrs)
        attributedString.append(buttonTitleStr)
        setAttributedTitle(attributedString, for: state)
    }
}
