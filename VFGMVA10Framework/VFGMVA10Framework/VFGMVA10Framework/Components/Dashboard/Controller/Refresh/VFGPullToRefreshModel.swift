//
//  VFGPullToRefreshModel.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 27/05/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

public struct VFGPullToRefreshModel {
    var isEnabled: Bool
    var tintColor: UIColor
    var backgroundColor: UIColor

    public  init(
        isEnabled: Bool = true,
        tintColor: UIColor = .VFGLightGreyBackground,
        backgroundColor: UIColor = .clear
    ) {
        self.isEnabled = isEnabled
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
    }
}
