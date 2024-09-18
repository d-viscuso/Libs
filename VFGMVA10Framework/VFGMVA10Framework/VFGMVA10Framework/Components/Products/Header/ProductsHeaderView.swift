//
//  ProductsHeaderView.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 11/9/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

/// Products header view delegate
public protocol ProductsHeaderViewDelegate: AnyObject {
    /// products header custom view.
    var customView: UIView? { get }
    /// Products header view topUp button Action
    func topUpButtonDidPress()
}

public extension ProductsHeaderViewDelegate {
    var customView: UIView? { nil }
}

/// Products header view.
public class ProductsHeaderView: UIView, VFGRefreshViewProtocol {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: VFGLabel!
    @IBOutlet weak var balanceText: VFGLabel!
    @IBOutlet weak var balanceValue: VFGLabel!
    @IBOutlet weak var phoneNumber: VFGLabel!
    @IBOutlet weak public var lastUpdatedLabel: VFGLabel!
    @IBOutlet weak public var refreshButton: VFGButton!
    @IBOutlet weak var topUpHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topUpTopContraint: NSLayoutConstraint!
    @IBOutlet weak var topUpButton: VFGButton!
    @IBOutlet weak var billingButton: VFGButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var customHeaderView: UIView!
    @IBOutlet weak var billingButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var productSimLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var simImage: VFGImageView!
    var refreshManager: VFGRefreshManager?
    var topupButtonHeight: CGFloat = 32.0
    var topupButtonTop: CGFloat = 26.0
    var simIconLeft: CGFloat = 25.0
    var billingWidth: CGFloat = 90.0
    public weak var delegate: (ProductsHeaderViewDelegate & VFGRefreshViewDelegate)?

    public override func awakeFromNib() {
        super.awakeFromNib()
        setupLabelsColors()
        setupAccessibilityIdentifier()
    }

    @IBAction func topUpButtonPressed(_ sender: Any) {
        delegate?.topUpButtonDidPress()
    }

    @IBAction func refreshButtonPressed(_ sender: Any) {
        delegate?.refreshButtonDidPress()
    }

    /// Configure the view with the model.
    /// - Parameters:
    ///    - viewModel: Products header model *ProductsHeaderViewModel?*.
    public func configure(with viewModel: ProductsHeaderViewModel?) {
        if let cutsomView = delegate?.customView {
            customHeaderView.isHidden = false
            headerView.isHidden = true
            customHeaderView.embed(view: cutsomView)
            customHeaderView.heightAnchor.constraint(equalTo: cutsomView.heightAnchor).isActive = true
            return
        } else {
            customHeaderView.isHidden = true
            headerView.isHidden = false
        }
        titleLabel.text = viewModel?.title
        balanceValue.text = viewModel?.balanceValue
        balanceValue.textColor = viewModel?.balanceTextColor ?? .primaryTextColor
        balanceText.text = viewModel?.balanceText
        phoneNumber.text = viewModel?.phoneNumber
        topUpButton.setTitle(
            viewModel?.topUpBtnTitle ?? "my_products_header_payg_topup_button_title".localized(bundle: .mva10Framework),
            for: .normal)
        topUpHeightConstraint.constant = (viewModel?.enableTopup ?? false) ? topupButtonHeight : 0.0
        let topUpHeight = (phoneNumber.frame.midY - topUpHeightConstraint.constant * 0.5)
        topUpTopContraint.constant = (viewModel?.topUpMoveBottom ?? false) ? topUpHeight : topupButtonTop
        let simShowed = (viewModel?.shouldShowSimIcon ?? false)
        simImage.isHidden = !simShowed
        productSimLeadingConstraint.constant = simShowed ? simIconLeft : -5.0
        if viewModel?.topUpMoveBottom == true {
            billingButtonWidth.constant = billingWidth
        }
        // Soho
        billingButton.setTitle(viewModel?.billingBtnTitle, for: .normal)
        billingButton.isHidden = !(viewModel?.enableBilling ?? false)
        lastUpdatedLabel.isHidden = viewModel?.enableRefresh ?? false
        refreshButton.isHidden = viewModel?.enableRefresh ?? false
        refreshButton.transform = UIApplication.isRightToLeft ?
            CGAffineTransform(scaleX: -1, y: 1) :
            .identity
        setupAccessibilityLabels()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    deinit {
        refreshManager?.didMoveToBackground()
    }

    private func commonInit() {
        xibSetup()
        refreshManager = VFGRefreshManager(
            lastUpdatedTimeKey: "productsLastUpdatedTime",
            refreshView: self,
            refreshStatusModel: VFGRefreshStatusModel(
                updatingText: "my_products_updatedlabel_updating".localized(bundle: .mva10Framework),
                justUpdatedText: "my_products_updatedlabel_justupdated".localized(bundle: .mva10Framework),
                updatedMinText: "my_products_updatedlabel_minute".localized(bundle: .mva10Framework),
                updatedMinsText: "my_products_updatedlabel_minutes".localized(bundle: .mva10Framework),
                timeStampText: "my_products_updatedlabel_timestamp".localized(bundle: .mva10Framework)
            )
        )

        addForegroundObserver()
        addBackgroundObserver()
    }

    func xibSetup() {
        if let view = loadViewFromNib(
            nibName: String("\(ProductsHeaderView.self)"),
            in: Bundle.mva10Framework) {
            contentView = view
            xibSetup(contentView: contentView)
        }
    }

    func setupLabelsColors() {
        titleLabel.textColor = .primaryTextColor
        balanceText.textColor = .primaryTextColor
        phoneNumber.textColor = .secondaryTextColor
        lastUpdatedLabel.textColor = .primaryTextColor
    }

    private func setupAccessibilityIdentifier() {
        titleLabel.accessibilityIdentifier = "PRtitleLabel"
        balanceText.accessibilityIdentifier = "PRbalanceDescriptionLabel"
        balanceValue.accessibilityIdentifier = "PRbalanceValueLabel"
        phoneNumber.accessibilityIdentifier = "PRphoneLabel"
    }

    func addForegroundObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didMoveToForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil)
    }

    func addBackgroundObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didMoveToBackground),
            name: UIApplication.willResignActiveNotification,
            object: nil)
    }

    @objc func didMoveToBackground() {
        refreshManager?.didMoveToBackground()
    }

    @objc func didMoveToForeground() {
        refreshManager?.didMoveToForeground()
    }
}

extension ProductsHeaderView {
    func setupAccessibilityLabels() {
        titleLabel.accessibilityLabel = titleLabel.text ?? ""
        balanceText.accessibilityLabel = balanceText.text ?? ""
        balanceValue.accessibilityLabel = balanceValue.text ?? ""
        phoneNumber.accessibilityLabel = phoneNumber.text ?? ""
        lastUpdatedLabel.accessibilityLabel = lastUpdatedLabel.text ?? ""
        refreshButton.accessibilityLabel = refreshButton.titleLabel?.text ?? ""
        topUpButton.accessibilityLabel = topUpButton.titleLabel?.text ?? ""
        billingButton.accessibilityLabel = billingButton.titleLabel?.text ?? ""
        accessibilityCustomActions = [refreshVoiceOverAction()]
        accessibilityCustomActions?.append(topUpVoiceOverAction())
    }
    /// action for product header  voice over
    /// - Returns: action for product header  buttons in voice over

    func refreshVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "refresh"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(refreshButtonPressed))
    }
    func topUpVoiceOverAction() -> UIAccessibilityCustomAction {
        let actionName = "toUp"
        return UIAccessibilityCustomAction(name: actionName, target: self, selector: #selector(topUpButtonPressed))
    }
}
