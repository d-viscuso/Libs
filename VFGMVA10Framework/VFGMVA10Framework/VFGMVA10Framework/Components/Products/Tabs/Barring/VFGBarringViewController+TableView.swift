//
//  VFGBarringViewController+TableView.swift
//  VFGMVA10Framework
//
//  Created by Trachani, Vasiliki, Vodafone on 18/5/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
import UIKit

// MARK: UITableViewDataSource
extension VFGBarringViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        barringViewModel?.contentState == .loading ? 1 : barringViewModel?.numberOfBarrings() ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let shimmerCell = barringTableView.dequeueReusableCell(
            withIdentifier: VFGBarringShimmerTableViewCell.reuseIdentifier,
            for: indexPath) as? VFGBarringShimmerTableViewCell else { return UITableViewCell() }
        let contentState = barringViewModel?.contentState
        switch contentState {
        case .loading:
            shimmerCell.startShimmer()
            shimmerCell.accessibilityIdentifier = "BAshimmerCell\(indexPath.row)"
            return shimmerCell
        case .populated:
            shimmerCell.stopShimmer()
            let isLastCell = (indexPath.row + 1) == tableView.numberOfRows(inSection: indexPath.section)
            return permissionCell(for: indexPath, isLastCell: isLastCell )
        default:
            break
        }
        return UITableViewCell()
    }

    func permissionCell(for indexPath: IndexPath, isLastCell: Bool) -> UITableViewCell {
        guard let cell = barringTableView.dequeueReusableCell(
            withIdentifier: VFGBarringTableViewCell.reuseIdentifier,
            for: indexPath) as? VFGBarringTableViewCell,
                let permissionModel = barringViewModel?.barringDetails?[indexPath.row] else {
                    return UITableViewCell()
                }
        cell.setup(
            with: permissionModel,
            indexPath: indexPath,
            delegate: self,
            isLastCell: isLastCell)
        cell.accessibilityIdentifier = "BABarringCell\(indexPath.item)"
        return cell
    }
}
