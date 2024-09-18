//
//  UIApplication+OpenUrl.swift
//  VFGMVA10Group
//
//  Created by Tomasz Czyżak on 24/06/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

extension UIApplication {
    class func openUrl(_ link: String, application: UIApplication = UIApplication.shared) {
        guard let url = URL(string: link) else {
            VFGErrorLog("Failed to create url with:\(link)")
            return
        }
        application.open(url)
    }
}
