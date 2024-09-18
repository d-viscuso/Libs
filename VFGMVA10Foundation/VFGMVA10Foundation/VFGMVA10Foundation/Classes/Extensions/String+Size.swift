//
//  String+Size.swift
//  VFGMVA10Foundation
//
//  Created by Erdem ILDIZ on 26.07.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit

public extension String {
    /// Calculates and returns the height of the String object.
    /// - Parameters:
    ///    - width: Width of the current container.
    ///    - font: Font used for this string.
    /// - Returns: a *CGFloat* represents the height of the current string.
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )
        return ceil(boundingBox.height)
    }

    /// Calculates and returns the width of the String object.
    /// - Parameters:
    ///    - height: Height of the current container.
    ///    - font: Font used for this string.
    /// - Returns: a *CGFloat* represents the width of the current string.
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )
        return ceil(boundingBox.width)
    }
}
