//
//  UIApplication+UIWindow.swift
//  VFGMVA10Framework
//
//  Created by Mayar Soliman, Vodafone on 31/10/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import Foundation

extension UIApplication {
    var keyWindow: UIWindow? {
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }

    var statusBarFrameValue: CGRect? {
        if #available(iOS 13.0, *) {
            return keyWindow?.windowScene?.statusBarManager?.statusBarFrame
        } else {
            return UIApplication.shared.statusBarFrame
        }
    }
}
