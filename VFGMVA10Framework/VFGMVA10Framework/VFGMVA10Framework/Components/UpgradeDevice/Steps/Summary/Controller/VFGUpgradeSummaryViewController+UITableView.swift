//
//  VFGUpgradeSummaryViewController+UITableView.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 6/8/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

extension VFGUpgradeSummaryViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: Header
    func numberOfSections(in tableView: UITableView) -> Int {
        return Mirror(reflecting: sections).children.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section != sections.totalCost, let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(
                describing: VFGUpgradeSummarySectionHeaderView.self)) as? VFGUpgradeSummarySectionHeaderView else {
            return nil
        }

        switch section {
        case sections.device:
            headerView.setup(
                title: "device_upgrade_summary_step_my_upgrade_selection".localized(bundle: .mva10Framework),
                subtitle: "device_upgrade_summary_step_my_new_device".localized(bundle: .mva10Framework),
                buttonTitle: "device_upgrade_summary_step_edit".localized(bundle: .mva10Framework),
                buttonAction: onUpgradeSummeryEditDidPress
            )
        case sections.plan:
            headerView.setup(
                subtitle: "device_upgrade_summary_step_my_new_plan".localized(bundle: .mva10Framework)
            )
        case sections.payment:
            headerView.setup(
                title: "device_upgrade_summary_step_payment_and_delivery".localized(bundle: .mva10Framework)
            )
        default:
            break
        }

        return headerView
    }

    // MARK: Footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case sections.device, sections.payment:
            return nil
        case sections.totalCost:
            guard let footerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: String(describing: VFGConfirmFooterView.self
                )) as? VFGConfirmFooterView else {
                return nil
            }
            footerView.confirmView.delegate = self
            return footerView
        default:
            return tableView.dequeueReusableHeaderFooterView(
                withIdentifier: String(describing: "VFGUpgradeSummarySectionFooterView"))
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case sections.totalCost:
            return 160
        case sections.device, sections.plan:
            return 35
        default:
            return 0
        }
    }

    // MARK: Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == sections.payment ? (isAddressRowHidden ? 2 : 3) : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case sections.device:
            return deviceCell(for: tableView, indexPath: indexPath)
        case sections.plan:
            return planCell(for: tableView, indexPath: indexPath)
        case sections.payment:
            return paymentCell(for: tableView, indexPath: indexPath)
        case sections.totalCost:
            return totalCostCell(for: tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
}

extension VFGUpgradeSummaryViewController {
    private func deviceCell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: VFGUpgradeDeviceCell.self),
                for: indexPath) as? VFGUpgradeDeviceCell,
            let deviceDetails = upgradeModel?.deviceDetails else {
            return UITableViewCell()
        }
        cell.setup(deviceDetails: deviceDetails)
        return cell
    }

    private func planCell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: UpgradePlanCell.self),
                for: indexPath) as? UpgradePlanCell,
            let plan = upgradeModel?.planModel else {
            return UITableViewCell()
        }

        let model = VFGPlanCellUIModel(
            id: plan.id,
            name: plan.name,
            imageURL: plan.imageURL,
            price: plan.price,
            subscriptions: plan.subscriptions,
            isRecommended: false,
            isExpanded: isPlanExpanded,
            isChoosable: false
        )
        cell.setup(model: model, indexPath: indexPath, delegate: self)
        return cell
    }

    private func paymentCell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: VFGDeviceCapacitySelectionCell.self),
                for: indexPath) as? VFGDeviceCapacitySelectionCell else {
            return UITableViewCell()
        }

        switch indexPath.row {
        case paymentAndDeliveryRows.payment:
            if paymentDataSource == nil {
                paymentDataSource = VFGPaymentDataSource()
                paymentDataSource?.fetchPaymentCards { [weak self] in
                    cell.dataSource = self?.paymentDataSource
                }
            } else {
                cell.dataSource = paymentDataSource
            }
            cell.capacitySelectionView.size = .small
        case paymentAndDeliveryRows.delivery:
            if collectionAndDeliveryDataSource == nil,
                let collectionAndDelivery = upgradeModel?.collectionAndDelivery {
                collectionAndDeliveryDataSource = VFGCollectionAndDeliveryDataSource(collectionAndDelivery)
            }
            cell.dataSource = collectionAndDeliveryDataSource
            cell.capacitySelectionView.size = .medium
            cell.dataSource = collectionAndDeliveryDataSource
            cell.capacitySelectionView.delegate = self
        case paymentAndDeliveryRows.address:
            if addressDataSource == nil {
                addressDataSource = VFGAddressDataSource()
            }
            cell.dataSource = addressDataSource
            cell.capacitySelectionView.size = .small
        default:
            break
        }

        return cell
    }

    private func totalCostCell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: VFGUpgradeCostCell.self),
                for: indexPath) as? VFGUpgradeCostCell else {
            return UITableViewCell()
        }
        cell.setup(
            device: upgradeModel?.deviceDetails,
            plan: upgradeModel?.planModel,
            self
        )
        return cell
    }
}
