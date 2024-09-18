//
//  MyPlanViewController+Cells.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 04/11/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

extension MyPlanViewController {
    func addShimmerCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let shimmerCell = tableView.dequeueReusableCell(
            withIdentifier: MyPlanShimmerCell.reuseIdentifier,
            for: indexPath) as? MyPlanShimmerCell else { return UITableViewCell() }
        shimmerCell.startShimmer()
        shimmerCell.accessibilityIdentifier = "MPshimmerCell\(indexPath.row)"
        return shimmerCell
    }

    func addErrorCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let errorCell = tableView.dequeueReusableCell(
            withIdentifier: "ProductsErrorTableViewCell",
            for: indexPath) as? ProductsErrorTableViewCell else { return UITableViewCell() }
        errorCell.setupErrorCell()
        errorCell.refreshAction = {
            self.refresh()
        }
        return errorCell
    }

    func addPrimaryPlanLimitedCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let limitedServiceCell = tableView.dequeueReusableCell(
            withIdentifier: PrimaryPlanLimitedCell.reuseIdentifier,
            for: indexPath) as? PrimaryPlanLimitedCell else { return UITableViewCell() }
        limitedServiceCell.configure(with: myPlanViewModel?.cellViewModel(at: indexPath.row))
        if let placeHolderView = myPlanViewModel?.myPlanDataProvider.customDetailsView(at: indexPath.row),
            let isCustomDetailsViewHidden = myPlanViewModel?.isCustomDetailsViewHidden {
            limitedServiceCell.addBalanceButton.isHidden = true
            limitedServiceCell.customDetailsView.isHidden = isCustomDetailsViewHidden
            limitedServiceCell.customDetailsView.embed(view: placeHolderView)
        }
        limitedServiceCell.addDataButtonAction = { [weak self] in
            guard let self = self else { return }
            let planType: AddPlanType = indexPath.row == 0 ? .data : .sms
            self.addPlanStateManagerDelegate?.setupAddPlanView(planType: planType)
        }
        limitedServiceCell.accessibilityIdentifier = "MPlimitedServiceCell\(indexPath.row)"
        limitedServiceCell.addBalanceButton.accessibilityIdentifier = "MPaddBalanceButton\(indexPath.row)"
        return limitedServiceCell
    }

    func addPrimaryPlanUnlimitedCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let unlimitedServiceCell = tableView.dequeueReusableCell(
            withIdentifier: PrimaryPlanUnlimitedCell.reuseIdentifier,
            for: indexPath) as? PrimaryPlanUnlimitedCell else { return UITableViewCell() }
        unlimitedServiceCell.configure(with: myPlanViewModel?.cellViewModel(at: indexPath.row))
        if let placeHolderView = myPlanViewModel?.myPlanDataProvider.customDetailsView(at: indexPath.row),
            let isCustomDetailsViewHidden = myPlanViewModel?.isCustomDetailsViewHidden {
            unlimitedServiceCell.customDetailsView.isHidden = isCustomDetailsViewHidden
            unlimitedServiceCell.customDetailsView.embed(view: placeHolderView)
        }
        unlimitedServiceCell.accessibilityIdentifier = "MPunlimitedServiceCell\(indexPath.row)"
        return unlimitedServiceCell
    }

    func addPrimaryPlanInformativeCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let informativeServiceCell = tableView.dequeueReusableCell(
            withIdentifier: PrimaryPlanInformativeCell.reuseIdentifier,
            for: indexPath) as? PrimaryPlanInformativeCell else { return UITableViewCell() }
        if entryPoint == .broadband {
            informativeServiceCell
                .configure(
                    with: myPlanViewModel?.cellViewModel(at: indexPath.row),
                    isTextBold: true
                )
        } else {
            informativeServiceCell.configure(with: myPlanViewModel?.cellViewModel(at: indexPath.row))
        }
        informativeServiceCell.accessibilityIdentifier = "MPinformativeServiceCell\(indexPath.row)"
        return informativeServiceCell
    }

    func addPrimaryPlanDescriptionCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let descriptionServiceCell = tableView.dequeueReusableCell(
            withIdentifier: PrimaryPlanDescriptionCell.reuseIdentifier,
            for: indexPath) as? PrimaryPlanDescriptionCell else { return UITableViewCell() }
        descriptionServiceCell.configure(with: myPlanViewModel?.cellViewModel(at: indexPath.row))
        descriptionServiceCell.accessibilityIdentifier = "MPdescriptionServiceCell\(indexPath.row)"
        return descriptionServiceCell
    }

    func addHideCustomDetailsBtnCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let hideCustomDetailsBtnCell = tableView.dequeueReusableCell(
            withIdentifier: HideCustomDetailsButtonCell.reuseIdentifier,
            for: indexPath) as? HideCustomDetailsButtonCell else { return UITableViewCell() }
        let title = (myPlanViewModel?.isCustomDetailsViewHidden ?? false) ?
        myPlanViewModel?.customDetailsButtonTitleOnClick :
        myPlanViewModel?.customDetailsButtonTitle
        hideCustomDetailsBtnCell.configure(with: title) { [weak self] in
            guard let self = self else { return }
            self.myPlanViewModel?.isCustomDetailsViewHidden.toggle()
            self.activePlanServicesTableView.reloadData()
        }
        hideCustomDetailsBtnCell.accessibilityIdentifier = "MPhideCustomDetailsButtonCell\(indexPath.row)"
        return hideCustomDetailsBtnCell
    }
}
