//
//  VFEverythingIsOKChecksViewController+Delegates.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Mahmoud Zaki on 11/28/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

extension VFEverythingIsOKChecksViewController: UITableViewDataSource, UITableViewDelegate {
    /// number of section from checks count
    public func numberOfSections(in tableView: UITableView) -> Int {
        return checks.count
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height
    }

    /// Setup header view  for checks sections
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: checkHeaderID) as? VFEverythingIsOKChecksHeaderCell else {
                return nil
        }
        let check = checks[section]
        header.topSeparator.isHidden = section != 0
        let eioStatusM = eioModel?.eioStatus ?? .inProgress
        DispatchQueue.main.async {
            if eioStatusM == .success {
                header.topSeparator.backgroundColor = UIColor.VFGGreyDividerFour
            } else {
                header.topSeparator.backgroundColor = UIColor.VFGVeryLightPink(alpha: 0.3)
            }
        }
        header.titleLabel.text = String(
            format: check.title?.localized(bundle: .mva10Framework) ?? "",
            eioModel?.model?.username ?? ""
        )
        guard let eioStatus = eioModel?.eioStatus else { return header }
        header.expandActionClosure = { [weak self, weak header] in
            guard let self = self,
                self.checks[section].subItems != nil,
                let header = header else { return }
            self.checks.forEach { $0.isClicked = false }
            // set isClicked to true and after calling headerTapped set it to false
            self.checks[section].isClicked = true
            self.headerTapped(for: section)
            self.checks[section].isClicked = false
            header.wasExpanded = check.wasExpanded
            header.willExpand = check.willExpand
            check.wasExpanded = check.willExpand
        }
        bindCell(header, check, section, eioStatus)
        header.accessibilityIdentifier = "checkItemLayout\(section)"
        header.indicatorImageView.alpha = 1
        setupVoiceOverAccessibility(for: header)
        return header
    }

    func bindCell(
        _ header: VFEverythingIsOKChecksHeaderCell,
        _ check: VFCheckItemViewModel,
        _ index: Int,
        _ eioStatus: EIOStatus
    ) {
        header.status = check.status
        header.oldStatus = check.oldStatus
        header.wasExpanded = check.wasExpanded
        header.willExpand = check.willExpand
        header.isFirst = firstEnter
        header.isClicked = checks[index].isClicked ?? false
        header.hasSubItems = checks[index].subItems != nil
        header.updateHeader(iconName: checks[index].icon, eioStatus: eioStatus)
    }

    /// View for footer per section
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        footerView.backgroundColor = .clear
        let separator = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        if eioModel?.eioStatus == .success {
            separator.backgroundColor = UIColor.VFGGreyDividerFour
        } else {
            separator.backgroundColor = UIColor.VFGVeryLightPink(alpha: 0.3)
        }
        footerView.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 0).isActive = true
        separator.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: 0).isActive = true
        separator.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 0).isActive = true
        separator.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: 0).isActive = true
        return footerView
    }

    /// number of rows in each section form checks model sub items count
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if firstEnter {
            return 0
        }
        let checkModel = checks[section]
        if !checkModel.willExpand {
            return 0
        }
        return checkModel.subItems?.count ?? 0
    }

    /// setup cells for each row
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let check = checks[indexPath.section]
        guard let subItems = check.subItems else {
            return UITableViewCell()
        }
        let subItem = subItems[indexPath.row]
        switch subItem.status {
        case EIOStatus.failed?:
            return constructFailedCell(indexPath: indexPath, subItem: subItem)
        default:
            return constructPassedCell(indexPath: indexPath, subItem: subItem)
        }
    }

    /// scroll view scrolling delegate method
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = max(0, scrollView.contentOffset.y)
    }

    func showHideDetailedFailure(_ displayedCell: VFEverythingIsOkCheckFailedCell, show: Bool) {
        displayedCell.failureDetailsView.isHidden = !show
        displayedCell.refreshButton.isHidden = !show
    }

    private func constructFailedCell(indexPath: IndexPath, subItem: EverythingIsOkSubItem) -> UITableViewCell {
        let cell = checksTableView.dequeueReusableCell(withIdentifier: checkFailedCellID, for: indexPath)
        guard let failCell = cell  as? VFEverythingIsOkCheckFailedCell else {
            return cell
        }
        failCell.accessibilityIdentifier = "subItem\(indexPath.row)"
        failCell.icon.accessibilityIdentifier = "EIOwarningIcon"
        let tintColor = UIColor.headerTint(with: eioModel?.eioStatus ?? .inProgress)
        failCell.titleLabel.text = subItem.title?.localized(bundle: Bundle.mva10Framework)
        failCell.titleLabel.textColor = tintColor
        failCell.titleLabel.font = UIFont.vodafoneBold(16)
        failCell.descriptionLabel.text = subItem.description?.localized(bundle: Bundle.mva10Framework)
        failCell.descriptionLabel.textColor = tintColor
        failCell.refreshButton.setTitle(subItem.actionTitle?.localized(bundle: Bundle.mva10Framework), for: .normal)
        failCell.icon.image = UIImage.VFGWarning.white

        guard let subItemId = subItem.subItemId else {
            return failCell
        }
        let action = actions?[subItemId]
        failCell.refreshActionClosure = action
        showHideDetailedFailure(failCell, show: true)
        setupVoiceOverAccessibility(for: failCell, with: .failed)
        return failCell
    }

    func constructPassedCell(indexPath: IndexPath, subItem: EverythingIsOkSubItem) -> UITableViewCell {
        let cell = checksTableView.dequeueReusableCell(withIdentifier: checkFailedCellID, for: indexPath)
        guard let okCell = cell as? VFEverythingIsOkCheckFailedCell else {
            return cell
        }
        okCell.titleLabel.text = subItem.title?.localized(bundle: Bundle.mva10Framework)
        okCell.accessibilityIdentifier = "subItem\(indexPath.row)"
        okCell.icon.accessibilityIdentifier = "EIOcheckIcon"
        okCell.titleLabel.textColor = UIColor.headerTint(with: eioModel?.eioStatus ?? .inProgress)
        okCell.titleLabel.font = UIFont.vodafoneRegular(16)
        var iconName = ""
        var status: EIOStatus = .inProgress
        if eioModel?.eioStatus == .success {
            iconName = "icTickSolved"
            status = .success
        } else {
            if subItem.status == EIOStatus.inProgress {
                iconName = "icSyncWhite"
                status = .inProgress
            } else {
                iconName = "icTickSolvedWhite"
                status = .success
            }
        }
        okCell.icon.image = UIImage(named: iconName, in: Bundle.mva10Framework, compatibleWith: nil)
        okCell.failureDetailsView.isHidden = true
        setupVoiceOverAccessibility(for: okCell, with: status)
        return okCell
    }

    func closeAllSections(animated: Bool = true) {
        checks.forEach { $0.willExpand = false }
        reloadAllSections(animated: animated)
    }
}
