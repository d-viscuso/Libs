//
//  VFGDeviceViewController+UI.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 24/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

extension VFGDeviceViewController {
    func setupUI() {
        registerTableViewCells()
        setupTableViewUI()
        setupTableViewFooterView()
    }

    private func registerTableViewCells() {
        tableView.register(
            UINib(
                nibName: deviceImageCellId,
                bundle: Bundle.mva10Framework),
            forCellReuseIdentifier: deviceImageCellId)

        tableView.register(
            UINib(
                nibName: collectionAndDeliverySelectionCellId,
                bundle: Bundle.mva10Framework),
            forCellReuseIdentifier: collectionAndDeliverySelectionCellId)

        tableView.register(
            UINib(
                nibName: deviceOverviewCellId,
                bundle: Bundle.mva10Framework),
            forCellReuseIdentifier: deviceOverviewCellId)

        tableView.register(
            UINib(
                nibName: moreInfoCellId,
                bundle: Bundle.mva10Framework),
            forCellReuseIdentifier: moreInfoCellId)

        tableView.register(
            UINib(
                nibName: capacitySelectionCellId,
                bundle: Bundle.mva10Framework),
            forCellReuseIdentifier: capacitySelectionCellId)

        tableView.register(
            UINib(
                nibName: colorSelectionCellId,
                bundle: Bundle.mva10Framework),
            forCellReuseIdentifier: colorSelectionCellId)

        tableView.register(
            UINib(
                nibName: continueCellId,
                bundle: Bundle.mva10Framework),
            forCellReuseIdentifier: continueCellId)

        tableView.register(
            UINib(
                nibName: specificationCellId,
                bundle: Bundle.mva10Framework),
            forCellReuseIdentifier: specificationCellId)
    }

    private func setupTableViewUI() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }

    private func setupTableViewFooterView() {
        let footerFrame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: footerViewHeight)
        tableView.tableFooterView = UIView(frame: footerFrame)
    }
}
