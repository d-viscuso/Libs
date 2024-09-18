//
//  VFGUpgradeViewController.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 18/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

public class VFGUpgradeViewController: UIViewController {
    @IBOutlet weak var priceViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var deviceModelLabel: VFGLabel!
    @IBOutlet weak var upfrontPriceLabel: VFGLabel!
    @IBOutlet weak var upfrontLabel: VFGLabel!
    @IBOutlet weak var upfrontStackView: UIStackView!
    @IBOutlet weak var installmentPriceLabel: VFGLabel!
    @IBOutlet weak var installmentPeriodLabel: VFGLabel!
    @IBOutlet weak var installmentStackView: UIStackView!
    @IBOutlet weak var contractMonthsLabel: VFGLabel!
    @IBOutlet weak var contractPeriodLabel: VFGLabel!
    @IBOutlet weak var contractStackView: UIStackView!
    @IBOutlet weak var costBreakdownLabel: VFGLabel!
    @IBOutlet weak var costBreakdownStackView: UIStackView!
    @IBOutlet weak var stepsView: VFGHorizontalStepControl!
    @IBOutlet weak var collectionView: UICollectionView!

    lazy public var stepsViewControllers: [VFGBaseUpgradeStepsViewControllerProtocol] = {
        [
            VFGChooseDeviceViewController.instance,
            VFGDeviceViewController.instance,
            VFGUpgradePlanViewController.instance,
            VFGUpgradeSummaryViewController.instance
        ]
    }()

    let stepsCollectionCellId = "StepsCollectionCell"
    let stepsCollectionCellNibName = "StepsCollectionCell"
    let priceViewHeightConstant = CGFloat(110)
    var upgradeModel = VFGUpgradeModel()
    var lastPassedStepIndex: Int = 0
    var selectedDevice: ChooseDeviceModel.Device?

    override public func viewDidLoad() {
        super.viewDidLoad()
        priceViewHeightConstraint.constant = 0
        priceView.isHidden = true
        setupCollectionView()
        setupStepController()
        setupAccessibilityLabels()
        setupCostBreakdownView()
    }

    private func setupStepController() {
        stepsView.delegate = self
        stepsView.dataSource = self

        // Index is only used and the stepController value is ignored
        // because it will cause a retain cycle when its used in the below closure
        stepsViewControllers.enumerated().forEach { index, _ in
            stepsViewControllers[index].onStepComplete = {[weak self] model in
                // here to fill object of whole logic
                // here is the logic for moving from one step to other
                guard let self = self else {
                    return
                }
                self.fillUpgradeModel(with: model, for: self.stepsViewControllers[index])

                if self.stepsViewControllers[index] is VFGUpgradeSummaryViewController {
                    self.confirm()
                } else {
                    self.stepsView.complete()
                }
            }
            stepsViewControllers[index].onPriceChange = { [weak self] model in
                guard let self = self else {
                    return
                }
                self.selectedDevice = model as? ChooseDeviceModel.Device
                self.updatePriceView(with: model, for: self.stepsViewControllers[index])
            }
            stepsViewControllers[index].onStepStatusChange = { [weak self] status in
                guard let self = self else { return }
                self.stepsViewControllers
                .enumerated()
                .filter {
                    $0.offset > index &&
                    (self.stepsViewControllers[self.lastPassedStepIndex].status == .pending ?
                        $0.offset <= self.lastPassedStepIndex : true)
                }
                .forEach { _, viewController in
                    viewController.status = status
                }
                self.stepsView.reset()
            }
            if stepsViewControllers[index] is VFGUpgradeSummaryViewController {
                let summaryViewController = stepsViewControllers[index] as? VFGUpgradeSummaryViewController
                summaryViewController?.onStepBackToStart = {[weak self] in
                    self?.stepsView.back(to: 0)
                }
            }
        }
    }

    private func fillUpgradeModel(
        with stepModel: Any,
        for stepViewController: VFGBaseUpgradeStepsViewControllerProtocol
    ) {
        switch stepViewController {
        case is VFGChooseDeviceViewController:
            if let device = stepModel as? ChooseDeviceModel.Device {
                upgradeModel.chooseDevice = device
            }
        case is VFGDeviceViewController:
            if let deviceDetails = stepModel as? (
                device: ChooseDeviceModel.Device,
                collectionAndDelivery: [VFGDeviceModel.CollectionAndDelivery]
            ) {
                upgradeModel.deviceDetails = deviceDetails.device
                upgradeModel.collectionAndDelivery = deviceDetails.collectionAndDelivery
            }
        case is VFGUpgradePlanViewController:
            if let planModel = stepModel as? VFGUpgradePlanModel.Plan {
                upgradeModel.planModel = planModel
            }
        case is VFGUpgradeSummaryViewController:
            break
        default:
            break
        }
    }

