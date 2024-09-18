//
//  FullSpecificationsViewController+Delegate.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 21/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

extension FullSpecificationsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfFullSpecs()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems(in: section)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: FullSpecificationsHeaderCell.self)
        ) as? FullSpecificationsHeaderCell else {
            return UIView()
        }
        header.configure(title: viewModel.getSpecTitle(in: section))
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        headerViewHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: FullSpecificationsCell.self),
            for: indexPath) as? FullSpecificationsCell else {
            return UITableViewCell()
        }

        let items = viewModel.getSpecItems(in: indexPath.section)
        cell.configure(item: items[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}
