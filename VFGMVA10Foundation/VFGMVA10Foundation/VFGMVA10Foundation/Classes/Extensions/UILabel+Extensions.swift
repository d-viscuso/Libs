//
//  UILabel+Extensions.swift
//  VFGMVA10Foundation
//
//  Created by Abdullah Soylemez on 30.07.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit

public extension UILabel {
    /// Animates current label with grow and shrink animations.
    /// - Parameters:
    ///    - duration: Duration of the animation, it is 0.2 second by default.
    ///    - scale: Scale at which the label grows, it is 1.2x by default.
    func growAndShrink(withDuration duration: TimeInterval = 0.2, scale: CGFloat = 1.2) {
        UILabel.animate(withDuration: duration) {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        } completion: { _ in
            UILabel.animate(withDuration: duration) {
                self.transform = .identity
            }
        }
    }

    /// Finds if the label text would be truncated.
    /// - Parameters:
    ///    - numberOfLines: Number of the label lines.
    ///    - width: Width of the label.
    /// - Returns: A *Bool* value tells if the label text is truncated or not.
    func isTruncated(numberOfLines: Int, width: CGFloat? = nil) -> Bool {
        let uiFont = font as UIFont
        let dict = [NSAttributedString.Key.font: uiFont]
        let size = text?.size(withAttributes: dict)
        let mWidth = size?.width ?? 0
        let cgFloatNumLines = CGFloat(numberOfLines)
        return (mWidth / cgFloatNumLines) > width ?? self.bounds.width
    }
}
