//
//  UITableView+CellDequeue.swift
//  VFGMVA10Foundation
//
//  Created by Erdem ILDIZ on 26.10.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

extension UITableView {
    /// Dequeues (by it's class name) and returns a reusable table-view cell object.
    /// - parameters:
    ///    - cell: Cell Type.
    ///    - indexPath: IndexPath of the cell.
    public func cellDequeue<T: UITableViewCell>(with cell: T.Type, indexPath: IndexPath) -> T? {
        self.dequeueReusableCell(
            withIdentifier: T.reuseIdentifier,
            for: indexPath
        ) as? T
    }
}
