//
//  UICollectionView+fullyVisibleCellsIndexPaths.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 25/10/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

public extension UICollectionView {
    /// Returns array of IndexPaths of the fully visible cells.
    /// - Returns: A *[IndexPath]* of the fully visible cells.
    func fullyVisibleCellsIndexPaths() -> [IndexPath] {
        var indexPaths: [IndexPath] = []

        var visibleCells = visibleCells
        visibleCells = visibleCells.filter { cell -> Bool in
            let cellRect = convert(cell.frame, to: superview)
            return frame.contains(cellRect)
        }

        visibleCells.forEach {
            if let indexPath = indexPath(for: $0) {
                indexPaths.append(indexPath)
            }
        }

        return indexPaths
    }
}
