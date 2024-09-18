//
//  NSMutableAttributedString+Attribute.swift
//  VFGMVA10Foundation
//
//  Created by Erdem ILDIZ on 26.07.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit

public extension NSMutableAttributedString {
    /// Adds font attribute.
    /// - Parameters:
    ///   - font: The font that would be added.
    func addAttribute(font: UIFont) {
        addAttribute(
            NSAttributedString.Key.font,
            value: font,
            range: NSRange(location: 0, length: length)
        )
    }

    /// Adds font attribute to range of the given text.
    /// - Parameters:
    ///   - font: The font that would be added.
    ///   - text: Text that the range would be extract from.
    func addAttribute(font: UIFont, to text: String) {
        guard !text.isBlank else { return }
        addAttribute(
            NSAttributedString.Key.font,
            value: font,
            range: (string as NSString).range(of: text)
        )
    }

    /// Adds text color attribute.
    /// - Parameters:
    ///   - textColor: The color that would be applied to text.
    func addAttribute(textColor: UIColor) {
        addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: textColor,
            range: NSRange(location: 0, length: length)
        )
    }
}
