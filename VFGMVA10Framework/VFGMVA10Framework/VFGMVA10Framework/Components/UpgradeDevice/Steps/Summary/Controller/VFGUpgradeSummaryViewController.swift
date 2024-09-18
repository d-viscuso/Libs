//
//  VFGUpgradeSummaryViewController.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 1/06/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFGUpgradeSummaryViewController: UIViewController, VFGBaseUpgradeStepsViewControllerProtocol {
    @IBOutlet weak var summaryTableView: UITableView!

    static var instance: VFGBaseUpgradeStepsViewControllerProtocol {
        UIStoryboard(
            name: "VFGUpgradeSummaryViewController",
            bundle: .mva10Framework
        ).instantiateViewController(withIdentifier: "UpgradeSummary")
        as? VFGUpgradeSummaryViewController ?? VFGUpgradeSummaryViewController()
    }

    var stepTitle: String = "device_upgrade_summary_step_title".localized(bundle: .mva10Framework)
    var onStepComplete: ((Any) -> Void)?
    var onStepBackToStart: (() -> Void)?
    var onContentHeightChange: ((CGFloat) -> Void)?
    var onPriceChange: ((Any) -> Void)?
    var onStepStatusChange: ((VFGStepStatus) -> Void)?
    var status: VFGStepStatus = .pending

    var upgradeModel: VFGUpgradeModel? {
        didSet {
            summaryTableView.reloadData()
        }
    }

    var collectionAndDeliveryDataSource: VFGCollectionAndDeliveryDataSource?
    var paymentDataSource: VFGPaymentDataSource?
    var addressDataSource: VFGAddressDataSource?

    var isPlanExpanded = false
    var isAddressRowHidden = false
    let sections = (device: 0, plan: 1, payment: 2, totalCost: 3)
    let paymentAndDeliveryRows = (payment: 0, delivery: 1, address: 2)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSummaryTableView()
        preparePaymentAndDeliverySelection()
    }

    func setupSummaryTableView() {
        summaryTableView.delegate = self
        summaryTableView.dataSource = self
        summaryTableView.sectionHeaderHeight = UITableView.automaticDimension
        summaryTableView.rowHeight = UITableView.automaticDimension
        summaryTableView.estimatedSectionHeaderHeight = 40.0
        summaryTableView.estimatedRowHeight = 560.0

        summaryTableView.register(
            UINib(nibName: String(describing: VFGUpgradeSummarySectionHeaderView.self), bundle: .mva10Framework),
            forHeaderFooterViewReuseIdentifier: String(describing: VFGUpgradeSummarySectionHeaderView.self)
        )

        summaryTableView.register(
            UINib(nibName: String(describing: "VFGUpgradeSummarySectionFooterView"), bundle: .mva10Framework),
            forHeaderFooterViewReuseIdentifier: String(describing: "VFGUpgradeSummarySectionFooterView")
        )

        summaryTableView.register(
            UINib(nibName: String(describing: VFGUpgradeDeviceCell.self), bundle: .mva10Framework),
            forCellReuseIdentifier: String(describing: VFGUpgradeDeviceCell.self)
        )

        summaryTableView.register(
            UINib(nibName: String(describing: UpgradePlanCell.self), bundle: .mva10Framework),
            forCellReuseIdentifier: String(describing: UpgradePlanCell.self)
        )

        summaryTableView.register(
            UINib(nibName: String(describing: VFGUpgradeCostCell.self), bundle: .mva10Framework),
            forCellReuseIdentifier: String(describing: VFGUpgradeCostCell.self)
        )

        summaryTableView.register(
            UINib(nibName: String(describing: VFGDeviceCapacitySelectionCell.self), bundle: .mva10Framework),
            forCellReuseIdentifier: String(describing: VFGDeviceCapacitySelectionCell.self)
        )

        summaryTableView.register(
            UINib(nibName: String(describing: VFGConfirmFooterView.self), bundle: .mva10Framework),
            forHeaderFooterViewReuseIdentifier: String(describing: VFGConfirmFooterView.self)
        )
    }

    func preparePaymentAndDeliverySelection() {
        if status == .pending {
            collectionAndDeliveryDataSource?.selectedIndex = 0
            paymentDataSource?.selectedIndex = 0
            addressDataSource?.selectedIndex = 0
            isAddressRowHidden = false
            summaryTableView.reloadData()
        }
    }
}

extension VFGUpgradeSummaryViewController: UpgradePlanCellDelegate {
    func planHeaderViewButtonDidPress(for indexPath: IndexPath, isExpanded: Bool) {
        isPlanExpanded.toggle()
        summaryTableView.reloadRows(at: [indexPath], with: .fade)
    }
}

extension VFGUpgradeSummaryViewController: VFGSelectionViewDelegate {
    func selectionView(_ selectionView: VFGSelectionView, didSelectItemAt index: Int) {
        // todo: localization
        if selectionView.dataSource?.titleForSelection(at: index) == "Home delivery",
            isAddressRowHidden {
            isAddressRowHidden = false
            summaryTableView.reloadData()
        } else if selectionView.dataSource?.titleForSelection(at: index) == "Pick up in store",
            !isAddressRowHidden {
            isAddressRowHidden = true
            summaryTableView.reloadData()
        }
    }
}

extension VFGUpgradeSummaryViewController: VFGConfirmViewDelegate {
    func confirmButtonDidPress(_ confirmView: VFGConfirmView) {
        onStepComplete?(self)
    }

    func hyperLinkDidPress(_ confirmView: VFGConfirmView, url: String) {
        let viewController = webViewController(with: url)
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: true)
    }

    func webViewController(with url: String) -> UIViewController {
        let viewModel = VFGWebViewModel(urlString: url)
        return VFGWebViewController.instance(with: viewModel, delegate: self)
    }
}

extension VFGUpgradeSummaryViewController: VFGWebViewDelegate {
    public func close(sender viewController: VFGWebViewController) {
        dismiss(animated: true)
    }
}

extension VFGUpgradeSummaryViewController: VFGUpgradeCostCellDelegate {
    func breakdownRowDidPress() {
        let indexPath = IndexPath(row: 0, section: sections.totalCost)
        guard let cell = summaryTableView.cellForRow(at: indexPath ) as? VFGUpgradeCostCell else { return }

        cell.isBreakdownCollapsed.toggle()

        UIView.setAnimationsEnabled(false)
        summaryTableView.beginUpdates()
        summaryTableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
}

extension VFGUpgradeSummaryViewController {
    func onUpgradeSummeryEditDidPress() {
        status = .passed
        onStepBackToStart?()
    }
}
