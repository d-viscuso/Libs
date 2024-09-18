//
//  UITableViewCell+Extensions.swift
//  VFGMVA10Foundation
//
//  Created by Erdem ILDIZ on 26.07.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit

public extension UITableViewCell {
    /// Creates a generic identifier for the UITableViewCell depending on it's name/title.
    static var reuseIdentifier: String {
        return String(describing: self)
    }

    /// Returns potential UIImageView for the reorder control
    ///
    /// Use this if you want to provide a custom image on the darg accessory functionality.
    var reorderControlImageView: UIImageView? {
        let reorderControl = self.subviews.first { view -> Bool in
            view.classForCoder.description() == "UITableViewCellReorderControl"
        }
        return reorderControl?.subviews.first { view -> Bool in
            view is UIImageView
        } as? UIImageView
    }
}
