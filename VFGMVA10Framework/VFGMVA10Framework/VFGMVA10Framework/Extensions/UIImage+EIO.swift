//
//  UIImage+EIO.swift
//  VFGMVA10Group
//
//  Created by Tomasz Czyżak on 24/07/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension UIImage {
    private enum ImageName {
        static let red: String = "logoRed"
        static let white: String = "white"
    }

    class func background(with status: EIOStatus) -> UIImage? {
        if status == .success {
            return UIImage.VFGBackground.grey
        }
        return UIImage.VFGBackground.red
    }

    class func logo(with status: EIOStatus) -> UIImage? {
        if status == .success {
            return VFGImage(named: ImageName.red)
        }
        return VFGImage(named: ImageName.white)
    }
}
