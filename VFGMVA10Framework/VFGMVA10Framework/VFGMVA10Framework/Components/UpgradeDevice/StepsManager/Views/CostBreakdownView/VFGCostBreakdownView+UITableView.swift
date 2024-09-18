//
//  VFGCostBreakdownView+UITableView.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 23/10/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

extension VFGCostBreakdownView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard plan != nil else { return 1 }
        return Mirror(reflecting: sections).children.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: VFGBreakdownViewCell.self),
            for: indexPath
        ) as? VFGBreakdownViewCell else {
            return UITableViewCell()
        }

        switch indexPath.section {
        case sections.device:
            let deviceModel = deviceUIModel()
            cell.setup(
                title: deviceModel.title,
                productHeader: deviceModel.header,
                productItems: deviceModel.items
            )
        case sections.plan:
            let planModel = planUIModel()
            cell.setup(
                title: planModel.title,
                productHeader: planModel.header,
                productItems: planModel.items
            )
        default:
            return UITableViewCell()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        (plan == nil || section == sections.plan) ? 110 : 30
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard plan == nil || section == sections.plan,
            let footerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: VFGBreakdownFooterView.self
            )) as? VFGBreakdownFooterView else {
            let blankFooter = UIView(frame: .zero)
            blankFooter.tintColor = .VFGWhiteBackground
            return blankFooter
        }

        var productItems: [VFGProductItemUIModel] = []

        if let upfrontPrice = device?.price?.upfrontPrice {
            productItems.append(
                VFGProductItemUIModel(
                    name: (
                        text: "device_upgrade_summary_step_total_cost_device_upfront"
                            .localized(bundle: .mva10Framework),
                        font: .vodafoneBold(17)
                    ),
                    price: (text: "\(upfrontPrice)", font: .vodafoneBold(17)),
                    currency: device?.price?.currency
                )
            )
        }

        if let monthly = device?.price?.contractPeriod,
            let deviceRecurringPrice = device?.price?.recurringPrice {
            let name = String(
                format: "device_upgrade_summary_step_total_cost_total_to_pay_monthly"
                    .localized(bundle: .mva10Framework),
                "\(monthly)")
            let planRecurringPrice = plan?.price?.recurringPrice ?? 0
            productItems.append(
                VFGProductItemUIModel(
                    name: (text: name, font: .vodafoneBold(17)),
                    price: (text: "\(deviceRecurringPrice + planRecurringPrice)", font: .vodafoneBold(17)),
                    currency: device?.price?.currency
                )
            )
        }

        footerView.setup(
            title: "device_upgrade_summary_step_total_cost_total_to_pay"
                .localized(bundle: .mva10Framework),
            productItems: productItems
        )
        return footerView
    }
}

extension VFGCostBreakdownView {
    private func deviceUIModel() -> DeviceUIModel {
        let title = "device_upgrade_summary_step_total_cost_your_upgrade_selection".localized(bundle: .mva10Framework)
        let name = device?.title ?? ""
        let size = device?.capacity?.size ?? 0
        let unit = device?.capacity?.sizeUnit ?? ""

        let productHeader = VFGProductHeaderUIModel(
            imageURL: device?.imageUrl,
            name: (text: device?.brand ?? "", font: .vodafoneRegular(15)),
            description: (text: "\(name) - \(size)\(unit)", font: .vodafoneRegular(19))
        )

        var productItems: [VFGProductItemUIModel] = []

        if let upfrontPrice = device?.price?.upfrontPrice {
            productItems.append(
                VFGProductItemUIModel(
                    name: (
                        text: "device_upgrade_summary_step_total_cost_device_upfront"
                            .localized(bundle: .mva10Framework),
                        font: .vodafoneRegular(17)
                    ),
                    price: (text: "\(upfrontPrice)", font: .vodafoneRegular(17)),
                    currency: device?.price?.currency
                )
            )
        }

        if let contractPeriod = device?.price?.contractPeriod,
            let recurringPrice = device?.price?.recurringPrice {
            let name = String(
                format: "device_upgrade_summary_step_total_cost_device_monthly"
                    .localized(bundle: .mva10Framework),
                "\(contractPeriod)")
            productItems.append(
                VFGProductItemUIModel(
                    name: (text: name, font: .vodafoneRegular(17)),
                    price: (text: "\(recurringPrice)", font: .vodafoneRegular(17)),
                    currency: device?.price?.currency
                )
            )
        }

        if let totalPrice = device?.price?.totalPrice {
            productItems.append(
                VFGProductItemUIModel(
                    name: (
                        text: "device_upgrade_summary_step_total_cost_device_total_cost"
                            .localized(bundle: .mva10Framework),
                        font: .vodafoneBold(17)
                    ),
                    price: (text: "\(totalPrice)", font: .vodafoneRegular(17)),
                    currency: device?.price?.currency
                )
            )
        }

        return (title, productHeader, productItems)
    }

    private func planUIModel() -> DeviceUIModel {
        let title = "device_upgrade_summary_step_total_cost_your_new_plan".localized(bundle: .mva10Framework)
        let productHeader = VFGProductHeaderUIModel(
            imageURL: plan?.imageURL,
            name: nil,
            description: (text: plan?.name ?? "", font: .vodafoneRegular(19))
        )

        var productItems: [VFGProductItemUIModel] = []

        if let contractPeriod = plan?.price?.contractPeriod,
            let recurringPrice = plan?.price?.recurringPrice {
            let name = String(
                format: "device_upgrade_summary_step_total_cost_device_monthly"
                    .localized(bundle: .mva10Framework),
                "\(contractPeriod)")

            productItems.append(
                VFGProductItemUIModel(
                    name: (text: name, font: .vodafoneRegular(17)),
                    price: (text: "\(recurringPrice)", font: .vodafoneRegular(17)),
                    currency: plan?.price?.currency
                )
            )
        }

        return (title, productHeader, productItems)
    }
}
