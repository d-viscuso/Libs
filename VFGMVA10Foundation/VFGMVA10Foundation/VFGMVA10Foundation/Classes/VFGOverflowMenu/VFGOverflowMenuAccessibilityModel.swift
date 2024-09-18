//
//  VFGOverflowMenuAccessibilityModel.swift
//  VFGMVA10Foundation
//
//  Created by Fafoutis, Athinodoros, Vodafone Greece on 01/06/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// A struct that represents the accessibility values for overflow menu cell.
public struct VFGOverflowMenuAccessibilityModel {
    public let leadingImage: String
    public let primaryText: String
    public let secondaryText: String

    /// Overflow menu accessibility model initializer.
    /// - Parameters:
    ///   - leadingImage: An object of type *String* that represents accessibility value for leading image.
    ///   - primaryText: An object of type *String* that represents accessibility value for primary text.
    ///   - secondaryText: An object of type *String* that represents accessibility value for secondary text.
    public init(
        leadingImage: String = "",
        primaryText: String = "",
        secondaryText: String = ""
    ) {
        self.leadingImage = leadingImage
        self.primaryText = primaryText
        self.secondaryText = secondaryText
    }
}
