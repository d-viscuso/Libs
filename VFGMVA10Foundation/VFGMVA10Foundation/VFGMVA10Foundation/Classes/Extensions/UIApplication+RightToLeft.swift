//
//  UIApplication+RightToLeft.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 22/11/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    /// Finds if current view elements semantic is rightToLeft.
    public static var isRightToLeft: Bool {
        UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ||
        UIView.appearance().semanticContentAttribute == .forceRightToLeft ||
        UIButton.appearance().semanticContentAttribute == .forceRightToLeft
    }
}
