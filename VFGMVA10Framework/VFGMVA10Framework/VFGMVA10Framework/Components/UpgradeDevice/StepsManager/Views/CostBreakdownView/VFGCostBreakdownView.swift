//
//  VFGCostBreakdownView.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 23/10/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit

class VFGCostBreakdownView: UIView {
    @IBOutlet weak var breakdownTableView: UITableView!
    @IBOutlet weak var breakdownTableViewHeightConstraint: NSLayoutConstraint!

    var device: ChooseDeviceModel.Device?
    var plan: VFGUpgradePlanModel.Plan?
    let sections = (device: 0, plan: 1)

    override func awakeFromNib() {
        super.awakeFromNib()

        setupBreakdownTableView()
    }

    func setup(
        device: ChooseDeviceModel.Device?,
        plan: VFGUpgradePlanModel.Plan?
    ) {
        self.device = device
        self.plan = plan
        updateBreakdownTableView()
    }

    private func setupBreakdownTableView() {
        breakdownTableView.dataSource = self
        breakdownTableView.delegate = self
        breakdownTableView.register(
            UINib(
                nibName: String(describing: VFGBreakdownViewCell.self),
                bundle: .mva10Framework
            ),
            forCellReuseIdentifier: String(describing: VFGBreakdownViewCell.self)
        )
        breakdownTableView.register(
            UINib(
                nibName: String(describing: VFGBreakdownFooterView.self),
                bundle: .mva10Framework
            ),
            forHeaderFooterViewReuseIdentifier: String(describing: VFGBreakdownFooterView.self)
        )
    }

    private func updateBreakdownTableView() {
        breakdownTableViewHeightConstraint.constant = CGFloat.greatestFiniteMagnitude
        breakdownTableView.reloadData()
        breakdownTableView.layoutIfNeeded()
        breakdownTableViewHeightConstraint.constant = breakdownTableView.contentSize.height
    }
}
