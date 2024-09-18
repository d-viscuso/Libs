//
//  VFGUpgradePlanViewModel.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 5/19/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class VFGUpgradePlanViewModel {
    private let dataProvider: VFGUpgradePlanDataProviderProtocol
    private(set) var plans: VFGUpgradePlanModel?
    private var currentPlan: VFGPlanCellUIModel?
    private var otherPlans: [VFGPlanCellUIModel] = []
    var selectedPlan: VFGUpgradePlanModel.Plan?

    var contentState: VFGContentState = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var stepStatus: VFGStepStatus?
    var updateLoadingStatus: (() -> Void)?
    var onStepStatusChange: ((VFGStepStatus) -> Void)?

    init(dataProvider: VFGUpgradePlanDataProviderProtocol = VFGUpgradePlanDataProvider()) {
        self.dataProvider = dataProvider
    }

    func fetchPlans() {
        contentState = .loading
        dataProvider.fetchPlans { [weak self] plans, _ in
            guard let plans = plans else {
                self?.contentState = .error
                return
            }
            self?.plans = plans
            if self?.stepStatus == .pending {
                self?.selectedPlan = nil
            }
            self?.prepareCurrentPlanUIModel(plan: plans.currentPlan)
            self?.prepareOtherPlansUIModel(plans: plans.otherPlans)
            self?.contentState = .populated
        }
    }

    func numberOfOtherPlans() -> Int {
        otherPlans.count
    }

    func getCurrentPlan() -> VFGPlanCellUIModel? {
        currentPlan
    }

    func getOtherPlan(at index: Int) -> VFGPlanCellUIModel? {
        guard index < otherPlans.count else {
            return nil
        }
        return otherPlans[index]
    }

    func setPlanExpandCollapse(for indexPath: IndexPath, isExpanded: Bool, completion: (() -> Void)? = nil) {
        switch indexPath.section {
        case 0:
            currentPlan?.isExpanded = isExpanded
            completion?()
        case 1:
            if !otherPlans.isEmpty, indexPath.row < otherPlans.count {
                otherPlans[indexPath.row].isExpanded = isExpanded
                completion?()
            }
        default:
            break
        }
    }

    private func prepareCurrentPlanUIModel(plan: VFGUpgradePlanModel.Plan) {
        currentPlan = VFGPlanCellUIModel(
            id: plan.id,
            name: plan.name,
            imageURL: plan.imageURL,
            price: plan.price,
            subscriptions: plan.subscriptions,
            isRecommended: false,
            isExpanded: selectedPlan == plan)
        return
    }

    private func prepareOtherPlansUIModel(plans: [VFGUpgradePlanModel.Plan]) {
        let sortedPlans = plans.sorted { ($0.isRecommended ?? false) && !($1.isRecommended ?? false) }
        var otherPlansUIModel = sortedPlans.map { VFGPlanCellUIModel(
            id: $0.id,
            name: $0.name,
            imageURL: $0.imageURL,
            price: $0.price,
            subscriptions: $0.subscriptions,
            isRecommended: $0.isRecommended ?? false,
            isExpanded: selectedPlan == $0)
        }
        if !otherPlansUIModel.isEmpty, otherPlansUIModel[0].isRecommended && selectedPlan == nil {
            otherPlansUIModel[0].isExpanded = true
        }
        otherPlans = otherPlansUIModel
    }

    func checkIsSelectedPlanEqualPlan(at indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if selectedPlan != plans?.currentPlan {
                onStepStatusChange?(.pending)
            }
        case 1:
            if selectedPlan != plans?.otherPlans[indexPath.row] {
                onStepStatusChange?(.pending)
            }
        default:
            return
        }
    }
}
