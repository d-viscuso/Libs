//
//  VFGResultViewAccessibilityModel.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 3/10/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

public struct VFGResultViewAccessibilityModel {
    public var imageViewID: String?
    public var titleID: String?
    public var descriptionID: String?
    public var primaryButtonID: String?
    public var secondaryButtonID: String?

    /// To set Accessibility identifiers for imageView, title, description, primary button and secondary button
    public init(
        imageViewID: String? = nil,
        titleID: String? = nil,
        descriptionID: String? = nil,
        primaryButtonID: String? = nil,
        secondaryButtonID: String? = nil
    ) {
        self.imageViewID = imageViewID
        self.titleID = titleID
        self.descriptionID = descriptionID
        self.primaryButtonID = primaryButtonID
        self.secondaryButtonID = secondaryButtonID
    }
}
