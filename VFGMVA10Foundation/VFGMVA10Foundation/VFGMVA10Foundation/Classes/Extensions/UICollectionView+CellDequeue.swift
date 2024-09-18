//
//  UICollectionView+CellDequeue.swift
//  VFGMVA10Foundation
//
//  Created by Erdem ILDIZ on 26.10.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

extension UICollectionView {
    /// Dequeues (by it's class name) and returns a reusable collection-view cell object.
    /// - parameters:
    ///    - cell: Cell Type.
    ///    - indexPath: IndexPath of the cell.
    public func cellDequeue<T: UICollectionViewCell>(with cell: T.Type, indexPath: IndexPath) -> T? {
        self.dequeueReusableCell(
            withReuseIdentifier: T.reuseIdentifier,
            for: indexPath
        ) as? T
    }
}
