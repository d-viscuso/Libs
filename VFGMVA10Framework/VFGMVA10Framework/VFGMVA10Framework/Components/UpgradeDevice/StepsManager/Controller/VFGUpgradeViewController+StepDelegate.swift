//
//  VFGUpgradeViewController+StepDelegate.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 18/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGUpgradeViewController: VFGHorizontalStepControlDelegate {
    public func stepControl(_ stepControl: VFGHorizontalStepControl, didCompleteStepAt index: Int) {
        guard index + 1 < stepsViewControllers.count else {
            return
        }

        let indexPath = IndexPath(item: index + 1, section: 0)
        lastPassedStepIndex = index
        moveToCell(at: indexPath.row)

        // Inject selected device to VFGDeviceViewController
        if let deviceViewController = stepsViewControllers[indexPath.row] as? VFGDeviceViewController {
            deviceViewController.viewModel.selectedDevice = upgradeModel.chooseDevice
        } else if let summaryViewController = stepsViewControllers[indexPath.row] as? VFGUpgradeSummaryViewController {
            summaryViewController.upgradeModel = upgradeModel
            summaryViewController.preparePaymentAndDeliverySelection()
        }

        stepsViewControllers[indexPath.row].fetchData()
    }

    public func stepControl(_ stepControl: VFGHorizontalStepControl, didMoveToStepAt index: Int) {
        togglePriceViewAppearance(for: index)
        toggleCostBreakdownViewAppearance(for: index)
        moveToCell(at: index)
    }

    public func stepControl(_ stepControl: VFGHorizontalStepControl, didReturnToStepAt index: Int) {
        togglePriceViewAppearance(for: index)
        toggleCostBreakdownViewAppearance(for: index)
        moveToCell(at: index)
    }

    func togglePriceViewAppearance(for index: Int, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let self = self else {
                return
            }

            self.priceViewHeightConstraint.constant = index == 0 ? 0 : self.priceViewHeightConstant
            self.priceView.isHidden = index == 0
        }, completion: { _ in completion?() })
    }

    func toggleCostBreakdownViewAppearance(for index: Int, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            guard let self = self else {
                return
            }
            self.costBreakdownStackView.alpha = index == (self.stepsViewControllers.count - 1) ? 0 : 1
        }, completion: { [weak self] _ in
            guard let self = self else {
                return
            }
            self.costBreakdownStackView.isHidden = index == (self.stepsViewControllers.count - 1)
            completion?()
        })
    }

    func moveToCell(at index: Int) {
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.collectionView.scrollToItem(
                at: IndexPath(item: index, section: 0),
                at: .centeredHorizontally,
                animated: false
            )
            self?.collectionView.layoutIfNeeded()
        }
    }
}

// MARK: VFGStepControlDataSource
extension VFGUpgradeViewController: VFGHorizontalStepControlDataSource {
    public func numberOfSteps(_ stepControl: VFGHorizontalStepControl) -> Int {
        stepsViewControllers.count
    }

    public func title(_ stepControl: VFGHorizontalStepControl, forStepAt index: Int) -> String {
        stepsViewControllers[index].stepTitle
    }

    public func status(_ stepControl: VFGHorizontalStepControl, forStepAt index: Int) -> VFGStepStatus {
        stepsViewControllers[index].status
    }
}
