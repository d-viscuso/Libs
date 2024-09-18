//
//  LOTAnimationView+DarkMode.swift
//  VFGMVA10Framework
//
//  Created by Hussien Gamal Mohammed on 4/7/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import Lottie

extension String {
    func darkMode() -> String {
        let darkModeFileNameSuffix = "_dark"
        return self + darkModeFileNameSuffix
    }
}
