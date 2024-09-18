//
//  String+Width.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 12/19/19.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

extension String {
    /// Turn the  string or sub-string into bold.
    /// - Parameters:
    ///    - subText: the sub string to boldify
    ///    - size: font size
    public func boldify(subText: String? = nil, size: CGFloat) -> NSAttributedString {
        let font = UIFont.vodafoneBold(size)
        let attributedOriginalText = NSMutableAttributedString(string: self)
        let boldRange = attributedOriginalText.mutableString.range(of: subText ?? self)
        attributedOriginalText.addAttribute(.font, value: font, range: boldRange)
        return attributedOriginalText
    }

    /// Calculates and returns the width of the String object using provided font.
    /// - Parameters:
    ///    - font: Font used to calculates string width.
    /// - Returns: A *CGFloat* expresses the width of the String object.
    public func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
