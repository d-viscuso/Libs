//
//  VFGOverflowMenuItem.swift
//  VFGMVA10Foundation
//
//  Created by Fafoutis, Athinodoros, Vodafone Greece on 25/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// A struct that represents a row in overflow menu which can have a primary text, an optional secondary text and an optional leading image. The VFGOverflowMenuItem determines this behavior.
public struct VFGOverflowMenuItem: Equatable {
    public let primaryText: String
    public let secondaryText: String?
    let leadingImage: UIImage?
    let leadingImageDesc: String?

    /// Overflow menu item initializer.
    /// - Parameters:
    ///   - primaryText: An object of type *String* that represents the primary text.
    ///   - secondaryText: An object of type *String* that represents secondary text.
    ///   - leadingImage: An object of type *UIImage*.
    public init(
        primaryText: String,
        secondaryText: String? = nil,
        leadingImage: UIImage? = nil,
        leadingImageDesc: String? = nil
    ) {
        self.primaryText = primaryText
        self.secondaryText = secondaryText
        self.leadingImage = leadingImage
        self.leadingImageDesc = leadingImageDesc
    }

    /// Checks for equality.
    public static func == (lhs: VFGOverflowMenuItem, rhs: VFGOverflowMenuItem) -> Bool {
        return lhs.primaryText == rhs.primaryText &&
            lhs.secondaryText == rhs.secondaryText &&
            lhs.leadingImage == rhs.leadingImage &&
            lhs.leadingImageDesc == rhs.leadingImageDesc
    }
}
