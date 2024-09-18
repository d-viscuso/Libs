//
//  VFGUpgradeCostCell.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 6/8/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class VFGUpgradeCostCell: UITableViewCell {
    @IBOutlet weak var breakdownTableView: UITableView!
    @IBOutlet weak var chevronButton: VFGButton!
    @IBOutlet weak var whyButton: VFGButton!
    @IBOutlet weak var breakdownMainStackView: UIStackView!
    @IBOutlet weak var breakdownHeaderStackView: UIStackView!
    @IBOutlet weak var breakdownSeparatorView: UIView!
    @IBOutlet weak var breakdownTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var upfrontPriceLabel: VFGLabel!
    @IBOutlet weak var recurringPriceLabel: VFGLabel!

    weak var delegate: VFGUpgradeCostCellDelegate?
    var device: ChooseDeviceModel.Device?
    var plan: VFGUpgradePlanModel.Plan?
    let sections = (device: 0, plan: 1)
    var isBreakdownCollapsed = true {
        didSet {
            breakdownTableView.isHidden = isBreakdownCollapsed

            if isBreakdownCollapsed {
                chevronButton.animateChevronDown()
            } else {
                chevronButton.animateChevronUp()
            }
            breakdownMainStackView.removeArrangedSubview(breakdownSeparatorView)
            breakdownMainStackView.insertArrangedSubview(breakdownSeparatorView, at: isBreakdownCollapsed ? 1 : 2)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setupBreakdownTableView()
        setupBreakdownHeaderStackView()
    }

    func setup(
        device: ChooseDeviceModel.Device?,
        plan: VFGUpgradePlanModel.Plan?,
        _ delegate: VFGUpgradeCostCellDelegate
    ) {
        self.device = device
        self.plan = plan
        self.delegate = delegate

        let currency = device?.price?.currency ?? ""

        if let upfrontPrice = device?.price?.upfrontPrice {
            upfrontPriceLabel.text = "\(upfrontPrice)\(currency)"
        }

        if let recurringPrice = device?.price?.recurringPrice {
            recurringPriceLabel.text = "\(recurringPrice)\(currency)"
        }

        updateBreakdownTableView()
        setupAccessibilityLabels()
    }

    private func setupBreakdownTableView() {
        breakdownTableView.rowHeight = UITableView.automaticDimension
        breakdownTableView.estimatedRowHeight = 200

        breakdownTableView.register(
            UINib(nibName: String(describing: VFGBreakdownViewCell.self), bundle: .mva10Framework),
            forCellReuseIdentifier: String(describing: VFGBreakdownViewCell.self)
        )

        breakdownTableView.register(
            UINib(nibName: String(describing: VFGBreakdownFooterView.self), bundle: .mva10Framework),
            forHeaderFooterViewReuseIdentifier: String(describing: VFGBreakdownFooterView.self)
        )
    }

    private func setupBreakdownHeaderStackView() {
        let tap: UITapGestureRecognizer =
            UITapGestureRecognizer(
                target: self,
                action: #selector(breakdownRowDidPress)
        )
        tap.cancelsTouchesInView = false
        breakdownHeaderStackView.addGestureRecognizer(tap)
        breakdownHeaderStackView.isAccessibilityElement = true
        breakdownHeaderStackView.accessibilityIdentifier = "UDSummaryCostBreakDownButton"
    }

    private func updateBreakdownTableView() {
        breakdownTableHeightConstraint.constant = CGFloat.greatestFiniteMagnitude
        breakdownTableView.reloadData()
        breakdownTableView.layoutIfNeeded()
        breakdownTableHeightConstraint.constant = breakdownTableView.contentSize.height
    }

    @IBAction func breakdownRowDidPress() {
        delegate?.breakdownRowDidPress()
    }

    @IBAction func whyButtonDidPress(_ sender: Any) {
        whyButtonAction()
    }

    @objc func whyButtonAction() {
        VFQuickActionsViewController.presentQuickActionsViewController(with: PriceInfoQuickActionViewModel())
    }
}

protocol VFGUpgradeCostCellDelegate: AnyObject {
    func breakdownRowDidPress()
}

extension VFGUpgradeCostCell {
    func setupAccessibilityLabels() {
        upfrontPriceLabel.accessibilityLabel = upfrontPriceLabel.text ?? ""
        recurringPriceLabel.accessibilityLabel = recurringPriceLabel.text ?? ""
        chevronButton.accessibilityLabel = chevronButton.titleLabel?.text ?? ""
        whyButton.accessibilityLabel = whyButton.titleLabel?.text ?? ""
        accessibilityCustomActions = [whyVoiceOverAction()]
    }
    /// action for upgrade cost voice over
    /// - Returns: action for upgrade cost  button in voice over

    func whyVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "why"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(whyButtonAction))
    }
}
