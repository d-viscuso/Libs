//
//  UICollectionView+RegisterVFGCell.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 16/05/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit

extension UICollectionView {
    /// Register a collection view cell by it's class name
    /// - parameters:
    ///    - cellType: Cell Type that conforms to NibLoadable and it's type is UICollectionViewCell.
    public func registerVFGCell<T: NibLoadable & UICollectionViewCell>(with cellType: T.Type) {
        register(cellType.nib, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
}
