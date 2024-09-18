//
//  VFGBookAppointmentViewController+VFGHorizontalStepControl.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/12/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

// MARK: VFGHorizontalStepControlDelegate
extension VFGBookAppointmentViewController: VFGHorizontalStepControlDelegate {
    func stepControl(_ stepControl: VFGHorizontalStepControl, didCompleteStepAt index: Int) {
        guard index + 1 < stepsViewControllers.count else {
            return
        }

        let indexPath = IndexPath(item: index + 1, section: 0)
        // Here animate used to solve the fliker when displaying a step that has shimmer
        UIView.animate(withDuration: 0.4) {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            self.collectionView.layoutIfNeeded()
        }

        if let summaryVC = stepsViewControllers[indexPath.row] as? VFGSummaryStepViewControllerProtocol {
            summaryVC.summarize(with: appointment)
        } else {
            stepsViewControllers[indexPath.row].fetchData()
        }
    }

    func stepControl(_ stepControl: VFGHorizontalStepControl, didReturnToStepAt index: Int) {
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
    }
}

// MARK: VFGStepControlDataSource
extension VFGBookAppointmentViewController: VFGHorizontalStepControlDataSource {
    func numberOfSteps(_ stepControl: VFGHorizontalStepControl) -> Int {
        stepsViewControllers.count
    }

    func title(_ stepControl: VFGHorizontalStepControl, forStepAt index: Int) -> String {
        stepsViewControllers[index].stepTitle
    }
}
