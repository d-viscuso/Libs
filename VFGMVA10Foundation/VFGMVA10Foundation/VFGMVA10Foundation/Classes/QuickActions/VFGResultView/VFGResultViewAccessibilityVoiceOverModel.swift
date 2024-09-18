//
//  VFGResultViewAccessibilityVoiceOverModel.swift
//  VFGMVA10Foundation
//
//  Created by Ashraf Dewan on 11/04/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

public struct VFGResultViewAccessibilityVoiceOverModel {
    public var imageViewLabel: String?
    public var animationViewLabel: String?

    /// To set Accessibility labels for imageView and animationView
    public init(
        imageViewLabel: String? = nil,
        animationViewLabel: String? = nil
    ) {
        self.imageViewLabel = imageViewLabel
        self.animationViewLabel = animationViewLabel
    }
}
