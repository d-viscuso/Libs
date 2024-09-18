//
//  VFGUpgradePlanViewController.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 5/19/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

class VFGUpgradePlanViewController: UIViewController, VFGBaseUpgradeStepsViewControllerProtocol {
    // MARK: Outlets
    @IBOutlet weak var plansTableView: UITableView!
    @IBOutlet var plansTableViewHeaderView: UIView!
    @IBOutlet weak var headerTitleLabel: VFGLabel!

    var stepTitle: String = "device_upgrade_plan_step_title".localized(bundle: .mva10Framework)
    var onStepComplete: ((Any) -> Void)?
    var onContentHeightChange: ((CGFloat) -> Void)?
    var onPriceChange: ((Any) -> Void)?
    var onStepStatusChange: ((VFGStepStatus) -> Void)?
    var status: VFGStepStatus = .pending {
        didSet {
            viewModel.stepStatus = status
        }
    }
    lazy var viewModel: VFGUpgradePlanViewModel = {
        VFGUpgradePlanViewModel(
            dataProvider: VFGUpgradePlanDataProvider())
    }()
    static var instance: VFGBaseUpgradeStepsViewControllerProtocol {
        UIStoryboard(
            name: "VFGUpgradePlanViewController",
            bundle: .mva10Framework
        ).instantiateViewController(withIdentifier: "UpgradePlan")
        as? VFGUpgradePlanViewController ?? VFGUpgradePlanViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlansTableView()
        initViewModel()
        setupLocalization()
        initStepStatus()
        setAccessibilityForVoiceOver()
        setupAccessibilityIdentifier()
    }

    private func initViewModel() {
        viewModel.updateLoadingStatus = { [weak self] in
            guard let self = self else {
                return
            }

            switch self.viewModel.contentState {
            case .loading:
                break
            case .populated:
                self.plansTableView.reloadData()
            case .empty:
                break
            case .error:
                break
            case .filtered:
                break
            }
        }

        viewModel.fetchPlans()
    }

    func setupLocalization() {
        headerTitleLabel.text = "device_upgrade_plan_screen_title".localized(bundle: .mva10Framework)
    }

    func initStepStatus() {
        viewModel.onStepStatusChange = onStepStatusChange
    }

    func fetchData() {
        viewModel.fetchPlans()
    }
}

extension VFGUpgradePlanViewController: UITableViewDelegate, UITableViewDataSource {
    func setupPlansTableView() {
        plansTableView.delegate = self
        plansTableView.dataSource = self
        plansTableView.sectionHeaderHeight = UITableView.automaticDimension
        plansTableView.rowHeight = UITableView.automaticDimension
        plansTableView.estimatedSectionHeaderHeight = 40.0
        plansTableView.estimatedRowHeight = 560.0
        plansTableView.tableHeaderView = plansTableViewHeaderView

        let planCellNib = UINib(nibName: String(describing: UpgradePlanCell.self), bundle: Bundle.mva10Framework)
        let planSectionNib = UINib(
            nibName: String(describing: UpgradePlanSectionHeaderView.self),
            bundle: Bundle.mva10Framework)
        plansTableView.register(
            planCellNib,
            forCellReuseIdentifier: String(describing: UpgradePlanCell.self))
        plansTableView.register(
            planSectionNib,
            forHeaderFooterViewReuseIdentifier: String(describing: UpgradePlanSectionHeaderView.self))
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return viewModel.numberOfOtherPlans()
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: UpgradePlanCell.self),
            for: indexPath) as? UpgradePlanCell else {
            return UITableViewCell()
        }
        switch indexPath.section {
        case 0:
            guard let model = viewModel.getCurrentPlan() else {
                return UITableViewCell()
            }
            cell.setup(model: model, indexPath: indexPath, delegate: self)
            return cell
        case 1:
            guard let model = viewModel.getOtherPlan(at: indexPath.row) else {
                return UITableViewCell()
            }
            cell.setup(model: model, indexPath: indexPath, delegate: self)
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(
                describing: UpgradePlanSectionHeaderView.self)) as? UpgradePlanSectionHeaderView else {
            return nil
        }

        let title: String?

        switch section {
        case 0:
            title = "device_upgrade_plan_screen_my_plan_title".localized(bundle: .mva10Framework)
        case 1:
            title = "device_upgrade_plan_screen_other_plans_title".localized(bundle: .mva10Framework)
        default:
            title = nil
        }
        headerView.setup(sectionTitle: title)
        return headerView
    }
}

extension VFGUpgradePlanViewController: UpgradePlanCellDelegate {
    func planHeaderViewButtonDidPress(for indexPath: IndexPath, isExpanded: Bool) {
        viewModel.setPlanExpandCollapse(for: indexPath, isExpanded: !isExpanded) { [weak self] in
            self?.plansTableView.reloadRows(at: [indexPath], with: .fade)
        }
    }

    func recommendedInfoButtonDidPress() {
    }

    func choosePlanButtonDidPress(for indexPath: IndexPath) {
        guard let plans = viewModel.plans else {
            return
        }
        viewModel.checkIsSelectedPlanEqualPlan(at: indexPath)
        switch indexPath.section {
        case 0:
            viewModel.selectedPlan = plans.currentPlan
            let isRecommended = plans.currentPlan.isRecommended ?? false
            plansTableView.scrollToRow(at: indexPath, at: isRecommended ? .middle : .top, animated: false)
        case 1:
            viewModel.selectedPlan = plans.otherPlans[indexPath.row]
            let isRecommended = plans.otherPlans[indexPath.row].isRecommended ?? false
            plansTableView.scrollToRow(at: indexPath, at: isRecommended ? .middle : .top, animated: false)
        default:
            return
        }
        status = .passed
        onStepComplete?(
            indexPath.section == 0 ? plans.currentPlan : plans.otherPlans[indexPath.row]
        )
    }
}

extension VFGUpgradePlanViewController {
    /// set accessibility for voice over
    func setAccessibilityForVoiceOver() {
        headerTitleLabel.accessibilityLabel = headerTitleLabel.text
    }

    /// set accessibility identifier
    func setupAccessibilityIdentifier() {
        headerTitleLabel.accessibilityIdentifier = "UDChoosePlanID"
    }
}
