//
//  VFGSetPrivacyPermissionsViewController+TableView.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 27/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

extension VFGSetPrivacyPermissionsViewController: UITableViewDelegate, UITableViewDataSource {
    /// Number of Sections
    public func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    /// Number of Rows per Section
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return model?.infoSection.count ?? 0
        case 1:
            return model?.permissionProfiles.count ?? 0
        case 2:
            return model?.contactPreferences.count ?? 0
        case 3:
            return model?.preferredContacts.contacts.count ?? 0
        default:
            return 0
        }
    }
    /// Cells Configuration per Section
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return setupInfoSectionCell(with: indexPath)
        case 1:
            return setupProfilePermissionCell(with: indexPath)
        case 2:
            return setupContactsPrefrencesCell(with: indexPath)
        case 3:
            return setupContactCell(with: indexPath)
        default:
            return UITableViewCell()
        }
    }

    private func setupInfoSectionCell(with indexPath: IndexPath) -> UITableViewCell {
        guard let cell = permissionsTableView
            .dequeueReusableCell(
                withIdentifier: String(describing: VFGPrivacyPermissionsInfoCell.self),
                for: indexPath) as? VFGPrivacyPermissionsInfoCell,
            let model = viewModel?.infoSection?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.titleSize = indexPath.row == 0 ? .large : .medium
        cell.setup(with: model, indexPath: indexPath, delegate: self)
        return cell
    }

    private func setupProfilePermissionCell(with indexPath: IndexPath) -> UITableViewCell {
        guard let cell = permissionsTableView
            .dequeueReusableCell(
                withIdentifier: String(describing: VFGProfilePrivacyPermissionCell.self),
                for: indexPath) as? VFGProfilePrivacyPermissionCell,
            let model = viewModel?.permissionProfiles?[indexPath.row] else {
            return UITableViewCell()
        }
        if self.model?.permissionProfiles.count ?? 0 == indexPath.row + 1 {
            cell.seperatorView.isHidden = true
        } else {
            cell.seperatorView.isHidden = false
        }
        cell.setup(with: model, indexPath: indexPath, delegate: self)
        return cell
    }

    private func setupContactsPrefrencesCell(with indexPath: IndexPath) -> UITableViewCell {
        guard let cell = permissionsTableView
            .dequeueReusableCell(
                withIdentifier: String(describing: VFGPrivacyPermissionsInfoCell.self),
                for: indexPath) as? VFGPrivacyPermissionsInfoCell,
            let model = viewModel?.contactPreferences?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.setup(with: model, indexPath: indexPath, delegate: self)
        return cell
    }

    private func setupContactCell(with indexPath: IndexPath) -> UITableViewCell {
        guard let cell = permissionsTableView
            .dequeueReusableCell(
                withIdentifier: String(describing: VFGContactPrivacyPermissionCell.self),
                for: indexPath) as? VFGContactPrivacyPermissionCell,
            let model = viewModel?.contacts?[indexPath.row] else {
            return UITableViewCell()
        }
        if self.viewModel?.contacts?.count ?? 0 == indexPath.row + 1 {
            cell.seperatorView.isHidden = true
        } else {
            cell.seperatorView.isHidden = false
        }
        cell.setup(with: model, indexPath: indexPath, delegate: self)
        return cell
    }
    /// Setup height for each header in section
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 3:
            return UITableView.automaticDimension
        default:
            return .leastNormalMagnitude
        }
    }
    /// Setup footer for each section
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    /// Setup custom header for each section 
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 3:
            guard let sectionHeader = permissionsTableView
            .dequeueReusableHeaderFooterView(withIdentifier: String(describing: VFGContactsSectionHeaderView.self))
                as? VFGContactsSectionHeaderView,
            let title = viewModel?.preferredContactsSectionTitle else {
                return nil
            }
            sectionHeader.setup(title: title)
            return sectionHeader
        default:
            return nil
        }
    }
}
