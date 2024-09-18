//
//  VFGBookAppointmentViewController+UITableView.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/12/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

// MARK: UICollectionViewDataSource
extension VFGBookAppointmentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        stepsViewControllers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: stepsCollectionCellId,
            for: indexPath) as? StepsCollectionCell else {
            return UICollectionViewCell()
        }

        cell.hostedController = stepsViewControllers[indexPath.row]
        if indexPath.row != stepController.currentStepIndex {
            cell.isAccessibilityElement = false
            cell.accessibilityElementsHidden = false
        }
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension VFGBookAppointmentViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
