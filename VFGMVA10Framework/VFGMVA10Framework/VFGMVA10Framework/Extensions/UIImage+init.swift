//
//  UIImage+init.swift
//  VFGMVA10Framework
//
//  Created by Sandra Morcos on 10/27/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
public extension UIImage {
    /// Method used returned *UIImage* using it's name in assets.
    /// - Parameters:
    ///    - named: Image name in assets.
    /// - Returns: A Fully initialized *UIImage* if the name was found in assets and *nil* if it wasn't found.
    class func image(named: String) -> UIImage? {
        guard let image = UIImage(named: named, in: Bundle.main, compatibleWith: nil) else {
            return UIImage(named: named, in: Bundle.mva10Framework, compatibleWith: nil)
        }
        return image
    }
}
