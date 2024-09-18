//
//  VFGUpgradeCostCell+UITableView.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 6/12/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

typealias DeviceUIModel = (title: String, header: VFGProductHeaderUIModel, items: [VFGProductItemUIModel])

extension VFGUpgradeCostCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Mirror(reflecting: sections).children.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: VFGBreakdownViewCell.self),
                for: indexPath) as? VFGBreakdownViewCell else {
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
        section == sections.plan ? 110 : 30
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == sections.plan,
            let footerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: VFGBreakdownFooterView.self
            )) as? VFGBreakdownFooterView else {
            let blankFooter = UIView(frame: .zero)
            blankFooter.tintColor = .VFGWhiteBackground
            return blankFooter
        }

        // todo: values should come from a model
        let upfront = VFGProductItemUIModel(
            name: (
                text: "device_upgrade_summary_step_total_cost_total_to_pay_upfront"
                    .localized(bundle: .mva10Framework),
                font: .vodafoneBold(17)),
            price: (text: "215", font: .vodafoneBold(17)),
            currency: "€"
        )

        let name = String(
            format: "device_upgrade_summary_step_total_cost_total_to_pay_monthly"
                .localized(bundle: .mva10Framework),
            "24")

        let monthly = VFGProductItemUIModel(
            name: (text: name, font: .vodafoneBold(17)),
            price: (text: "49", font: .vodafoneBold(17)),
            currency: "€"
        )

        footerView.setup(
            title: "device_upgrade_summary_step_total_cost_total_to_pay"
                .localized(bundle: .mva10Framework),
            productItems: [upfront, monthly]
        )
        return footerView
    }
}

extension VFGUpgradeCostCell {
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
            imageURL: device?.imageUrl,
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
