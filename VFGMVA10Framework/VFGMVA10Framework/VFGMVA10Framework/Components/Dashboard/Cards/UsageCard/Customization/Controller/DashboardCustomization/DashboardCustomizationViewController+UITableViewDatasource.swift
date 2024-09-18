//
//  DashboardCustomizationViewController+UITableViewDatasource.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 19/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

extension DashboardCustomizationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == sections.visible
            ? "edit_usage_cards_visible_section_title".localized(bundle: .mva10Framework)
            : "edit_usage_cards_hidden_section_title".localized(bundle: .mva10Framework)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == sections.visible ? visibleUsageCards.count : hiddenUsageCards.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "DashboardCustomizationTableViewCell",
                for: indexPath) as? DashboardCustomizationTableViewCell else {
            return UITableViewCell()
        }

        let isVisibleRow = indexPath.section == sections.visible
        let usageCards = isVisibleRow ? visibleUsageCards[indexPath.row] : hiddenUsageCards[indexPath.row]

        let isDefault = usageCards.isDefault
        let usageType = UsageType.init(rawValue: usageCards.usageType)

        cell.configure(
            title: usageType?.title.localized(),
            usageIconName: usageType?.imageName,
            actionIconName: isDefault ? "icDimmedRemove" : isVisibleRow ? "icRemove" : "icAddRed",
            isFirst: indexPath.row == 0,
            isLast: indexPath.row == (isVisibleRow ? visibleUsageCards.count : hiddenUsageCards.count) - 1
        )

        guard !isDefault else {
            return cell
        }

        cell.onAddOrRemoveButtonPress = { [weak self] in
            self?.addOrRemoveButtonDidPress(at: indexPath)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        indexPath.section == sections.visible && visibleUsageCards.count > 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let isVisibleRow = indexPath.section == sections.visible
        let isLast = indexPath.row == (isVisibleRow ? visibleUsageCards.count : hiddenUsageCards.count) - 1
        let isFirst = indexPath.row == 0
        if isFirst && isLast {
            return 70
        }
        return 65
    }
}
