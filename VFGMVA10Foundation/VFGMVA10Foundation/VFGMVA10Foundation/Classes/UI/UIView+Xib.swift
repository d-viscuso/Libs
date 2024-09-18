//
//  UIView+Xib.swift
//  VFGMVA10Foundation
//
//  Created by Tomasz Czyżak on 14/07/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

extension UIView {
    /**
    Load the view from a nib file

    - Parameter bundle: The bundle where the class is located
    - Parameter nibName: The name of the nib file, this is the class name by default

    - Note: When using the default nibName value, the nib file name **must** be the same as the class name.
    */
    public class func loadXib<T: UIView>(bundle: Bundle = Bundle.main, nibName: String = String("\(T.self)")) -> T? {
        return bundle.loadNibNamed(nibName, owner: self, options: nil)?.first as? T
    }
}
