//
//  PrimaryPlanServicesFooter.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 7/4/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class PrimaryPlanServicesFooter: UITableViewHeaderFooterView {
    /// Creates a generic identifier for the UITableViewCell depending on it's name/title.
    static var reuseIdentifier: String {
        return String(describing: self)
    }

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pricePerMonthContainerView: UIView!
    @IBOutlet weak var pricePerMonthLabel: VFGLabel!
    @IBOutlet weak var priceLabel: VFGLabel!
    @IBOutlet weak var priceUnitLabel: VFGLabel!
    @IBOutlet weak var secondaryButton: VFGButton!
    @IBOutlet weak var primaryButton: VFGButton!
    @IBOutlet weak var secondaryButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var planInfoStackView: UIStackView!
    @IBOutlet weak var planInfoStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var extraInfoStackView: UIStackView!
    @IBOutlet weak var extraInfoStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var showMoreDividerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var showMoreButton: VFGButton!
    @IBOutlet weak var showMoreButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var extraInfoDividerHeight: NSLayoutConstraint!
    @IBOutlet weak var priceDividerHeight: NSLayoutConstraint!
    @IBOutlet weak var topSeparator: UIView!
    @IBOutlet weak var pricePerMonthViewBottomSeparator: UIView!
    @IBOutlet weak var extraInfoViewTopSeparator: UIView!
    @IBOutlet weak var extraInfoViewBottomSeparator: UIView!

    var isExpanded = false
    var upgradeAction: (() -> Void)?
    var primaryButtonAction: (() -> Void)?
    var updateHeightClosure: (() -> Void)?
    var viewModel: PrimaryPlanServicesFooterViewModel? {
        didSet {
            configureView()
        }
    }

    func configureView() {
        containerView.backgroundColor = .lightBackground
        topSeparator.backgroundColor = .firstDivider
        pricePerMonthViewBottomSeparator.backgroundColor = .firstDivider
        extraInfoViewTopSeparator.backgroundColor = .firstDivider
        extraInfoViewBottomSeparator.backgroundColor = .firstDivider
        showMoreButton?.setTitle(
            "my_plan_primary_card_show_more".localized(bundle: Bundle.mva10Framework),
            for: .normal)
        pricePerMonthLabel?.text = "my_plan_primary_card_price_label"
            .localized(bundle: Bundle.mva10Framework)
        pricePerMonthLabel.textColor = .primaryTextColor
        priceLabel.textColor = .primaryTextColor
        setupPricePerMonthSection()
        priceUnitLabel?.text = viewModel?.priceUnit
        priceUnitLabel.textColor = .primaryTextColor

        secondaryButton?.setTitle(viewModel?.secondaryButtonTitle, for: .normal)
        let upgradeButtonStyle = viewModel?.secondaryButtonStyle ?? .primary
        secondaryButton?.buttonStyle = upgradeButtonStyle.rawValue

        primaryButton.setTitle(viewModel?.primaryButtonTitle, for: .normal)
        primaryButton.buttonStyle = viewModel?.primaryButtonStyle?.rawValue ?? 0
        primaryButtonAction = viewModel?.primaryButtonAction

        if viewModel?.primaryButtonTitle?.isEmpty ?? true {
            primaryButton.isHidden = true
        }

        planInfoStackView?.removeSubviews()
        extraInfoStackView?.removeSubviews()
        if let planInfo = viewModel?.planInfo {
            planInfoStackView?
                .reload(planInfo, using: PlanExtraInfoItemView.self)
        }
        if let lastPlanInfoView = planInfoStackView?.subviews.last as? PlanExtraInfoItemView {
            lastPlanInfoView.hideSeparator()
        }
        self.layoutIfNeeded()
        showMoreButton?.setTitleColor(.redTextColor, for: .normal)
        shouldHideInfoViews()
        roundCorners()
        setupAccessibilityLabels()
    }

    private func setupPricePerMonthSection() {
        guard !(viewModel?.pricePerMonth.isEmptyOrNil ?? true) else {
            pricePerMonthContainerView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            pricePerMonthContainerView.isHidden = true
            return
        }
        priceLabel?.text = viewModel?.pricePerMonth
    }

    func shouldHideInfoViews() {
        if viewModel?.planInfo?.isEmpty ?? true {
            planInfoStackView?.removeFromSuperview()
        }
        if viewModel?.extraPlanInfo?.isEmpty ?? true {
            showMoreButton?.removeFromSuperview()
            showMoreDividerViewHeight.constant = .zero
            extraInfoDividerHeight.constant = .zero
        }
        if viewModel?.planInfo?.isEmpty ?? false, viewModel?.extraPlanInfo?.isEmpty ?? false {
            secondaryButton?.removeFromSuperview()
            priceDividerHeight.constant = .zero
        }
    }

    @IBAction func upgradeActionPressed(_ sender: Any) {
        upgradeAction?()
    }

    @IBAction func primaryButtonDidPressed() {
        primaryButtonAction?()
    }

    @IBAction func toggleShowMore(_ sender: Any) {
        isExpanded.toggle()
        if isExpanded,
            let extraInfo = viewModel?.extraPlanInfo {
            extraInfoStackViewHeightConstraint.constant = extraInfoStackView?
                .reload(extraInfo, using: PlanExtraInfoItemView.self) ?? .zero
            showMoreDividerViewHeight.constant = 1
            updateHeightClosure?()
            showMoreButton?.setTitle(
                "my_plan_primary_card_show_less".localized(bundle: Bundle.mva10Framework),
                for: .normal)
        } else {
            extraInfoStackView?.removeSubviews()
            extraInfoStackViewHeightConstraint.constant = 0
            showMoreDividerViewHeight.constant = 0
            updateHeightClosure?()
            showMoreButton?.setTitle(
                "my_plan_primary_card_show_more".localized(bundle: Bundle.mva10Framework),
                for: .normal)
        }
        showMoreButton?.accessibilityLabel = showMoreButton.titleLabel?.text
    }

    private func setupAccessibilityLabels() {
        [pricePerMonthLabel, priceLabel, priceUnitLabel, showMoreButton]
            .forEach { $0?.isAccessibilityElement = false }
        pricePerMonthContainerView.isAccessibilityElement = true
        guard let showMoreButton = showMoreButton else { return }

        let pricePerMonthAXText = [
            pricePerMonthLabel.text ?? "",
            "is",
            priceLabel.text ?? "",
            priceUnitLabel.text ?? ""
        ]
        pricePerMonthContainerView.accessibilityLabel = pricePerMonthAXText.joined(separator: " ")
        showMoreButton.isAccessibilityElement = true
        showMoreButton.accessibilityLabel = showMoreButton.titleLabel?.text
    }
}

