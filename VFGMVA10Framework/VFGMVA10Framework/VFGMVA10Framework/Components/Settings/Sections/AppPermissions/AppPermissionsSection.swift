//
//  AppPermissionsSection.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 07/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// Construct app permissions section
public class AppPermissionsSection: BaseSection {
    /// App permissions section header default height
    private let defaultHeaderHeight: CGFloat = 0

    public override func heightForHeader() -> CGFloat {
        customHeaderHeight ?? defaultHeaderHeight
    }

    public override func numberOfRows() -> Int {
        guard let viewModel = (cellBuilders.first as? AppPermissionTableViewCellBuilder)?.viewModel else {
            return cellBuilders.count
        }

        return viewModel.numberOfEnabledPermissions()
    }

    public override func cellAt(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        cellBuilders[0].cellAt(indexPath: indexPath, tableView: tableView)
    }

    public override func cellHeightFor(indexPath: IndexPath) -> CGFloat {
        cellBuilders[0].cellHeight()
    }

    public override func willDisplay(cell: UITableViewCell, indexPath: IndexPath, tableView: UITableView) {
        cellBuilders[0].willDisplay(cell: cell, indexPath: indexPath, tableView: tableView)
    }

    public override func didSelectRowAt(indexPath: IndexPath, tableView: UITableView) {}
    public override func didDeselectRowAt(indexPath: IndexPath, tableView: UITableView) {}
}
