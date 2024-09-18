//
//  UITableView+RegisterVFGCell.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 16/05/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit

extension UITableView {
    /// Register a table view cell by it's class name
    /// - parameters:
    ///    - cellType: Cell Type that conforms to NibLoadable and it's type is UITableViewCell.
    public func registerVFGCell<T: NibLoadable & UITableViewCell>(with cellType: T.Type) {
        register(cellType.nib, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
}
