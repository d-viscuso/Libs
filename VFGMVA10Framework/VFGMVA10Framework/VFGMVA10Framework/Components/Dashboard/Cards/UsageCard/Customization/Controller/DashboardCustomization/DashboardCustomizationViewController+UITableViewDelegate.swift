//
//  DashboardCustomizationViewController+UITableViewDelegate.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 20/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension DashboardCustomizationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let label = VFGLabel(
            frame: .init(
                x: 5,
                y: section == sections.visible ? 16 : 37,
                width: tableView.frame.width - 10,
                height: section == sections.visible ? 40 : 20
            ))
        label.text = self.tableView(tableView, titleForHeaderInSection: section)
        label.font = .vodafoneBold(16.6)
        label.numberOfLines = 3
        label.textColor = .VFGPrimaryText
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        headerView.backgroundColor = .VFGLightGreyBackground
        headerView.addSubview(label)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == sections.visible ? 70 : 80
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // set cell re-order image
        guard let cell = cell as? DashboardCustomizationTableViewCell else { return }
        cell.reorderControlImageName = indexPath.section == sections.visible
            ? "icRearrange" : ""
        cell.reorderControlImageView?.contentMode = .scaleAspectFill

        let isVisibleRow = indexPath.section == sections.visible
        let isLast = indexPath.row == (isVisibleRow ? visibleUsageCards.count : hiddenUsageCards.count) - 1

        // adjust cell separator
        cell.separatorInset = UIEdgeInsets(
            top: 0,
            left: isLast ? 0 : 16.4,
            bottom: 0,
            right: isLast ? .greatestFiniteMagnitude : 16.4
        )
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        false
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        defer { tableView.reloadData() }

        if sourceIndexPath.section == sections.visible,
            destinationIndexPath.section == sections.hidden,
            visibleUsageCards[sourceIndexPath.row].isDefault {
            return
        }

        var movedItem = usageCardsConfiguration.remove(at: sourceIndexPath.row)

        if destinationIndexPath.section == sections.visible {
            movedItem.isHidden = false
            usageCardsConfiguration.insert(movedItem, at: destinationIndexPath.row)
        } else if destinationIndexPath.section == sections.hidden {
            movedItem.isHidden = true
            usageCardsConfiguration.append(movedItem)
        }

        resetIndex()
        confirmButton.isEnabled = isVisibleUsageCardsChanged()
    }
    /// Update usage cards indicies after rearrange happens
    func resetIndex() {
        for index in usageCardsConfiguration.indices {
            usageCardsConfiguration[index].index = (index + initialIndex)
        }
    }
}
