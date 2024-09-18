//
//  FullSpecificationsViewController+UI.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 21/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

extension FullSpecificationsViewController {
    func setup() {
        registerCells()
        setupTableViewFooterView()
        initViewModel()
    }

    func registerCells() {
        let cell = UINib(
            nibName: String(describing: FullSpecificationsCell.self),
            bundle: .mva10Framework
        )
        tableView.register(
        cell,
        forCellReuseIdentifier: String(describing: FullSpecificationsCell.self))

        let headerCell = UINib(
            nibName: String(describing: FullSpecificationsHeaderCell.self),
            bundle: .mva10Framework
        )
        tableView.register(
        headerCell,
        forHeaderFooterViewReuseIdentifier: String(describing: FullSpecificationsHeaderCell.self))
    }

    func setupTableViewFooterView() {
        let footerFrame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: footerViewHeight)
        tableView.tableFooterView = UIView(frame: footerFrame)
    }
}
