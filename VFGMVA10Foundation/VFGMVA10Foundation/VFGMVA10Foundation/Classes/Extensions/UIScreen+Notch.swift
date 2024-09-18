//
//  UIScreen+Notch.swift
//  VFGCommonUI
//
//  Created by Tomasz Czyżak on 27/03/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

extension UIScreen {
    /// Indicates if the device screen has a notch or not.
    @objc public static var screenHasNotch: Bool {
        // notch devices has safeArea bottom inset greater than 0 in both orientations
        let window: UIWindow? = UIApplication.shared.keyWindow ?? UIApplication.shared.windows.first
        return window?.safeAreaInsets.bottom ?? 0 > 0
    }
}