/// A model for the primary plan services footer view model
public struct PrimaryPlanServicesFooterViewModel {
    /// a string that represents the price per month of the plan
    var pricePerMonth: String?
    /// a string that represents the price unit the plan
    var priceUnit: String
    /// an object of PlanExtraInfo
    var planInfo: [PlanExtraInfo]?
    /// an object of PlanExtraInfo that represents extra information
    var extraPlanInfo: [PlanExtraInfo]?
    /// secondary button text /* upgrade button */
    var secondaryButtonTitle: String
    /// secondary button style
    var secondaryButtonStyle: VFGButton.ButtonStyle
    /// primary button text
    var primaryButtonTitle: String?
    /// primary button style
    var primaryButtonStyle: VFGButton.ButtonStyle?
    /// primary button action that will be executed
    var primaryButtonAction: (() -> Void)?

    /// - Parameters:
    ///   - pricePerMonth: a string that represents the price per month of the plan
    ///   - planInfo: an object of PlanExtraInfo
    ///   - priceUnit: a string that represents the price unit the plan
    ///   - extraPlanInfo: an object of PlanExtraInfo that represents extra information
    ///   - secondaryButtonTitle: secondary button text
    ///   - secondaryButtonStyle: secondary button style
    ///   - primaryButtonTitle: primary button text
    ///   - primaryButtonStyle: primary button style
    ///   - primaryButtonAction: primary button action that will be executed 
    public init(
        pricePerMonth: String?,
        planInfo: [PlanExtraInfo]?,
        priceUnit: String,
        extraPlanInfo: [PlanExtraInfo]?,
        secondaryButtonTitle: String,
        secondaryButtonStyle: VFGButton.ButtonStyle,
        primaryButtonTitle: String? = nil,
        primaryButtonStyle: VFGButton.ButtonStyle? = nil,
        primaryButtonAction: (() -> Void)? = nil
    ) {
        self.pricePerMonth = pricePerMonth
        self.planInfo = planInfo
        self.extraPlanInfo = extraPlanInfo
        self.priceUnit = priceUnit
        // primary button
        self.primaryButtonTitle = primaryButtonTitle
        self.primaryButtonStyle = primaryButtonStyle
        self.primaryButtonAction = primaryButtonAction

        // secondary button *Upgrade button*
        self.secondaryButtonTitle = secondaryButtonTitle
        self.secondaryButtonStyle = secondaryButtonStyle
    }
}
