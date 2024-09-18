//
//  TertiaryTileCustomizationViewController+UITableViewDataSource.swift
//  VFGMVA10Framework
//
//  Created by Yasser Soliman on 04/11/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

extension TertiaryTileCustomizationViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let isLast = viewModel?.isLastTile(at: indexPath) ?? false
        let isFirst = viewModel?.isFirstTile(at: indexPath) ?? false
        if isFirst && isLast {
            return 70
        }
        return 65
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == sections.visible
            ? "edit_tertiary_tiles_visible_section_title".localized(bundle: .mva10Framework)
            : "edit_tertiary_tiles_hidden_section_title".localized(bundle: .mva10Framework)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == sections.visible ?
            viewModel?.numberOfVisibleTiles() ?? 0 :
            viewModel?.numberOfHiddenTiles() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "DashboardCustomizationTableViewCell",
                for: indexPath) as? DashboardCustomizationTableViewCell else {
            return UITableViewCell()
        }

        let isVisibleRow = indexPath.section == sections.visible
        let tile = isVisibleRow ?
            viewModel?.getVisibleTile(at: indexPath.row) :
            viewModel?.getHiddenTile(at: indexPath.row)

        cell.configure(
            title: tile?.title.localized(),
            usageIconName: tile?.icon,
            actionIconName: isVisibleRow ? "icRemove" : "icAddRed",
            isFirst: viewModel?.isFirstTile(at: indexPath) ?? false,
            isLast: viewModel?.isLastTile(at: indexPath) ?? false
        )

        cell.onAddOrRemoveButtonPress = { [weak self] in
            guard let self = self, let viewModel = self.viewModel else { return }
            viewModel.onAddOrRemoveTile(at: indexPath)
            self.tableView.reloadData()
            self.confirmButton.isEnabled = viewModel.isVisibleTilesNotEqualPreviousOne()
        }
        if confirmButton.isEnabled {
            accessibilityCustomActions = [confirmButtonVoiceOverAction()]
        } else {
            accessibilityCustomActions = []
        }

        return cell
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        viewModel?.numberOfVisibleTiles() == 2 && indexPath.section == sections.visible
    }
}
