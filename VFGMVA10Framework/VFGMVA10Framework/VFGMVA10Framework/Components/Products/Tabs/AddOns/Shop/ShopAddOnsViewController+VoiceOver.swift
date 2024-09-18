//
//  ShopAddOnsViewController+VoiceOver.swift
//  VFGMVA10Framework
//
//  Created by Adel Aref on 12/05/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

extension ShopAddOnsViewController {
    func setupAccessibilityLabels() {
        titleLabel.accessibilityLabel = titleLabel.text ?? ""
        subTitleLabel.accessibilityLabel = subTitleLabel.text ?? ""
    }
}
