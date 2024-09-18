//
//  VFGCategoriesViewModel.swift
//  VFGMVA10Framework
//
//  Created by Ayman Ata on 27/09/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

/// **VFGCategoriesViewModel** class is the viewModel of VFGCategoriesView.
/// This class is mandatory to make VFGCategoriesView works well.
public class VFGCategoriesViewModel {
    private let cellHeight: CGFloat = 88
    private let rightLeftMargin: CGFloat = 16
    private let sectionTopBottomMargin: CGFloat = 4
    let spaceBetweenCells: CGFloat = 8

    var model: VFGCategoriesModel
    var categories: [VFGCategoryModel] {
        model.categories ?? []
    }

    /// Creates a new instance of **VFGCategoriesViewModel** that holds logic for VFGCategoriesView.
    /// - Parameter model: A *VFGCategoriesModel* model of VFGCategoriesView.
    public required init(_ model: VFGCategoriesModel) {
        self.model = model
    }

    /// Width of the collection view cell.
    var cellWidth: CGFloat {
        var rowType: VFGCategoriesRowType = .twoItemsRow
        switch categories.count {
        case 2:
            rowType = .twoItemsRow
        case 3:
            rowType = .threeItemsRow
        case 4, 5:
            rowType = .fourItemsRow
        case 6, 7:
            rowType = (model.presentInOneLine ?? false) ? .fourItemsRow : .threeItemsRow
        case 8...:
            rowType = .fourItemsRow
        default:
            rowType = .twoItemsRow
        }

        let cellsPerRow = rowType.rawValue
        let totalSpace = (rightLeftMargin * 2) + (spaceBetweenCells * CGFloat(cellsPerRow - 1))
        let width: CGFloat = (UIScreen.main.bounds.width - totalSpace) / CGFloat(cellsPerRow)
        return width
    }

    /// Number of cells in VFGCategoriesView.
    var numberOfItems: Int {
        switch categories.count {
        case let count where count <= 4:
            return count
        case 5:
            return 4
        case 6, 7:
            return (model.presentInOneLine ?? false) ? 4 : 6
        case 8...:
            return (model.presentInOneLine ?? false) ? 4 : 8
        default:
            return 0
        }
    }

    /// Height of the VFGCategoriesView dashboard card.
    var cardViewHeight: CGFloat {
        var numberOfRows: CGFloat = 1
        switch categories.count {
        case 2...5:
            numberOfRows = 1
        case 6...:
            numberOfRows = (model.presentInOneLine ?? false) ? 1 : 2
        default:
            numberOfRows = 1
        }

        let viewHeight: CGFloat = (cellHeight * numberOfRows) +
        (spaceBetweenCells * (numberOfRows - 1) + sectionTopBottomMargin * 2)
        return numberOfItems > 1 ? viewHeight : 0
    }

    /// Checks if a collection view cell at the given index is a see all cell.
    /// - Parameter index: Indexpath of the current collection view cell.
    /// - Returns: A *Bool* value that indicates if the cell at the given index is a see all cell.
    func isSeeAllCell(at index: IndexPath) -> Bool {
        return index.item == numberOfItems - 1 &&
        numberOfItems < categories.count
    }

    /// Insets of the collection view section.
    var sectionInsets: UIEdgeInsets {
        UIEdgeInsets(
            top: sectionTopBottomMargin,
            left: rightLeftMargin,
            bottom: sectionTopBottomMargin,
            right: rightLeftMargin)
    }

    /// Size of the collection view cell in VFGCategoriesView.
    var cellSize: CGSize {
        CGSize(width: cellWidth, height: cellHeight)
    }

    /// *VFGCategoriesRowType* is an enum for different row types in the collection.
    private enum VFGCategoriesRowType: Int {
        case twoItemsRow = 2
        case threeItemsRow = 3
        case fourItemsRow = 4
    }
}