    private func updatePriceView(
        with stepModel: Any,
        for stepViewController: VFGBaseUpgradeStepsViewControllerProtocol
    ) {
        if stepViewController is VFGChooseDeviceViewController {
            priceViewHeightConstraint.constant = priceViewHeightConstant
            priceView.isHidden = false
        }

        if let device = stepModel as? ChooseDeviceModel.Device {
            deviceModelLabel.text = device.title
            upfrontPriceLabel.text = "\(device.price?.upfrontPrice ?? 0)\(device.price?.currency ?? "€")"
            installmentPriceLabel.text = "\(device.price?.recurringPrice ?? 0)\(device.price?.currency ?? "€")"
        }
    }

    private func setupCollectionView() {
        collectionView.contentInset = UIEdgeInsets.zero
        collectionView.scrollIndicatorInsets = UIEdgeInsets.zero
        collectionView.delegate = self
        collectionView.dataSource = self

        registerCollectionCell()
    }

    private func registerCollectionCell() {
        collectionView.register(
            UINib(nibName: stepsCollectionCellNibName, bundle: .mva10Framework),
            forCellWithReuseIdentifier: stepsCollectionCellId
        )
    }

    private func confirm() {
        let confirmModel = VFGConfirmModel(
            title: String(
                format: "device_upgrade_summary_confirm_success_title".localized(bundle: .mva10Framework),
                "Phil"),
            details: String(
                format: "device_upgrade_summary_confirm_success_first_subtitle".localized(bundle: .mva10Framework),
                upgradeModel.planModel?.name ?? "",
                upgradeModel.chooseDevice?.title ?? "",
                "today" // todo: should come from the app
            ),
            subtitle: "device_upgrade_summary_confirm_success_second_subtitle".localized(bundle: .mva10Framework),
            buttonTitle: "refer_a_friend_return_to_dashboard_button".localized( bundle: .mva10Framework)
            )

        let confirmViewController = VFGConfirmViewController.create(confirmModel: confirmModel)

        confirmViewController.closeDidTap = { [weak self] in
            (self?.navigationController as? MVA10NavigationController)?.closeTapped()
        }

        confirmViewController.modalPresentationStyle = .fullScreen
        present(confirmViewController, animated: false)
    }

    private func setupCostBreakdownView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onCostBreakdownDidPress(_:)))
        costBreakdownStackView.addGestureRecognizer(tapGesture)
    }

    @objc func onCostBreakdownDidPress(_ sender: UIButton) {
        guard let selectedDevice = selectedDevice,
            let planViewController = stepsViewControllers[2] as? VFGUpgradePlanViewController
        else { return }
        let costBreakdownQuickActionModel = CostBreakdownQuickActionModel(
            device: selectedDevice,
            plan: planViewController.status == .passed ? upgradeModel.planModel : nil
        )
        VFQuickActionsViewController.presentQuickActionsViewController(with: costBreakdownQuickActionModel)
    }
}

extension VFGUpgradeViewController: VFGTrayContainerProtocol {
    public var trayStyle: VFGTrayStyle {
        .TOBI
    }

    public var tobiKey: String {
        "VFGUpgradeViewController"
    }

    public var tobiContainerVC: UIViewController? {
        return VFGManagerFramework.tobiDelegate?.helpViewController(for:
            "\(VFGUpgradeViewController.self)")
    }
}

extension VFGUpgradeViewController {
    private func setupAccessibilityLabels() {
        [
            stepsView, upfrontPriceLabel, upfrontLabel, installmentPriceLabel,
            installmentPeriodLabel, contractMonthsLabel, contractPeriodLabel, costBreakdownLabel
        ]
            .forEach { $0?.isAccessibilityElement = false }

        [upfrontStackView, installmentStackView, contractStackView, costBreakdownStackView]
            .forEach { $0?.isAccessibilityElement = true }

        let upfrontAXText = (upfrontPriceLabel.text ?? "") + (upfrontLabel.text ?? "")
        let installmentAXText = (installmentPriceLabel.text ?? "") + (installmentPeriodLabel.text ?? "")
        let contractAXText = (contractMonthsLabel.text ?? "") + (contractPeriodLabel.text ?? "")

        upfrontStackView.accessibilityLabel = upfrontAXText
        installmentStackView.accessibilityLabel = installmentAXText
        contractStackView.accessibilityLabel = contractAXText
        costBreakdownStackView.accessibilityTraits = [.button]
        costBreakdownStackView.accessibilityLabel = costBreakdownLabel.text
        costBreakdownStackView.accessibilityIdentifier = "costBreakdownButtonID"
    }
}
