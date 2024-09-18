//
//  UIImage+init.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed Sultan on 6/7/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import UIKit
/// UIImage init failable without compatible parameters
extension UIImage {
    /// Creates new UIImage instance depending on provided image name and bundle.
    /// - Parameters:
    ///    - name: Name of the image.
    ///    - bundle: Bundle that contains the image asset.
    public convenience init?(named name: String?, in bundle: Bundle?) {
        if let name = name {
            self.init(named: name, in: bundle, compatibleWith: nil)
        } else {
            return nil
        }
    }

    convenience init? (
        color: UIColor,
        size: CGSize = CGSize(width: 1, height: 1)
    ) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
