//
//  VFGVerticalStepView+VoiceOver.swift
//  VFGMVA10Foundation
//
//  Created by Moataz Akram on 07/06/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

extension VFGVerticalStepView {
    func setupAccessibility() {
        tapButton.accessibilityTraits = .none
        switch action {
        case .complete:
            tapButton.accessibilityLabel = "\(titleText), step. Completed"
        case .skip:
            tapButton.accessibilityLabel = "\(titleText), step. Skipped"
        default:
            tapButton.accessibilityLabel = "\(titleText), step."
        }
    }
}
