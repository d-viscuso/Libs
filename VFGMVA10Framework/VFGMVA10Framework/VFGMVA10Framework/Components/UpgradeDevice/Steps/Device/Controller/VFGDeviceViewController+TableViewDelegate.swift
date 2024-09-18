//
//  VFGDeviceViewController+TableViewDelegate.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 24/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

extension VFGDeviceViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionsDatasource.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sectionsDatasource[section].numberOfItems
    }

    private func prepareSpecificationCell(_ cell: UITableViewCell) {
        if let specificationCell = cell as? VFGDeviceSpecificationCell {
            specificationCell.dataSource = viewModel
            specificationCell.showFullSpecsDidPress = { [weak self] in
                guard let self = self else { return }

                let showFullSpecificationsViewController: FullSpecificationsViewController = UIViewController
                    .instance(
                        from: "FullSpecifications",
                        with: "FullSpecificationsViewController",
                        bundle: .mva10Framework)
                showFullSpecificationsViewController.selectedDeviceFileName = self.viewModel.selectedDeviceFileName
                showFullSpecificationsViewController.selectedDevice = self.viewModel.selectedDevice?.id
                let navController = MVA10NavigationController(
                    rootViewController: showFullSpecificationsViewController
                )
                navController.setTitle(
                    title: "device_upgrade_device_step_show_full_specifications_screen_title"
                        .localized(bundle: .mva10Framework),
                    accessibilityID: "showFullSpecifications",
                    for: showFullSpecificationsViewController)
                navController.modalPresentationStyle = .fullScreen
                navController.isCloseButtonHidden = true
                navController.isBackButtonHidden = false
                navController.navigationDelegate = showFullSpecificationsViewController
                UIApplication.topViewController()?.present(navController, animated: true)
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.sectionsDatasource[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: getCellIdentiferFor(item: item), for: indexPath)

        switch item {
        case .deviceImage where cell is VFGDeviceImageCell:
            (cell as? VFGDeviceImageCell)?.updateImage(image: viewModel.selectedDevice?.imageUrl ?? "")
        case .colorSelection where cell is VFGDeviceColorSelectionCell:
            (cell as? VFGDeviceColorSelectionCell)?.dataSource = viewModel
        case .capcitySelection where cell is VFGDeviceCapacitySelectionCell:
            (cell as? VFGDeviceCapacitySelectionCell)?.dataSource = viewModel
        case .collectionAndDelivery where cell is VFGDeviceCollectionAndDeliveryCell:
            (cell as? VFGDeviceCollectionAndDeliveryCell)?.dataSource = viewModel
        case .continueToNextStep where cell is VFGDeviceContinueCell:
            let continueCell = cell as? VFGDeviceContinueCell
            continueCell?.setupUI()
            continueCell?.delegate = self
        case .specifications:
            prepareSpecificationCell(cell)
        default:
            break
        }
        return cell
    }

    private func getCellIdentiferFor(item: VFGDeviceUIModel) -> String {
        switch item {
        case .deviceImage:
            return deviceImageCellId
        case .colorSelection:
            return colorSelectionCellId
        case .capcitySelection:
            return capacitySelectionCellId
        case .collectionAndDelivery:
            return collectionAndDeliverySelectionCellId
        case .deviceOverview:
            return deviceOverviewCellId
        case .moreInformation:
            return moreInfoCellId
        case .continueToNextStep:
            return continueCellId
        case .specifications:
            return specificationCellId
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = viewModel.sectionsDatasource[indexPath.section]
        let item = section.items[indexPath.row]
        let isCellsCollapsed = section.header?.isCellsCollapsed ?? false

        switch item {
        case .collectionAndDelivery:
            return isCellsCollapsed ? 0 : collectionAndDeliveryHeight
        case .specifications:
            return isCellsCollapsed ? 0 : UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = viewModel.sectionsDatasource[section].header
        if let header = header {
            let headerView = VFGDeviceExpandableSectionHeaderView()
            headerView.updateUI(with: header)
            headerView.expandableSectionDidPress = { [weak self] in
                self?.expandableSectionHeaderDidPress(sectionIndex: section)
            }
            return headerView
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.sectionsDatasource[section].header == nil ? .leastNormalMagnitude : headerViewHeight
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}
